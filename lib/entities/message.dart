import 'package:project_flutter_vanat/entities/user.dart';

class Message {
  final String message;
  final User user;
  final DateTime date;

  Message({
    required this.message,
    required this.user,
    required this.date,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      user: User.fromJson(json['user']),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Message{message: $message, user: $user}';
  }
}
