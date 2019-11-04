import 'package:flutter/material.dart';
import 'package:mobilna_politechnika/MyDrawer.dart';
import 'api.dart';
import 'package:calendar_views/calendar_views.dart';
import 'package:calendar_views/day_view.dart';
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
  });

  final int startMinuteOfDay;
  final int duration;

  final String title;
}

class _DayViewState extends State{
  DateTime _day0;
  DateTime _day1;

  var groupModel;
  void loadGroups() async {
    var groups = await API.getGroup(API.username);
    setState(() {
      groupModel = GroupModel.fromJson(groups);
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

    //loadGroups();
      for(int i = 0; i<5 ; i++){
        if(weekdayToAbbreviatedString(day.weekday)==groupModel.group.timetable.elementAt(i).day){
          events.add(new Event(
              startMinuteOfDay: groupModel.group.timetable
                  .elementAt(i)
                  .hour.round()*60,
              duration: 90,
              title: groupModel.group.timetable
                  .elementAt(i)
                  .subject));
        }
        print("lekcja"+groupModel.group.timetable.elementAt(i).subject + "dzien lekcji"+ groupModel.group.timetable.elementAt(i).day+ "dzien dnia" + day.day.toString());
      }
    if(groupModel!=null){
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
      appBar: new AppBar(
        title: new Text("Plan zajęć"),
      ),
      body: new DayViewEssentials(
          properties: new DayViewProperties(days: <DateTime>[
            _day0,
            _day1,
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
        color: Colors.green[200],
        child: new Text("${event.title}"),
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

  //Day header
  Widget _headerItemBuilder(BuildContext context, DateTime day){
    return new Container(
      color: Colors.grey[300],
      padding: new EdgeInsets.symmetric(vertical: 8.0),
      child: new Column(
        children: <Widget>[
          new Text(weekdayToAbbreviatedString(day.weekday)),
        ],
      ),
    );
  }

  weekdayToAbbreviatedString(int weekday) {
    switch(weekday){
      case 1:
        return "Poniedziałek";
        break;
      case 2:
        return "Wtorek";
        break;
      case 3:
        return "Sroda";
        break;
      case 4:
        return "Czwartek";
        break;
      case 5:
        return "Piątek";
        break;
      case 6:
        return "Sobota";
        break;
      case 7:
        return "Niedziela";
        break;
      default:
        return "Error";
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
    var groups = await API.getGroup(API.username);
    setState(() {
      groupModel = GroupModel.fromJson(groups);
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
        appBar: AppBar(title: const Text('Plan zajęć')),
        drawer: MyDrawer(),
        body: Center(
            child: DayView(),
        )
    );
  }
}

//Classes for conversion
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
