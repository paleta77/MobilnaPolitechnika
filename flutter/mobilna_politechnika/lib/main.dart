import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/LoginPage.dart';
import 'package:mobilna_politechnika/Profil.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/Profile': (context) => Profile(),
      },
      title: 'Mobilna politechnika',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 128, 1, 0)
        ),
      home: LoginPage()
    );
  }
}