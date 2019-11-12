import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'locale.dart';
import 'side-drawer.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => new _MapState();
}

class _MapState extends State<Map> {

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
                  initialUrl: 'http://mojmegatestkolejny.azurewebsites.net/nav/',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (String url) {
                    print('Page finished loading: $url');
                  },
                )),
              ),
            ],
          ),
        ));
  }
}
