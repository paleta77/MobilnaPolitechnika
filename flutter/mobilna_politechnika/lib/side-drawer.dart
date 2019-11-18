import 'package:flutter/material.dart';

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
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(User.instance.name),
          accountEmail: Text(User.instance.mail),
          currentAccountPicture: GestureDetector(
            onTap: () {
              //do what you want here
              taps++;
              if (taps >= 8) {
                taps = 0;
                Navigator.pop(context);
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new Easter()));
              }
            },
            child: new CircleAvatar(
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Map()));
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
        Divider(),
        ListTile(
          title: Text(Locale.current['logout']),
          leading: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
            API.logout();
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
        ),
      ],
    ));
  }
}
