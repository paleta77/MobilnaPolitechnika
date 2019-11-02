import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';
import 'api.dart';

class Oceny extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Oceny"),
      ),
      drawer: MyDrawer(),
      body: Center(child: DisplayGrade()),
    );
  }
}

class GradeModel {
  final String subject;
  final String value;

  GradeModel({
    this.subject,
    this.value,
  });
}

class DisplayGrade extends StatefulWidget {
  @override
  _DisplayGradeState createState() {
    return _DisplayGradeState();
  }
}

class _DisplayGradeState extends State {
  List GradeModelData = [];

  void loadGrades() async {
    var grades = await API.getGrades(API.username);
    print(grades.length);
    GradeModelData.clear();
    for (int i = 0; i < grades.length; i++) {
      print(grades[i]['subject']);
      setState(() {
        GradeModelData.add(GradeModel(
            subject: grades[i]['subject'],
            value: grades[i]['value'].toString()));
      });
    }
  }

  @override
  void initState() {
    loadGrades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: GradeModelData.length,
      itemBuilder: (context, int i) => Column(
        children: [
          new ListTile(
            title: new Text(GradeModelData[i].subject),
            subtitle: new Text(GradeModelData[i].value),
            onTap: () {},
            onLongPress: () {
              print(
                Text("Long Pressed"),
              );
            },
          ),
        ],
      ),
    );
  }
}
