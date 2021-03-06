import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class API {
  static const String URL = 'http://192.168.0.14:8079';
  static String token;

  static Future<bool> login(String username, String password) async {
    final response = await http.post('$URL/login',
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': username, 'password': password}));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body['msg'] == 'OK') {
        token = body['token']; // save auth token
        return true;
      }
    }
    return false;
  }

  static Future<bool> logout() async {
    API.token = null;
    final response = await http.get('$URL/logout', headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body['msg'] == 'OK') {
        token = null;
        return true;
      }
    }
    return false;
  }

  static Future<dynamic> userInfo() async {
    final response = await http.get('$URL/user', headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body['user'];
    }
    return null;
  }

  static Future<dynamic> getGrades() async {
    final response = await http.get('$URL/grades', headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }

    return null;
  }

  static Future<dynamic> addGrade(
      int semester, String subject, double ects, double value) async {
    final response = await http.put('$URL/grades',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({
          'semester': semester,
          'subject': subject,
          'ects': ects,
          'value': value
        }));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }

    return null;
  }

  static Future<dynamic> updateGrade(
      int semester, String subject, double ects, double value) async {
    final response = await http.post('$URL/grades',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({
          'semester': semester,
          'subject': subject,
          'ects': ects,
          'value': value
        }));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }

    return null;
  }

  static Future<bool> deleteGrade(int semester, String subject) async {
    http.Request rq = http.Request('DELETE', Uri.parse('$URL/grades'))
      ..headers.addAll({
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      });

    rq.body = json.encode({
      'semester': semester,
      'subject': subject,
    });

    http.StreamedResponse response = await http.Client().send(rq);

    return null;
  }

  static Future<dynamic> getGroup() async {
    final response = await http.get('$URL/group', headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body['group'];
    }
  }

  static Future<dynamic> getTimetable() async {
    final response = await http.get('$URL/group/timetable', headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
  }

  static Future<dynamic> getLecturerTimetable(String lecturer) async {
    final response = await http.get('$URL/lecturer/$lecturer/timetable',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        });

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
  }

  static Future<dynamic> getClassroomTimetable(String classroom) async {
    classroom = classroom.replaceAll('/', "%2f"); // ugly hack :(
    final response = await http.get('$URL/room/$classroom/timetable', headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
  }

  static Future<dynamic> getExtraLessons() async {
    final response = await http.get('$URL/user/extralessons', headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return body;
    }
  }

  static Future<dynamic> removeExtraLesson(
      String subject, String day, String hour, String minutes) async {
    String time = hour + "." + minutes;
    if (time.endsWith("0")) {
      time = hour + "." + minutes[0];
    }
    print("time:" + time);
    HttpClient httpClient =
        new HttpClient(); // why we cant just use http.delete() ?
    HttpClientRequest request =
        await httpClient.deleteUrl(Uri.parse('$URL/user/extralessons'));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Bearer 123');
    request.add(utf8
        .encode(json.encode({"subject": subject, "day": day, "hour": time})));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  static Future<dynamic> addExtraLesson(String subject, String day, String hour,
      String length, String type, String classroom, String lecturer) async {
    String time;
    if (hour.endsWith("0")) {
      time = hour.split(":")[0] + "." + hour.split(":")[1][0];
    } else {
      time = hour.split(":")[0] + "." + hour.split(":")[1];
    }

    final response = await http.put('$URL/user/extralessons',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: json.encode({
          "subject": subject,
          "day": day,
          "hour": time,
          "length": length,
          "type": type,
          "classroom": classroom,
          "lecturer": lecturer
        }));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      return body;
    }
  }
}
