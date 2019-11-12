import 'dart:convert';
import 'package:http/http.dart' as http;

class API {
  static const String URL = 'https://mojmegatestkolejny.azurewebsites.net';
  static String token;
  static String username;

  static Future<bool> login(String username, String password) async {
    final response = await http.post('$URL/login',
        headers: {"Content-Type": "application/json"},
        body: json.encode({'username': username, 'password': password}));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body['msg'] == 'OK') {
        token = body['token']; // save auth token
        API.username = username;
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
      return body;
    }
  }
}
