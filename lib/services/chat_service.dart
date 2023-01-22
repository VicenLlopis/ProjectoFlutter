import 'dart:convert';

import 'package:project_flutter_vanat/entities/message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static Future<List<Message>> getMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('messages');

    if (json == null) {
      throw Exception('No messages registered');
    }

    final messagesDirt = jsonDecode(json);

    final List<Message> messages = messagesDirt
        .map<Message>((message) => Message.fromJson(message))
        .toList();
    return messages;
  }

  static Future<void> addMessage(Message message) async {
    List<Message> messages = [];
    try {
      messages = await getMessages();
    } catch (e) {
      messages = <Message>[];
    }
    messages.add(message);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'messages', jsonEncode(messages.map((e) => e.toJson()).toList()));
    } catch (e) {
      throw Exception('Error saving data');
    }
    return;
  }
}
