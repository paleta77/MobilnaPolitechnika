import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'locale.dart';
import 'side-drawer.dart';

class Map extends StatefulWidget {
  @override
  MapState createState() => new MapState();
}

class MapState extends State<Map> {
  WebViewController controller;
  static String target = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Locale.current['map']),
        ),
        drawer: SideDrawer(),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    child: WebView(
                  onWebViewCreated: (webViewController) {
                    controller = webViewController;
                  },
                  initialUrl:
                      'http://mojmegatestkolejny.azurewebsites.net/nav/' +
                          (target.length > 0 ? ('?target=' + target) : ''),
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                        name: 'host',
                        onMessageReceived: (JavascriptMessage msg) {
                          print(msg.message);
                        })
                  ]),
                  onPageFinished: (String url) {},
                )),
              ),
            ],
          ),
        ));
  }
}
