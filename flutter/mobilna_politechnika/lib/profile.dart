import 'package:flutter/material.dart';

import 'locale.dart';
import 'side-drawer.dart';
import 'user.dart';

class Profile extends StatelessWidget {
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
            Container(height: 90, child: Center(child: Text("mail"))),
            Container(
              height: 90,
              child: RaisedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: Text("Wybierz grupe"),
                              content: new Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[],
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Zapisz"),
                                )
                              ],
                            );
                          },
                        );
                      });
                },
                child: Text("choose group"),
              ),
              color: Colors.amber,
            ),
            Container(
              height: 90,
              child: Center(child: Text("average")),
            )
          ])))
        ])

        /*Center(
          child: Text("name: " +
              User.instance.name +
              '\nmail: ' +
              User.instance.mail +
              '\ngroup: ' +
              User.instance.group)),*/
        );
  }
}
