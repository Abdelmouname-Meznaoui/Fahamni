import 'package:fahamni/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'messaging/messagerow.dart';


class MyWidget extends StatelessWidget {
  MyWidget({super.key}); 

 
  final Map<String, String> currentUser = {
    "id": "user1",
    "name": "Me",
    "avatar": "https://static.wikia.nocookie.net/viacom4633/images/4/47/Spongebob.png/revision/latest?cb=20241216025934",
  };
  final Map<String, String> otherUser = {
    "id": "user2",
    "name": "Alice",
    "avatar": "https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg",
  };

  
  final List<MessageModel> messages = [
  MessageModel(
    content: "Hi!",
    senderId: "user2",
    receiverId: "user1",
    sendingDateTime: DateTime.now().subtract(Duration(minutes: 5)),
    messageId: "msg1",
    conversationId: "conv1",
  ),
  MessageModel(
    content: "Hello!",
    senderId: "user1",
    receiverId: "user2",
    sendingDateTime: DateTime.now().subtract(Duration(minutes: 4)),
    messageId: "msg2",
    conversationId: "conv1",
  ),
  MessageModel(
    content: "How are you?",
    senderId: "user2",
    receiverId: "user1",
    sendingDateTime: DateTime.now().subtract(Duration(minutes: 2)),
    messageId: "msg3",
    conversationId: "conv1",
  ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color (0xFFFAFAFA),
      appBar: AppBar(title: Text("Chat Test")),
      body: ListView.builder(
      
        padding: EdgeInsets.all(8),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final bool isMe = msg.senderId == currentUser["id"];
          final String avatarUrl = isMe ? currentUser["avatar"]! : otherUser["avatar"]!;
          return MessageRow(
            message: msg,
            isMe: isMe,
            senderAvatarUrl: avatarUrl,
          );
        },
      ),
    );
  }
}