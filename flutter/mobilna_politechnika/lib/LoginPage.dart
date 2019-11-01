import 'package:flutter/material.dart';

import 'api.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
            reverse: true,
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Center(
                  child: Column(children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        margin: EdgeInsets.only(bottom: 20),
                        width: double.infinity,
                        color: Color.fromARGB(255, 128, 1, 0),
                        child: Text(
                          'PŁ',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 125, color: Colors.white),
                        )),
                    /*Container(
                        child: Text(
                      'Witamy w aplikacji \nMobilna Politechnika',
                      textAlign: TextAlign.center,
                    )),*/
                    MyCustomForm()
                  ]),
                ))));
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    // TODO: implement createState
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final loginController = TextEditingController(text: 'Login');
  final passwordController = TextEditingController(text: "Haslo");

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: loginController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Wpisz coś';
                } else
                  return null;
              },
            ),
            TextFormField(
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
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Logowanie'),
                  ));

                  var isLogged = await API.login(
                      loginController.text, passwordController.text);

                  Scaffold.of(context).hideCurrentSnackBar();

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
