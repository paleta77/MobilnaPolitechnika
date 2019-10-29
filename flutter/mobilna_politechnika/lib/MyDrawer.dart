import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/Oceny.dart';
import 'package:mobilna_politechnika/Map.dart';

import 'Profil.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Student Student"),
          accountEmail: Text("11111@edu.p.lodz.pl"),
          currentAccountPicture: new CircleAvatar(
            backgroundColor: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        ListTile(
          title: Text('Profil'),
          leading: Icon(Icons.account_circle),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Profile()));
          },
        ),
        ListTile(
          title: Text('Oceny'),
          leading: Icon(Icons.format_list_numbered),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Oceny()));
          },
        ),
        ListTile(
          title: Text('Mapa'),
          leading: Icon(Icons.map),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new Map()));
          },
        ),
        Divider(),
        ListTile(
          title: Text('Wyloguj'),
          leading: Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          },
        ),
      ],
    ));
  }
}
