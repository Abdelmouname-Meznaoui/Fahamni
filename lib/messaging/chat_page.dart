import 'package:fahamni/messaging/chat_buttons.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'chat_buttons.dart';
import 'ConversationBox.dart';
import '../models/chat_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  final String myId = "user1";
  final Map<String, String> otherUser = {
    "id": "user2",
    "name": "Patrick",
    "avatar": "https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg",
  };

  @override
  Widget build(BuildContext context) {
    final mockConversation = ConversationModel(
      conversationId: "conv1",
      conversationName: otherUser["name"]!,
      participants: [myId, otherUser["id"]!],
      status: "active",
      createdAt: DateTime.now(),
      messages: [
        MessageModel(
          messageId: "m1",
          conversationId: "conv1",
          senderId: "user2",
          receiverId: "user1",
          content: "Hi! Check out this long message test...",
          sendingDateTime: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Text(
            'Messages',
            style: GoogleFonts.inter(
              color: const Color(0xFF1F2937),
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(140, 0, 0, 128),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Icon(Icons.search, color: Color.fromARGB(179, 31, 41, 55)),
                  ),

                  Expanded(
                    child: TextField(
                      style: GoogleFonts.inter(fontSize: 16.0),
                      decoration: const InputDecoration(
                        hintText: 'Search Conversations...',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(179, 31, 41, 55),
                        ),
                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ChatButtons(),
          Conversationbox(
            conversation: mockConversation,
            imageUrl: otherUser["avatar"]!,
            currentUserId: myId,
          ),
          
          
          const Divider(height: 1, indent: 80), 
          
          Conversationbox(
            conversation: mockConversation,
            imageUrl: otherUser["avatar"]!,
            currentUserId: myId,
          ),
        ],
      ),
    );
  }
}
