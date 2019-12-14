import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'locale.dart';
import 'user.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Column(children: <Widget>[
          Expanded(
              child: Container(
                  width: double.infinity,
                  color: Color.fromARGB(255, 128, 1, 0),
                  height: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MP',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 125, color: Colors.white),
                        )
                      ]))),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Container(
                    margin: new EdgeInsets.symmetric(horizontal: 16.0),
                    child: LoginForm())
              ])),
        ]));
  }
}

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: Locale.current['login']),
              controller: loginController,
              validator: (value) {
                if (value.isEmpty) {
                  return Locale.current['enter_login'];
                } else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: Locale.current['password']),
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return Locale.current['enter_password'];
                } else
                  return null;
              },
            ),
            RaisedButton(
              color: Color.fromARGB(255, 128, 1, 0),
              textColor: Colors.white,
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(Locale.current['login_text']),
                  ));
                  var isLogged = await API.login(
                      loginController.text, passwordController.text);

                  if (isLogged) {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('token', API.token);
                    var user = await API.userInfo();
                    var group = await API.getGroup();

                    User(
                        user['name'],
                        user['mail'],
                        group['field'].toString() +
                            ' ' +
                            group['semester'].toString() +
                            ' ' +
                            group['mode'].toString());

                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Profile', (Route<dynamic> route) => false);
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text(Locale.current['error']),
                            content: new Text(Locale.current['login_error']),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text(Locale.current['close']),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          );
                        });
                  }
                }
              },
              child: Text(Locale.current['login_button']),
            ),
            FlatButton(
              child: Text("Mapa kampusu"),
              onPressed: () {
                User.instance = null;
                Navigator.of(context).pushNamed('/Map');
              },
            )
          ],
        ));
  }
}
