import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'api.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'PŁ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 125, color: Colors.white),
                    )
                  ]))),
      Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              decoration: InputDecoration(hintText: "Login"),
              controller: loginController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Wpisz coś';
                } else
                  return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Hasło"),
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Wpisz coś';
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
                    content: Text('Logowanie'),
                  ));

                  var isLogged = await API.login(
                      loginController.text, passwordController.text);

                  if (isLogged) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/Profile', (Route<dynamic> route) => false);
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: new Text("Błąd"),
                            content: new Text(
                                "Wystąpił problem podczas proby zalogowania, sprawdz dane logowania."),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Close"),
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
              child: Text("Zaloguj"),
            )
          ],
        ));
  }
}
