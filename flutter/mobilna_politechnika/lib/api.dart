import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class API {
  static const String URL = 'http://77.55.208.10:8079';
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

  static Future<dynamic> removeExtraLesson(String subject) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.deleteUrl(Uri.parse('$URL/user/extralessons'));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Authorization', 'Bearer 123');
    request.add(utf8.encode(json.encode({"subject":subject})));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }


  static Future<dynamic> addExtraLesson() async {
    final response = await http.put('$URL/user/extralessons', headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    }, body: json.encode(
      {"subject": "Lekcja123456",
        "day": "Sobota",
        "hour": "5.1",
        "length": "90",
        "type": "labolatorium",
        "classroom": "F9",
        "lecturer": "Jan kowalski"
      }
    )
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      return body;
    }
  }
}
