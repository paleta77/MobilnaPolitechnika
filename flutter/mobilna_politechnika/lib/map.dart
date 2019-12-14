import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'locale.dart';
import 'user.dart';
import 'side-drawer.dart';

class Map extends StatefulWidget {
  @override
  MapState createState() => new MapState();
}

class MapState extends State<Map> {
  WebViewController controller;
  static String target = "";

  void openSearch(BuildContext context) {
    showSearch(context: context, delegate: _MapSearchDelegate(this));
  }

  void setTarget(String text) {
    target = text;
    controller.evaluateJavascript('setTarget("$text")');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Locale.current['map']),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                openSearch(context);
              },
            )
          ],
        ),
        drawer: User.instance == null ? null : SideDrawer(),
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
                          if (msg.message == "open_search") {
                            openSearch(context);
                          }
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

class _MapSearchDelegate extends SearchDelegate<String> {
  final List<String> _data = <String>[
    "CTI 201/B19",
    "CTI 202/B19",
    "CTI 203/B19",
    "CTI 204/B19",
    "CTI 205/B19",
    "CTI 206/B19",
    "CTI 207/B19",
    "CTI 208/B19",
    "CTI 209/B19",
    "CTI 210/B19",
    "CTI 211/B19",
    "CTI 212/B19",
    "CTI 101/B19",
    "CTI 102/B19",
    "CTI 103/B19",
    "CTI 104/B19",
    "CTI 105/B19",
    "CTI 106/B19",
    "CTI 107/B19",
    "CTI 108/B19",
    "CTI 110/B19",
    "CTI 111/B19",
    "CTI 112/B19",
    "SPNJO"
  ];
  final MapState mapState;

  _MapSearchDelegate(this.mapState);

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions = query.isEmpty
        ? _data.take(10)
        : _data.where((str) {
            var result = query.toLowerCase().split(" ");
            var input = str.toLowerCase();

            bool flag = true;
            for (var element in result) {
              if (element.length > 0) if (!input.contains(element)) {
                flag = false;
              }
            }
            return flag;
          });

    return _SuggestionList(
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        mapState.setTarget(suggestion);
        close(context, suggestion);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      if (query.isNotEmpty)
        IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList({this.suggestions, this.onSelected});

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: const Icon(Icons.room),
          title: Text(suggestion),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
