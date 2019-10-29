import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/Oceny.dart';
import 'package:mobilna_politechnika/Map.dart';

import 'Profil.dart';

class MyDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Witaj Imię Nazwisko', style: TextStyle(color: Colors.white),),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 128, 1, 0),
              ),
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new Profile()));
                },
            ),
            ListTile(
              title: Text('Oceny'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new Oceny()));
              },
            ),
            ListTile(
              title: Text('Mapa'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, new MaterialPageRoute(builder: (context) => new Map()));
              },
            ),
            ListTile(
              title: Text('Wyloguj'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
            ),
          ],
        )
    );
  }
}