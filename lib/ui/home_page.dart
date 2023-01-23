import 'package:flutter/material.dart';
import 'package:project_flutter_vanat/entities/message.dart';
import 'package:project_flutter_vanat/entities/user.dart';
import 'package:project_flutter_vanat/services/auth_service.dart';
import 'package:project_flutter_vanat/services/chat_service.dart';
import 'package:project_flutter_vanat/ui/login_page.dart';
import 'package:project_flutter_vanat/ui/modules/chat_message_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController messageController = TextEditingController();

  List<ChatMessageWidget> messages = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.getCurrentUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }
          final User? user = snapshot.data;
          if (user == null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
          return FutureBuilder(
              future: ChatService.getMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error'),
                  );
                }
                List<Message> messagesDirt = snapshot.data != null
                    ? snapshot.data as List<Message>
                    : <Message>[];
                messagesDirt = messagesDirt.reversed.toList();
                messages = messagesDirt.map((e) {
                  return ChatMessageWidget(
                    message: e.message,
                    user: e.user,
                    date: e.date,
                    isMe: e.user.id == user!.id,
                  );
                }).toList();
                return Scaffold(
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterTop,
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: () {
                      AuthService.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child:
                        const Icon(Icons.logout_rounded, color: Colors.white),
                  ),
                  appBar: AppBar(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.chat_bubble_rounded),
                            SizedBox(width: 10),
                            Text('Chat App'),
                          ],
                        ),
                        Row(
                          children: [
                            Text(user!.username),
                            const SizedBox(width: 10),
                            const Icon(Icons.person_rounded),
                          ],
                        ),
                      ],
                    ),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        messages.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Column(
                                    children: const [
                                      SizedBox(height: 10),
                                      Icon(Icons.info_rounded,
                                          size: 25, color: Colors.blue),
                                      Text('No messages'),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                )),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  reverse: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    return messages[index];
                                  },
                                ),
                              ),
                        TextField(
                          controller: messageController,
                          onSubmitted: (value) async {
                            final String message = messageController.text;
                            final Message messageEntity = Message(
                              message: message,
                              user: user,
                              date: DateTime.now(),
                            );
                            final ChatMessageWidget messageWidget =
                                ChatMessageWidget(
                              message: message,
                              user: user,
                              date: DateTime.now(),
                              isMe: true,
                            );
                            await ChatService.addMessage(messageEntity);

                            setState(() {
                              messages.add(messageWidget);
                            });
                            messageController.clear();
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your message',
                            suffixIcon: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: IconButton(
                                  onPressed: () async {
                                    final String message =
                                        messageController.text;
                                    final Message messageEntity = Message(
                                      message: message,
                                      user: user,
                                      date: DateTime.now(),
                                    );
                                    final ChatMessageWidget messageWidget =
                                        ChatMessageWidget(
                                      message: message,
                                      user: user,
                                      isMe: true,
                                      date: DateTime.now(),
                                    );
                                    await ChatService.addMessage(messageEntity);
                                    setState(() {
                                      messages.add(messageWidget);
                                    });
                                    messageController.clear();
                                  },
                                  icon: const Icon(Icons.send_rounded,
                                      color: Colors.blue)),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
