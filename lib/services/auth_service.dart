import 'dart:convert';

import 'package:project_flutter_vanat/entities/user.dart';
import 'package:project_flutter_vanat/services/preferences_connector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static User? _currentUser;
  static Future<User?> get getCurrentUser async {
    if (_currentUser == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final user = prefs.getString('user');
      if (user != null) {
        _currentUser = User.fromJson(jsonDecode(user));
      }
    }
    return _currentUser;
  }

  static Future<User> login(String username, String password) async {
    final users = await PreferencesConnector.getUsers();
    User? user;
    for (final u in users) {
      if (u.username == username && u.password == password) {
        user = u;
        break;
      }
    }
    if (user == null) {
      throw Exception('Invalid username or password');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
    _currentUser = user;
    return user;
  }

  static Future<User> register(
      String name, String username, String password) async {
    final users = await PreferencesConnector.getUsers();
    final user = User(
      id: users.length + 1,
      name: name,
      username: username,
      password: password,
    );
    if (users.any((u) => u.username == username)) {
      throw Exception('Username already exists');
    }
    try {
      await PreferencesConnector.saveUser(user);
    } catch (e) {
      throw Exception('Error saving user');
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
    _currentUser = user;
    return user;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user');
    _currentUser = null;
    return;
  }
}
