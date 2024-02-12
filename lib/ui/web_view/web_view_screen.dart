import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

const DEFAULT_USER_AGENT =
    'Mozilla/5.0 (Linux; U; Android 2.2; en-gb; Nexus One Build/FRF50) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String url = 'https://google.com';
  int progress = 0;
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

    url = ModalRoute.of(context)!.settings.arguments as String;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool isCanGoBack = await _webViewController.canGoBack();

        if (isCanGoBack) {
          _webViewController.goBack();
          return false;
        }

        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(url),
          ),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    InAppWebView(
                      initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))),
                      onWebViewCreated:
                          (InAppWebViewController webViewController) {
                        _webViewController = webViewController;
                      },
                      onProgressChanged: (controlle, progress) {
                        setState(() {
                          this.progress = progress;
                        });
                      },
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: progress < 100
                            ? LinearProgressIndicator(
                                minHeight: 5,
                                value: progress.toDouble() / 100,
                                color: Colors.amber,
                              )
                            : SizedBox.shrink()),
                  ],
                ),
              )
            ],
          )),
    );
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
