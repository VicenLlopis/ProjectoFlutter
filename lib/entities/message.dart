import 'package:project_flutter_vanat/entities/user.dart';

class Message {
  final String message;
  final User user;

  Message({
    required this.message,
    required this.user,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json['message'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }

  @override
  String toString() {
    return 'Message{message: $message, user: $user}';
  }
}
