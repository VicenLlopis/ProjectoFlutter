import 'dart:convert';

import 'package:project_flutter_vanat/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesConnector {
  static Future<String> loadJSON(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString(key);

    if (json == null) {
      throw Exception('No users registered');
    }

    return json;
  }

  static Future<void> _saveJSON(
      String path, List<Map<String, dynamic>> data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(path, jsonEncode(data));
    } catch (e) {
      throw Exception('Error saving data');
    }
    return;
  }

  static Future<List<User>> getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('users');

    if (json == null) {
      throw Exception('No users registered');
    }
    final usersDirt = jsonDecode(json);

    final List<User> users =
        usersDirt.map<User>((user) => User.fromJson(user)).toList();
    return users;
  }

  static Future<User> getUser(int id) async {
    List<User> users = [];
    try {
      users = await getUsers();
    } catch (e) {
      users = <User>[];
    }
    return users.firstWhere((user) => user.id == id);
  }

  static Future<String> saveUser(User user) async {
    List<User> users = [];
    try {
      users = await getUsers();
    } catch (e) {
      users = <User>[];
    }
    final userIndex = users.indexWhere((u) => u.id == user.id);

    if (userIndex == -1) {
      users.add(user);
    } else {
      users[userIndex] = user;
    }

    List<Map<String, dynamic>> data =
        users.map((user) => user.toJson()).toList();

    await _saveJSON('users', data);

    return 'User saved';
  }
}
