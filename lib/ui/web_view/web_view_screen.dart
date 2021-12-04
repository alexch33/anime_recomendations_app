import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

const DEFAULT_USER_AGENT =
    'Mozilla/5.0 (Linux; U; Android 2.2; en-gb; Nexus One Build/FRF50) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String url = 'https://google.com';
  int progress = 0;
  late WebViewController _webViewController;

  @override
  void initState() {
    WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String url = ModalRoute.of(context)!.settings.arguments as String;

    if (url.isNotEmpty) {
      if (url.contains("https")) {
        this.url = url;
      } else {
        this.url = url.replaceAll("http", "https");
      }
    }
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
                    WebView(
                      initialUrl: url,
                      userAgent: DEFAULT_USER_AGENT,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _webViewController = webViewController;
                      },
                      onProgress: (progress) {
                        setState(() {
                          this.progress = progress;
                        });
                      },
                      gestureRecognizers:
                          <Factory<VerticalDragGestureRecognizer>>[
                        new Factory<VerticalDragGestureRecognizer>(
                          () => new VerticalDragGestureRecognizer()
                            ..onDown = (DragDownDetails details) {
                              _webViewController.getScrollY().then((value) {
                                if (value == 0 &&
                                    details.globalPosition.direction < 0.5) {
                                  _webViewController.reload();
                                }
                              });
                            },
                        ),
                      ].toSet(),
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
}
