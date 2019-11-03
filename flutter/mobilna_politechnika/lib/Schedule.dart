import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';
import 'api.dart';

class Group extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DisplayGroup();
  }
}

class GroupModel {
  final String field;
  final int semester;
  final String mode;

  GroupModel(this.field, this.semester, this.mode);
}

class DisplayGroup extends StatefulWidget {
  @override
  _DisplayGradeState createState() {
    return _DisplayGradeState();
  }
}

class _DisplayGradeState extends State{
  List groupModelData = [];
  void loadGroups() async {
    var groups = await API.getGroup(API.username);
    print(groups.lenght);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: const Text('Plan zajęć')),
        drawer: MyDrawer(),
        body: Center(
          child: FlatButton(
            child: Text("test"),
            onPressed: loadGroups,
          )
        )
    );
  }
}