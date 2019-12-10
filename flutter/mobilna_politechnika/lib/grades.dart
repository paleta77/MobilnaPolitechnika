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
      average = (sum / sumEcts).toString();
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

  void longPress(GradeModel grade) {
    print("Long press " + grade.subject);
    var grade_value = grade.value;
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
                        Expanded(child: RaisedButton(child: Text("+", textAlign: TextAlign.center),
                                  onPressed: () {
                                    print("Increse grade");
                                    setState((){
                                      grade_value += 0.5;
                                    });
                                  },
                                  textColor: Colors.blue,)),
                        Expanded(child: Center(child: Text(grade_value.toString()))),
                        Expanded(child: RaisedButton(child: Text("-", textAlign: TextAlign.center),
                                  onPressed: () {
                                    print("Decrease grade");
                                    setState((){
                                      grade_value -= 0.5;
                                    });
                                  },
                                  textColor: Colors.blue,
                                  ))
                      ]),
                      RaisedButton(
                          child: Text("Usun", textAlign: TextAlign.center),
                          onPressed: () {
                            print("Remove " + grade.subject);
                          }),
                    ]),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      updateGrade(grade.subject, grade.ects, grade_value);
                    },
                    child: Text("Zapisz"),
                  )
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Locale.current['grades'])),
        drawer: SideDrawer(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
            },
            child: Text("+"),
            backgroundColor: Color.fromARGB(255, 128, 1, 0)),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: gradeModelData.length,
                  itemBuilder: (context, int i) => Card(
                      child: InkWell(
                          onLongPress: () => longPress(gradeModelData[i]),
                          onTap: () {
                            print("click " + gradeModelData[i].subject);
                          },
                          child: Container(
                              height: 70,
                              child: Row(children: <Widget>[
                                Expanded(
                                    child: Column(children: [
                                  Expanded(
                                      child: Center(
                                          child:
                                              Text(gradeModelData[i].subject))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                              gradeModelData[i].ects.toString() + "ECTS",
                                              style: TextStyle(
                                                  color: Colors.grey))))
                                ])),
                                Expanded(
                                    child: Center(
                                        child: Text(gradeModelData[i].value.toString(),
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