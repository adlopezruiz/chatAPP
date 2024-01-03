import 'dart:convert';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User? user;
  bool _authenticating = false;

  final _storage = const FlutterSecureStorage();

  bool get authenticating => _authenticating;

  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  // Static getter for token
  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    authenticating = true;

    final data = {
      'email': email,
      'password': password,
    };

    final response = await http.post(Uri.parse('${Environment.apiUrl}/login'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      user = loginResponse.dbUser;

      await _saveToken(loginResponse.token);
      authenticating = false;

      return true;
    } else {
      authenticating = false;
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    authenticating = true;

    final data = {
      'name': name,
      'email': email,
      'password': password,
    };

    final response = await http.post(
        Uri.parse('${Environment.apiUrl}/login/new'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        });

    if (response.statusCode == 200) {
      final registerResponse = loginResponseFromJson(response.body);
      user = registerResponse.dbUser;
      await _saveToken(registerResponse.token);
      authenticating = false;

      return true;
    } else {
      final respBody = json.decode(response.body);
      authenticating = false;
      return respBody['msg'];
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');

    final resp = await http
        .get(Uri.parse('${Environment.apiUrl}/login/renew'), headers: {
      'Content-Type': 'application/json',
      'x-token': token ?? '',
    });

    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      user = registerResponse.dbUser;
      await _saveToken(registerResponse.token);
      return true;
    } else {
      logout();
      return false;
    }
  }
}
