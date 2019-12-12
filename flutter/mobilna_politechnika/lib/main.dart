import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login-page.dart';
import 'profile.dart';
import 'map.dart';
import 'user.dart';
import 'api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // hmm, maybe move it somewhere else?
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String data = prefs.getString('token');
  print("Token: " + data.toString());
  if (data != null) {
    API.token = data;
    var user = await API.userInfo();
    if (user != null) {
      var group = await API.getGroup();
      User(
          user['name'],
          user['mail'],
          group['field'].toString() +
              ' ' +
              group['semester'].toString() +
              ' ' +
              group['mode'].toString());
    } else {
      API.token = null;
    }
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(User.instance.toString());
    print(API.token.toString());
    return MaterialApp(
        initialRoute: '/',
        routes: {
          '/Profile': (context) => Profile(),
          '/Login': (context) => LoginPage(),
          '/Map': (context) => Map(),
        },
        title: 'Mobilna politechnika',
        theme: ThemeData(primaryColor: Color.fromARGB(255, 128, 1, 0)),
        home: (User.instance == null || API.token == null)
            ? LoginPage()
            : Profile());
  }
}
