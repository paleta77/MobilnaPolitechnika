import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_views/calendar_views.dart';
import 'package:calendar_views/day_view.dart';

import 'api.dart';
import 'locale.dart';
import 'side-drawer.dart';

//displaying it as calendar view
class DayView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _DayViewState();
}

class Event {
  Event({
    @required this.startMinuteOfDay,
    @required this.duration,
    @required this.title,
    @required this.type,
  });

  final int startMinuteOfDay;
  final int duration;

  final String title;
  final String type;
}

class _DayViewState extends State{
  DateTime _day0;
  DateTime _day1;

  var groupModel;
  void loadGroups() async {
    var groups = await API.getTimetable();
    setState(() {
      groupModel = Timetables.fromJson(groups);
    });
  }

  List<Event> events;

  @override
  void initState() {
    super.initState();
    loadGroups();
    events = <Event>[];
    _day0 = new DateTime.utc(2019,1,5);
    _day1 = new DateTime.utc(2019,1,6);
  }

    List<StartDurationItem> _getEventsOfDay(DateTime day) {
    events = <Event>[
      //new Event(startMinuteOfDay: 1 * 60, duration: 90, title: "Sleep Walking"),
    ];

    //loadGroups()
    if(groupModel!=null){
      //print("\n\n" + groupModel.timetable[0].day);
      for(int i = 0; i<groupModel.timetable.length; i++){
        //if(weekdayToAbbreviatedString(day.weekday)==groupModel.timetable[i].day){
        if(dropdownValue==groupModel.timetable[i].day){
          int hours = groupModel.timetable[i].hour.toInt();
          double minuts = ((groupModel.timetable[i].hour - hours) * 100);
          String stringMinuts = minuts.toStringAsFixed(0);
          if(stringMinuts=="0") stringMinuts += "0";

          Duration startTime = new Duration(hours: hours, minutes: int.parse(stringMinuts));
          Duration duration = new Duration(minutes: groupModel.timetable[i].length);
          print(startTime + duration);
          double durationDouble = duration.inHours.toDouble();
          if(duration.inMinutes.remainder(60)==60){
            durationDouble += 1.0;
          }
          else {
            durationDouble += duration.inMinutes.remainder(60).toDouble()/100;
          }
          double endTime = durationDouble+groupModel.timetable[i].hour;
          String endTimeString = endTime.toStringAsFixed(2);
          if(endTimeString.endsWith("60")){
            endTime+=0.4;
            print(endTime);
          }


            events.add(new Event(
                startMinuteOfDay: hours * 60 + minuts.toInt(),
                duration: groupModel.timetable[i].length,
                type: groupModel.timetable[i].type,
                title:groupModel.timetable[i].type + ", " + hours.toString() + ":" + stringMinuts + "-" + endTime.toStringAsFixed(2) +"\n" +
                    groupModel.timetable[i].subject + "\n" +
                    groupModel.timetable[i].lecturer + "\n" +
                    groupModel.timetable[i].classroom));

        }
      }
    }


    return events
        .map(
          (event) => new StartDurationItem(
        startMinuteOfDay: event.startMinuteOfDay,
        duration: event.duration,
        builder: (context, itemPosition, itemSize) => _eventBuilder(
          context,
          itemPosition,
          itemSize,
          event,
        ),
      ),
    )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: SideDrawer(),
      appBar: new AppBar(
        title: new Text(Locale.current['schedule']),
      ),
      body: new DayViewEssentials(
          properties: new DayViewProperties(days: <DateTime>[
            _day0,
            //_day1,
          ]),
          child: new Column(
            children: <Widget>[
              new Container(
                color: Colors.grey[200],
                child: new DayViewDaysHeader(headerItemBuilder: _headerItemBuilder),
              ),
              new Expanded(
                  child: new SingleChildScrollView(
                    child: new DayViewSchedule(
                        heightPerMinute: 1.0,
                        components: <ScheduleComponent>[
                          new TimeIndicationComponent.intervalGenerated(
                          generatedTimeIndicatorBuilder:
                              _generatedTimeIndicatorBuilder),
                          new SupportLineComponent.intervalGenerated(
                            generatedSupportLineBuilder: _generatedSupportLineBuilder,
                          ),
                          new DaySeparationComponent(
                            generatedDaySeparatorBuilder:
                            _generatedDaySeparatorBuilder,
                          ),
                          new EventViewComponent(
                            getEventsOfDay: _getEventsOfDay,
                          ),
                    ]),
                  ))
            ],
          )),
    );
  }

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }

  MaterialColor eventToColor(String eventType){
    switch (eventType){
      case "Projekt":
        return Colors.green;
      case "Lektorat":
        return Colors.purple;
      case "Laboratorium":
        return Colors.cyan;
      default:
        return Colors.indigo;
    }
  }

  Positioned _eventBuilder(
      BuildContext context,
      ItemPosition itemPosition,
      ItemSize itemSize,
      Event event,
      ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Container(
        margin: new EdgeInsets.only(left: 1.0, right: 1.0, bottom: 1.0),
        padding: new EdgeInsets.all(3.0),
        child:
        new Text("${event.title}",),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: eventToColor("${event.type}"), //                   <--- border color
            width: 5.0,
          ),
         ),
      ),
    );
  }

  //Hours display
  Positioned _generatedTimeIndicatorBuilder(
      BuildContext context,
      ItemPosition itemPosition,
      ItemSize itemSize,
      int minuteOfDay,
      ) {
    return new Positioned(
      top: itemPosition.top,
      left: itemPosition.left,
      width: itemSize.width,
      height: itemSize.height,
      child: new Container(
        child: new Center(
          child: new Text(_minuteOfDayToHourMinuteString(minuteOfDay)),
        ),
      ),
    );
  }

  String dropdownValue = 'Sobota';
  //Day header
  Widget _headerItemBuilder(BuildContext context, DateTime day){
    return new Container(
      child: new DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(
          color: Colors.black,
        ),
        underline: Container(
          height: 2,
          color: Colors.black,
        ),
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['Sobota', 'Niedziela']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  weekdayToAbbreviatedString(int weekday) {
    switch(weekday){
      case 1:
        return Locale.current['moday'];
        break;
      case 2:
        return Locale.current['tuesday'];
        break;
      case 3:
        return Locale.current['wednesday'];
        break;
      case 4:
        return Locale.current['thursday'];
        break;
      case 5:
        return Locale.current['friday'];
        break;
      case 6:
        return Locale.current['saturday'];
        break;
      case 7:
        return Locale.current['sunday'];
        break;
      default:
        return Locale.current['error'];
    }
  }

}

//lines separating days
Positioned _generatedDaySeparatorBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    ItemSize itemSize,
    int daySeparatorNumber,
    ) {
  return new Positioned(
    top: itemPosition.top,
    left: itemPosition.left,
    width: itemSize.width,
    height: itemSize.height,
    child: new Center(
      child: new Container(
        width: 0.7,
        color: Colors.grey,
      ),
    ),
  );
}

