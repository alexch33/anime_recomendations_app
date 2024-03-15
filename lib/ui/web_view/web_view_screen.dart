import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

const DEFAULT_USER_AGENT =
    'Mozilla/5.0 (Linux; U; Android 2.2; en-gb; Nexus One Build/FRF50) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String _url = 'https://google.com';
  int _progress = 0;
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _domainRegex =
      RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$');
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _url = ModalRoute.of(context)!.settings.arguments as String;
    _urlController.text = _url;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: TextField(
              focusNode: _focusNode,
              controller: _urlController,
              onSubmitted: _onUrlFieldSubmitted,
              decoration: const InputDecoration(
                hintText: 'Enter URL',
              ),
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.open_in_browser),
                  onPressed: () => _launchInBrowser(_urlController.text)),
              IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () async =>
                      _shareLink(await _webViewController.getOriginalUrl()))
            ],
          ),
          body: Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        if (await _webViewController.canGoBack()) {
                          await _webViewController.goBack();
                        }
                      },
                      icon: Icon(Icons.arrow_back)),
                  IconButton(
                      onPressed: () async {
                        if (await _webViewController.canGoForward()) {
                          await _webViewController.goForward();
                        }
                      },
                      icon: Icon(Icons.arrow_forward)),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          icon: _progress < 100
                              ? Icon(Icons.cancel_outlined)
                              : Icon(Icons.refresh),
                          onPressed: () async {
                            if (_progress < 100) {
                              await _webViewController.stopLoading();
                            } else {
                              await _webViewController.reload();
                            }
                          }),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      initialUrlRequest:
                          URLRequest(url: WebUri.uri(Uri.parse(_url))),
                      onWebViewCreated:
                          (InAppWebViewController webViewController) {
                        _webViewController = webViewController;
                      },
                      onProgressChanged: (_, progress) {
                        setState(() {
                          this._progress = progress;
                        });
                      },
                      onUpdateVisitedHistory: (_, uri, __) {
                        if (!_focusNode.hasFocus) {
                          _urlController.text = uri.toString();
                        }
                      },
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: _progress < 100
                            ? LinearProgressIndicator(
                                minHeight: 5,
                                value: _progress.toDouble() / 100,
                                color: Colors.amber,
                              )
                            : const SizedBox.shrink()),
                  ],
                ),
              )
            ],
          )),
    );
  }

  void _launchInBrowser(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _shareLink(WebUri? url) async {
    if (url != null && url.isValidUri) {
      await Share.shareUri(url.uriValue);
    }
  }

  void _onUrlFieldSubmitted(text) async {
    final uri = Uri.parse(text);
    final isHttp = text.startsWith("http");
    final isDomain = _domainRegex.hasMatch(text);

    if (isHttp && await canLaunchUrl(uri)) {
      _webViewController.loadUrl(urlRequest: URLRequest(url: WebUri.uri(uri)));
    } else if (!isHttp &&
        isDomain &&
        await canLaunchUrl(Uri.parse("https://$text"))) {
      _webViewController.loadUrl(
          urlRequest: URLRequest(url: WebUri.uri(Uri.parse("https://$text"))));
    } else {
      final urlToGo =
          WebUri.uri(Uri.parse("https://www.google.com/search?q=$text"));
      _webViewController.loadUrl(urlRequest: URLRequest(url: urlToGo));
    }
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
