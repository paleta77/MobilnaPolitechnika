import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(vertical: 100),
                    width: double.infinity,
                    color: Color.fromARGB(255, 128, 1, 0),
                    child : Text('PŁ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 125, color: Colors.white),
                    )
                ),
                Container(
                    child : Text('Witamy w aplikacji \nMobilna Politechnika', textAlign: TextAlign.center,)
                ),
                MyCustomForm()
              ]),
        ));
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    // TODO: implement createState
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              initialValue: "Login",
              validator: (value) {
                if (value.isEmpty) {
                  return 'Wpisz coś';
                }
                else return null;
              },
            ),
            TextFormField(
              initialValue: "Hasło",
              validator: (value) {
                if (value.isEmpty) {
                  return 'Wpisz coś';
                }
                else return null;
              },
            ),
            RaisedButton(
              onPressed: (){
                if(_formKey.currentState.validate()){
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Logowanie'),));
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute()));
                  Navigator.of(context).pushNamedAndRemoveUntil('/Profile', (Route<dynamic> route) => false);
                }
              },
              child: Text("Zaloguj"),
            )
          ],
        )
    );
  }

}