import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'locale.dart';
import 'grades.dart';
import 'map.dart';
import 'schedule.dart';
import 'profile.dart';
import 'easter.dart';
import 'user.dart';

int taps = 0;

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    taps = 0;
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(User.instance.name),
          accountEmail: Text(User.instance.mail),
          currentAccountPicture: GestureDetector(
            onDoubleTap: () {
              taps++;
              if (taps >= 4) {
                taps = 0;
                Navigator.pop(context);
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new Easter()));
              }
            },
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new Profile()));
            },
            child: new CircleAvatar(
              backgroundColor: Colors.brown.shade800,
              child: Text(User.instance.name[0].toUpperCase()),
            ),
          ),
        ),
        ListTile(
          title: Text(Locale.current['profile']),
          leading: Icon(Icons.account_circle),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Profile()));
          },
        ),
        ListTile(
          title: Text(Locale.current['grades']),
          leading: Icon(Icons.format_list_numbered),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Grades()));
          },
        ),
        ListTile(
          title: Text(Locale.current['map']),
          leading: Icon(Icons.map),
          onTap: () {
            Navigator.pop(context);
            MapState.target = ""; // Clear target
            Navigator.of(context).pushNamed('/Map');
          },
        ),
        ListTile(
          title: Text(Locale.current['schedule']),
          leading: Icon(Icons.calendar_today),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new GroupTimetable()));
          },
        ),
        ListTile(
          title: Text("O aplikacji"),
          leading: Icon(Icons.question_answer),
          onTap: () {
            showAboutDialog(
                context: context,
                applicationVersion: "0.0.0",
                applicationLegalese:
                    "Developed for PŁ course Aplikacje Mobilne and Chmura Obliczeniowa.");
          },
        ),
        Divider(),
        ListTile(
          title: Text(Locale.current['logout']),
          leading: Icon(Icons.arrow_back),
          onTap: () async {
            Navigator.pop(context);
            SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
            API.logout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false);
          },
        ),
      ],
    ));
  }
}
