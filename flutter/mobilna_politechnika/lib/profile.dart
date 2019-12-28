import 'package:flutter/material.dart';

import 'locale.dart';
import 'side-drawer.dart';
import 'user.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() {
    return new _ProfileState();
  }
}

class _ProfileState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        drawer: SideDrawer(),
        body: Column(children: <Widget>[
          Container(
            height: 200,
            color: Color.fromARGB(255, 128, 1, 0),
            child: Center(
                child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.white,
                ),
                Text(User.instance.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            )),
          ),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(children: <Widget>[
            Container(
                height: 50, child: Center(child: Text(User.instance.mail))),
            Container(
                height: 50,
                child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      Text(User.instance.group),
                      ButtonTheme(
                          minWidth: 1,
                          child: FlatButton(
                            onPressed: () async {
                              var result = await showSearch(
                                  context: context,
                                  delegate: _GroupSearchDelegate());
                              if (result != null) {
                                print(result);
                                setState(() {
                                  User.instance.group = result;
                                });
                              }
                            },
                            child: Icon(Icons.edit),
                          )),
                    ]))),
          ])))
        ]));
  }
}

class _GroupSearchDelegate extends SearchDelegate<String> {
  final List<String> _data = <String>["5sem infromatyka", "3sem informatyka"];
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
        : _data.where((String i) => i.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        query = suggestion;
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
  const _SuggestionList({this.suggestions, this.query, this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          leading: const Icon(Icons.group),
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style:
                  theme.textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: theme.textTheme.subhead,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
