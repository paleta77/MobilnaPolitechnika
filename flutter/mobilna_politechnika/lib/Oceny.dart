import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';
import 'api.dart';

class Oceny extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DisplayGrade();
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
  List gradeModelData = [];
  String average = "";

  void loadGrades() async {
    var grades = await API.getGrades(API.username);

    List gradesList = [];
    var sum = 0;
    for (int i = 0; i < grades.length; i++) {
      gradesList.add(GradeModel(
          subject: grades[i]['subject'], value: grades[i]['value'].toString()));

      sum += grades[i]['value'];
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
      appBar: AppBar(title: const Text('Oceny')),
      drawer: MyDrawer(),
      body: Center(
          child: ListView.builder(
        itemCount: gradeModelData.length,
        itemBuilder: (context, int i) => Column(
          children: [
            new ListTile(
              title: new Text(gradeModelData[i].subject),
              subtitle: new Text(gradeModelData[i].value),
              onTap: () {},
              onLongPress: () {
                print(
                  Text("Long Pressed"),
                );
              },
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //IconButton(icon: Icon(Icons.menu), onPressed: () {},),
            Text("Średnia: $average")
          ],
        ),
      ),
    );
  }
}
