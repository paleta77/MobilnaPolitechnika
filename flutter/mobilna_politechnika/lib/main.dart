import 'package:flutter/material.dart';

import 'login-page.dart';
import 'profile.dart';

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