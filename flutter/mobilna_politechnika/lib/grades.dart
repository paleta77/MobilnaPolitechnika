import 'package:flutter/material.dart';

import 'api.dart';
import 'locale.dart';
import 'side-drawer.dart';

class Grades extends StatefulWidget {
  @override
  _DisplayGradeState createState() {
    return _DisplayGradeState();
  }
}

class GradeModel {
  final String subject;
  final String value;
  final String ects;

  GradeModel({
    this.subject,
    this.value,
    this.ects,
  });
}

class _DisplayGradeState extends State {
  List gradeModelData = [];
  String average = "";

  void loadGrades() async {
    var grades = await API.getGrades();

    if (grades['msg'] != 'OK') {
      // problem :/
    }

    grades = grades['grades'];

    List gradesList = [];
    var sum = 0;
    for (int i = 0; i < grades.length; i++) {
      var grade = grades[i];
      gradesList.add(GradeModel(
          subject: grade['subject'], ects: grade['ects'].toString(), value: grade['value'].toString()));

      sum += grade['value'];
    }

    // update state and force redraw
    setState(() {
      gradeModelData = gradesList;
      average = (sum / grades.length).toString();
    });
  }

  @override
  void initState() {
    loadGrades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Locale.current['grades'])),
        drawer: SideDrawer(),
        body: Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: gradeModelData.length,
            itemBuilder: (context, int i) => Column(
              children: [
                new ListTile(
                  title: new Text(gradeModelData[i].subject + " " + gradeModelData[i].ects),
                  subtitle: new Text(gradeModelData[i].value),
                  onTap: () {},
                  onLongPress: () {},
                ),
              ],
            ),
          )),
          Container(
              height: 25,
              color: Color.fromARGB(255, 230, 230, 230),
              child: Center(child: Text(Locale.current['average'] + average)))
        ]));
  }
}
