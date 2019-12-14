import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;

import 'api.dart';
import 'locale.dart';
import 'side-drawer.dart';

class Grades extends StatefulWidget {
  @override
  _DisplayGradeState createState() {
    return new _DisplayGradeState();
  }
}

class GradeModel {
  final String subject;
  final double value;
  final double ects;

  GradeModel({
    this.subject,
    this.value,
    this.ects,
  });
}

class _DisplayGradeState extends State {
  List<GradeModel> gradeModelData = [];
  String average = "";

  void loadGrades() async {
    var grades = await API.getGrades();

    if (grades['msg'] != 'OK') {
      // problem :/
      return;
    }

    grades = grades['grades'];

    List<GradeModel> gradesList = [];
    var sum = 0.0;
    var sumEcts = 0.0;
    for (int i = 0; i < grades.length; i++) {
      var grade = grades[i];
      gradesList.add(GradeModel(
          subject: grade['subject'],
          ects: grade['ects'].toDouble(),
          value: grade['value'].toDouble()));

      sum += grade['value'].toDouble() * grade['ects'].toDouble();
      sumEcts += grade['ects'].toDouble();
    }

    // update state and force redraw
    setState(() {
      gradeModelData = gradesList;
      average = (sum / sumEcts).toStringAsFixed(2);
    });
  }

  @override
  void initState() {
    loadGrades();
    super.initState();
  }

  void updateGrade(String subject, double ects, double grade) async {
    // update in server
    await API.updateGrade(subject, ects, grade);
    loadGrades();
  }

  void gradeTap(GradeModel grade) {
    print("Long press " + grade.subject);
    var gradeValue = grade.value;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Edytuj ocene"),
                content: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Expanded(
                            child: FlatButton(
                          child: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              gradeValue -= 0.5;
                            });
                          },
                        )),
                        Expanded(
                            child: Center(child: Text(gradeValue.toString()))),
                        Expanded(
                            child: FlatButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              gradeValue += 0.5;
                            });
                          },
                        ))
                      ]),
                    ]),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      print("Remove " + grade.subject);
                      API.deleteGrade(grade.subject);
                      loadGrades();
                    },
                    child: Text("Usuń"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      updateGrade(grade.subject, grade.ects, gradeValue);
                    },
                    child: Text("Zapisz"),
                  ),
                  FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text("Anuluj"),
                  ),
                ],
              );
            },
          );
        });
  }

  final _formKey = GlobalKey<FormState>();
  final subjectController = TextEditingController();
  final ectsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Locale.current['grades'])),
        drawer: SideDrawer(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("Add grade");
              //wywołać addGrade z api.dart w okienku

              //API.addGrade(grade.subject, grade.ects, grade.value);
              //loadGrades();

              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text("Dodaj swój przedmiot "),
                        content: SingleChildScrollView(
                          child: new Form(
                            key: _formKey,
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //subject
                                TextFormField(
                                  controller: subjectController,
                                  decoration: InputDecoration(
                                      hintText: "Nazwa przedmiotu"),
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Podaj nazwę przedmiotu';
                                    }
                                    if (value.length > 50) {
                                      return 'Zbyt długa nazwa';
                                    }
                                    return null;
                                  },
                                ),
                                //length
                                TextFormField(
                                  controller: ectsController,
                                  decoration: InputDecoration(hintText: "ECTS"),
                                  // The validator receives the text that the user has entered.
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Podaj ilosc ECTS';
                                    }
                                    if (int.parse(value) >= 10) {
                                      return 'Za duzo ects';
                                    }
                                    if (int.parse(value) < 0) {
                                      return 'Za mało ects';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                print("subject " + subjectController.text);
                                print("ects " + ectsController.text);
                                API.addGrade(subjectController.text,
                                    double.parse(ectsController.text), 5.0);
                                loadGrades();
                                Navigator.pop(context);
                              }
                            },
                            child: Text("Dodaj"),
                          ),
                          FlatButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text("Anuluj"),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 128, 1, 0)),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: gradeModelData.length,
                  itemBuilder: (context, int i) => Card(
                      child: InkWell(
                          onTap: () {
                            print("click " + gradeModelData[i].subject);
                            gradeTap(gradeModelData[i]);
                          },
                          child: Container(
                              height: 70,
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                      Text(
                                        gradeModelData[i].subject,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      Text(
                                          gradeModelData[i]
                                                  .ects
                                                  .toInt()
                                                  .toString() +
                                              " ECTS",
                                          style: TextStyle(color: Colors.grey))
                                    ])),
                                Expanded(
                                    child: Center(
                                        child: Text(
                                            gradeModelData[i].value.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20))))
                              ])))))),
          Container(
              height: 25,
              color: Color.fromARGB(255, 230, 230, 230),
              child: Center(child: Text(Locale.current['average'] + average)))
        ]));
  }
}
