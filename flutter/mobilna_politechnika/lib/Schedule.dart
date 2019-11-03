import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';
import 'package:mobilna_politechnika/Oceny.dart';
import 'api.dart';

class GroupTimetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DisplayGroups();
  }
}

class DisplayGroups extends StatefulWidget {
  @override
  _DisplayGroupsState createState() {
    return _DisplayGroupsState();
  }
}

class _DisplayGroupsState extends State{
  List groupModelData = [];
  void loadGroups() async {
    var groups = await API.getGroup(API.username);
    var groupModel = GroupModel.fromJson(groups);
    print(groupModel.group.timetable.length);
    groupModelData.clear();
    for(int i = 0; i<groupModel.group.timetable.length; i++){
      print(groups['group']['timetable'][i]['day']);
      print(groups['group']['timetable'][i]['hour']);
      print(groups['group']['timetable'][i]['length']);
      print(groups['group']['timetable'][i]['subject']);
      print(groups['group']['timetable'][i]['classroom']);
      print("");
    }


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

class GroupModel {
  String msg;
  Group group;

  GroupModel({this.msg, this.group});

  GroupModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    group = json['group'] != null ? new Group.fromJson(json['group']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.group != null) {
      data['group'] = this.group.toJson();
    }
    return data;
  }
}

class Group {
  String sId;
  String field;
  int semester;
  String mode;
  List<Timetable> timetable;
  int iV;

  Group(
      {this.sId,
        this.field,
        this.semester,
        this.mode,
        this.timetable,
        this.iV});

  Group.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    field = json['field'];
    semester = json['semester'];
    mode = json['mode'];
    if (json['timetable'] != null) {
      timetable = new List<Timetable>();
      json['timetable'].forEach((v) {
        timetable.add(new Timetable.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['field'] = this.field;
    data['semester'] = this.semester;
    data['mode'] = this.mode;
    if (this.timetable != null) {
      data['timetable'] = this.timetable.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    return data;
  }
}

class Timetable {
  String sId;
  String day;
  double hour;
  int length;
  String subject;
  String classroom;
  String lecturer;

  Timetable(
      {this.sId,
        this.day,
        this.hour,
        this.length,
        this.subject,
        this.classroom,
        this.lecturer});

  Timetable.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    day = json['day'];
    hour = json['hour'];
    length = json['length'];
    subject = json['subject'];
    classroom = json['classroom'];
    lecturer = json['lecturer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['length'] = this.length;
    data['subject'] = this.subject;
    data['classroom'] = this.classroom;
    data['lecturer'] = this.lecturer;
    return data;
  }
}
