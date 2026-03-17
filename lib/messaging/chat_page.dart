import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chat_buttons.dart';
import 'ConversationBox.dart';
import '../models/chat_model.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final String myId = "user1";

  final List<Map<String, dynamic>> mockConversations = [
    {
      "id": "user2",
      "name": "Patrick",
      "avatar": "https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg",
    },
    {
      "id": "user3",
      "name": "Hamza",
      "avatar": "https://randomuser.me/api/portraits/men/32.jpg",
    },
    {
      "id": "user4",
      "name": "Sara",
      "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
    },
    {
      "id": "user5",
      "name": "Mohamed",
      "avatar": "https://randomuser.me/api/portraits/men/75.jpg",
    },
    {
      "id": "user6",
      "name": "Lina",
      "avatar": "https://randomuser.me/api/portraits/women/68.jpg",
    },
  ];

  ConversationModel _buildMockConversation(Map<String, dynamic> user) {
    return ConversationModel(
      conversationId: "conv_${user['id']}",
      conversationName: user['name'],
      participants: [myId, user['id']],
      status: "active",
      createdAt: DateTime.now(),
      messages: [
        MessageModel(
          messageId: "m1",
          conversationId: "conv_${user['id']}",
          senderId: user['id'],
          receiverId: myId,
          content: "Hey! How are you doing?",
          sendingDateTime: DateTime.now().subtract(const Duration(minutes: 10)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
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
          // Search bar
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

          // Tabs
          const ChatButtons(),

          // Conversation list
          Expanded(
            child: ListView.separated(
              itemCount: mockConversations.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, indent: 80),
              itemBuilder: (context, index) {
                final user = mockConversations[index];
                return Conversationbox(
                  conversation: _buildMockConversation(user),
                  imageUrl: user['avatar'],
                  currentUserId: myId,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}