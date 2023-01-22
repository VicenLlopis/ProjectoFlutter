import 'package:flutter/material.dart';
import 'package:project_flutter_vanat/my_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('users') == null) {
    prefs.setString('users', '[]');
  }
  if (prefs.getString('messages') == null) {
    prefs.setString('messages', '[]');
  }

  runApp(const MyApp());
}
