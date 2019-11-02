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

var sum = 0;

class _DisplayGradeState extends State {
  List GradeModelData = [];
  String average = " ";

  void loadGrades() async {
    var grades = await API.getGrades(API.username);
    print(grades.length);
    GradeModelData.clear();
    sum = 0;
    for (int i = 0; i < grades.length; i++) {
      print(grades[i]['subject']);
      setState(() {
        GradeModelData.add(GradeModel(
            subject: grades[i]['subject'],
            value: grades[i]['value'].toString()));
      });
      print(grades[i]['value']);
      sum += grades[i]['value'];
    }
    setState(() {
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
      //  appBar: AppBar(
      //    title: Text("Oceny"),
      //  ),

      appBar: AppBar(title: const Text('Oceny')),
      drawer: MyDrawer(),
      body: Center(
          child: ListView.builder(
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
      )),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //IconButton(icon: Icon(Icons.menu), onPressed: () {},),
            Text(average)
          ],
        ),
      ),
    );
  }
}
