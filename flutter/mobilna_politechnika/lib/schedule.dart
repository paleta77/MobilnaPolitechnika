import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:calendar_views/calendar_views.dart';
import 'package:calendar_views/day_view.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'api.dart';
import 'locale.dart';
import 'side-drawer.dart';

//displaying it as calendar view
class DayView extends StatefulWidget {
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

class _DayViewState extends State {
  DateTime _day0;
  DateTime _day1;

  var groupModel;
  var extraLessons;

  void loadGroups() async {
    //load group timetables
    var groups = await API.getTimetable();
    //load user timetables
    var extraLessonsJson = await API.getExtraLessons();

    //set them
    setState(() {
      groupModel = Timetables.fromJson(groups);
      extraLessons = ExtraLessons.fromJson(extraLessonsJson);
    });
  }

  List<Event> events;

  String add0If0Minutes(String time) {
    if (time.length == 1 && time.endsWith("0"))
      return "00";
    else
      return time.toString();
  }

  @override
  void initState() {
    super.initState();
    loadGroups();
    events = <Event>[];
    _day0 = new DateTime.utc(2019, 1, 5);
    _day1 = new DateTime.utc(2019, 1, 6);
  }

  List<StartDurationItem> _getEventsOfDay(DateTime day) {
    events = <Event>[
      //new Event(startMinuteOfDay: 1 * 60, duration: 90, title: "Sleep Walking"),
    ];

    //loadGroups()
    if (groupModel != null) {
      //print("\n\n" + groupModel.timetable[0].day);
      for (int i = 0; i < groupModel.timetable.length; i++) {
        //if(weekdayToAbbreviatedString(day.weekday)==groupModel.timetable[i].day){
        if (dropdownValue == groupModel.timetable[i].day) {
          int hours = groupModel.timetable[i].hour.toInt();
          double minutes = ((groupModel.timetable[i].hour - hours) * 100);
          String stringMinutes = minutes.toStringAsFixed(0);

          Duration startTime =
              new Duration(hours: hours, minutes: int.parse(stringMinutes));
          Duration duration =
              new Duration(minutes: groupModel.timetable[i].length);
          Duration endTime = startTime + duration;

          events.add(new Event(
              startMinuteOfDay: hours * 60 + minutes.toInt(),
              duration: groupModel.timetable[i].length,
              type: groupModel.timetable[i].type,
              title: groupModel.timetable[i].type +
                  ", " +
                  startTime.inHours.toString() +
                  ":" +
                  add0If0Minutes(startTime.inMinutes.remainder(60).toString()) +
                  "-" +
                  endTime.inHours.toString() +
                  ":" +
                  add0If0Minutes(endTime.inMinutes.remainder(60).toString()) +
                  "\n" +
                  groupModel.timetable[i].subject +
                  "\n" +
                  groupModel.timetable[i].lecturer +
                  "\n" +
                  groupModel.timetable[i].classroom));
        }
      }
    }

    //load extra lessons
    if (extraLessons != null) {
      for (int i = 0; i < extraLessons.extralesson.length; i++) {
        int hours = extraLessons.extralesson[i].hour.toInt();
        double minutes = ((extraLessons.extralesson[i].hour - hours) * 100);
        String stringMinutes = minutes.toStringAsFixed(0);

        Duration startTime =
            new Duration(hours: hours, minutes: int.parse(stringMinutes));
        Duration duration =
            new Duration(minutes: extraLessons.extralesson[i].length);
        Duration endTime = startTime + duration;

        if (dropdownValue == extraLessons.extralesson[i].day) {
          print(extraLessons.extralesson[i].subject);
          events.add(new Event(
              startMinuteOfDay: hours * 60 + minutes.toInt(),
              duration: extraLessons.extralesson[i].length,
              title: extraLessons.extralesson[i].type +
                  ", " +
                  startTime.inHours.toString() +
                  ":" +
                  add0If0Minutes(startTime.inMinutes.remainder(60).toString()) +
                  "-" +
                  endTime.inHours.toString() +
                  ":" +
                  add0If0Minutes(endTime.inMinutes.remainder(60).toString()) +
                  "\n" +
                  extraLessons.extralesson[i].subject +
                  "\n" +
                  extraLessons.extralesson[i].lecturer +
                  "\n" +
                  extraLessons.extralesson[i].classroom,
              type: extraLessons.extralesson[i].type));
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

  final _formKey = GlobalKey<FormState>();
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
          ], minimumMinuteOfDay: 5 * 60), // set starting hour
          child: new Column(
            children: <Widget>[
              new Container(
                color: Colors.grey[200],
                child: new DayViewDaysHeader(
                    headerItemBuilder: _headerItemBuilder),
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
                        generatedSupportLineBuilder:
                            _generatedSupportLineBuilder,
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.list_view,
        backgroundColor: Color.fromARGB(255, 128, 1, 0),
        children: [
          SpeedDialChild(
              child: Icon(Icons.remove),
              label: "Usuń swój przedmiot",
              backgroundColor: Color.fromARGB(255, 128, 1, 0),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String extraLessonToDelete = extraLessons.toStringList()[0];
                    List<String> strings = extraLessons.toStringList();
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text("Usuń swój przedmiot "),
                          content:
                          new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new DropdownButton<String>(
                                value: extraLessonToDelete,
                                items: strings.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    extraLessonToDelete = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () async {
//                                await API.removeExtraLesson(extraLessonToDelete.split(" ")[0],
//                                    extraLessonToDelete.split(" ")[1] ,
//                                    extraLessonToDelete.split(" ")[2].split(":")[0],
//                                    extraLessonToDelete.split(" ")[2].split(":")[1]);
                                loadGroups();
                                Navigator.pop(context);
                                setState(() {
                                  strings = extraLessons.toStringList();
                                });
                              },
                              child: Text("Dodaj"),
                            ),
                            FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Text("Anuluj"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
          SpeedDialChild(
              child: Icon(Icons.add),
              label: "Dodaj swój przedmiot",
              backgroundColor: Color.fromARGB(255, 128, 1, 0),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String chosenDay = 'Sobota';
                    String chosenType = 'Wykład';
                    String _timeBegin = "Rozpoczęcie";
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: Text("Dodaj swój przedmiot "),
                          content:
                          new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //subject
                              TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Nazwa przedmiotu"),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Podaj nazwę przedmiotu';
                                  }
                                  if (value.length>50){
                                    return 'Zbyt długa nazwa';
                                  }
                                  return null;
                                },
                              ),
                              //day
                              new DropdownButton<String>(
                                value: chosenDay,
                                hint: Text('Wybierz dzień'),
                                items: <String>['Sobota', 'Niedziela']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    chosenDay = newValue;
                                  });
                                },
                              ),
                              //hour
                              FlatButton(
                                  onPressed: () {
                                    DatePicker.showTimePicker(context,
                                        theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                        ),
                                        showTitleActions: true, onConfirm: (time) {
                                          print('confirm $time');
                                          _timeBegin = '${time.hour} : ${time.minute}';
                                          setState(() {});
                                        }, currentTime: DateTime.now(), locale: LocaleType.pl);
                                    setState(() {});
                                  },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.access_time,
                                                  size: 18.0,
                                                  color: Colors.teal,
                                                ),
                                                Text(
                                                  " $_timeBegin",
                                                  style: TextStyle(
                                                      color: Colors.teal,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18.0),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Text(
                                        "  Wybierz",
                                        style: TextStyle(
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ],
                                  ),
                                ),
                                color: Colors.white,
                              ),
                              //length
                              TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Czas trwania w minutach"),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Podaj nazwę przedmiotu';
                                  }
                                  if (int.parse(value)>=3600){
                                    return 'Zbyt długi czas trwania';
                                  }
                                  if (int.parse(value)<=0){
                                    return 'Zbyt krótki czas trwania';
                                  }
                                  return null;
                                },
                              ),
                              //type
                              new DropdownButton<String>(
                                value: chosenType,
                                items: <String>['Wykład', 'Lektorat', 'Laboratorium', 'Projekt']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    chosenType = newValue;
                                  });
                                },
                              ),
                              //classroom
                              TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Sala"),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Podaj nazwę sali';
                                  }
                                  if (value.length>50){
                                    return 'Zbyt długa nazwa';
                                  }
                                  return null;
                                },
                              ),
                              //lecturer
                              TextFormField(
                                decoration: InputDecoration(
                                    hintText: "Wykładowca"),
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Podaj wykładowce';
                                  }
                                  if (value.length>75){
                                    return 'Zbyt długa nazwa';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () async {

                                loadGroups();
                                setState(() {
                                  //contentText = "Changed Content of Dialog";
                                });
                              },
                              child: Text("Dodaj"),
                            ),
                            FlatButton(
                              onPressed: () async {
                                await API.addExtraLesson();
                                loadGroups();
                                setState(() {
                                  //contentText = "Changed Content of Dialog";
                                });
                              },
                              child: Text("Anuluj"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
        ],
      ),
    );
  }

  String _minuteOfDayToHourMinuteString(int minuteOfDay) {
    return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
        ":"
        "${(minuteOfDay % 60).toString().padLeft(2, "0")}";
  }

  MaterialColor eventToColor(String eventType) {
    switch (eventType) {
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
        child: new Text(
          "${event.title}",
        ),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: eventToColor("${event.type}"),
            //                   <--- border color
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
  Widget _headerItemBuilder(BuildContext context, DateTime day) {
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
    switch (weekday) {
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

class _DisplayGroupsState extends State {
  var groupModel;

  void loadGroups() async {
    var groups = await API.getTimetable();
    setState(() {
      groupModel = Timetables.fromJson(groups);
    });
    for (int i = 0; i < groupModel.group.timetable.length; i++) {
      print(groupModel.group.timetable.elementAt(i).day);
      print(groupModel.group.timetable.elementAt(i).hour);
      print(groupModel.group.timetable.elementAt(i).length);
      print(groupModel.group.timetable.elementAt(i).subject);
      print(groupModel.group.timetable.elementAt(i).classroom);
      print(groupModel.group.timetable.elementAt(i).lecturer);
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
        ));
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
    hour = json['hour'] * 1.0;
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

class ExtraLessons {
  String msg;
  List<Extralesson> extralesson;

  ExtraLessons({this.msg, this.extralesson});

  ExtraLessons.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['extralesson'] != null) {
      extralesson = new List<Extralesson>();
      json['extralesson'].forEach((v) {
        extralesson.add(new Extralesson.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.extralesson != null) {
      data['extralesson'] = this.extralesson.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String add0If0Minutes(String time) {
    if (time.length == 1 && time.endsWith("0"))
      return "00";
    else
      return time.toString();
  }

  List<String> toStringList() {
    List<String> returnList = new List();

    for (int i = 0; i < extralesson.length; i++) {
      int hours = extralesson[i].hour.toInt();
      double minutes = ((extralesson[i].hour - hours) * 100);
      String stringMinutes = minutes.toStringAsFixed(0);

      Duration startTime =
          new Duration(hours: hours, minutes: int.parse(stringMinutes));
      returnList.add(extralesson[i].subject +
          " " +
          extralesson[i].day +
          " " +
          startTime.inHours.toString() +
          ":" +
          add0If0Minutes(startTime.inMinutes.remainder(60).toString()));
    }

    returnList.sort((String a, String b) => a.compareTo(b)); //todo sort
    return returnList;
  }
}

class Extralesson {
  String sId;
  String subject;
  String day;
  double hour;
  int length;
  String type;
  String classroom;
  String lecturer;
  String user;
  int iV;

  Extralesson(
      {this.sId,
      this.subject,
      this.day,
      this.hour,
      this.length,
      this.type,
      this.classroom,
      this.lecturer,
      this.user,
      this.iV});

  Extralesson.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    subject = json['subject'];
    day = json['day'];
    hour = json['hour'];
    length = json['length'];
    type = json['type'];
    classroom = json['classroom'];
    lecturer = json['lecturer'];
    user = json['user'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['subject'] = this.subject;
    data['day'] = this.day;
    data['hour'] = this.hour;
    data['length'] = this.length;
    data['type'] = this.type;
    data['classroom'] = this.classroom;
    data['lecturer'] = this.lecturer;
    data['user'] = this.user;
    data['__v'] = this.iV;
    return data;
  }
}
