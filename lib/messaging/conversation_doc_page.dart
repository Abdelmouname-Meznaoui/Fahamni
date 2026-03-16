import 'package:fahamni/messaging/chat_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'chat_buttons.dart';
import 'ConversationBox.dart';
import '../models/chat_model.dart';
import 'inside_conversation_buttons.dart';
import 'Conversation_media.dart';


class ConversationDocPage extends StatelessWidget {
  const ConversationDocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.menu, color: Color(0xFF1F2937)),
            offset: const Offset(0, 50), // Positions the menu below the bar
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (value) {},
            itemBuilder: (context) => [
              const PopupMenuItem(value: 1, child: Text("Delete Conversation")),
              const PopupMenuItem(value: 2, child: Text("Quit Conversation")),
              const PopupMenuItem(value: 3, child: Text("Report Conversation")),
            ],
          ),
          const SizedBox(width: 8), 
        ],  
      ),
      body: Column(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage:NetworkImage('https://anniversaire-celebrite.com/images/celebrites/patrick-etoile-de-mer.jpg'),
          ),
          SizedBox(height: 6.0),
          Text(
            'Mr Mohamed',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          InsideConversationButtons(),
          SizedBox(height: 8.0),
          ConversationDocPage(),
        ],
      ),
    );
  }
}