//Lines separating each event
Positioned _generatedSupportLineBuilder(
    BuildContext context,
    ItemPosition itemPosition,
    double itemWidth,
    int minuteOfDay,
    ) {
  return new Positioned(
    top: itemPosition.top,
    left: itemPosition.left,
    width: itemWidth,
    child: new Container(
      height: 0.7,
      color: Colors.grey[700],
    ),
  );
}

//displaying it as list
class GroupTimetable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DayView();
  }
}

class DisplayGroups extends StatefulWidget {
  @override
  _DisplayGroupsState createState() {
    return _DisplayGroupsState();
  }
}

class _DisplayGroupsState extends State{
  var groupModel;
  void loadGroups() async {
    var groups = await API.getTimetable();
    setState(() {
      groupModel = Timetables.fromJson(groups);
    });
    for(int i = 0; i<groupModel.group.timetable.length; i++) {
      print(groupModel.group.timetable
          .elementAt(i)
          .day);
      print(groupModel.group.timetable
          .elementAt(i)
          .hour);
      print(groupModel.group.timetable
          .elementAt(i)
          .length);
      print(groupModel.group.timetable
          .elementAt(i)
          .subject);
      print(groupModel.group.timetable
          .elementAt(i)
          .classroom);
      print(groupModel.group.timetable
          .elementAt(i)
          .lecturer);
    }
  }

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text(Locale.current['schedule'])),
        drawer: SideDrawer(),
        body: Center(
            child: DayView(),
        )
    );
  }
}

//Classes for conversion
class Timetables {
  String msg;
  List<Timetable> timetable;

  Timetables({this.msg, this.timetable});

  Timetables.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['timetable'] != null) {
      timetable = new List<Timetable>();
      json['timetable'].forEach((v) {
        timetable.add(new Timetable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.timetable != null) {
      data['timetable'] = this.timetable.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Timetable {
  String sId;
  String group;
  String day;
  double hour;
  int length;
  String subject;
  String type;
  String classroom;
  String lecturer;
  int iV;

  Timetable(
      {this.sId,
        this.group,
        this.day,
        this.hour,
        this.length,
        this.subject,
        this.type,
        this.classroom,
        this.lecturer,
        this.iV});

  Timetable.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    group = json['group'];
    day = json['day'];
    hour = json['hour']*1.0;
    length = json['length'];
    subject = json['subject'];
    type = json['type'];
    classroom = json['classroom'];
    lecturer = json['lecturer'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['group'] = this.group;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['length'] = this.length;
    data['subject'] = this.subject;
    data['type'] = this.type;
    data['classroom'] = this.classroom;
    data['lecturer'] = this.lecturer;
    data['__v'] = this.iV;
    return data;
  }
}