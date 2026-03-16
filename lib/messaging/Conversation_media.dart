import 'package:fahamni/messaging/chat_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class ConversationMedia extends StatefulWidget {
  const ConversationMedia({super.key});

  @override
  State<ConversationMedia> createState() => _ConversationMediaState();
}

class _ConversationMediaState extends State<ConversationMedia> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, 
          crossAxisSpacing: 8, 
          mainAxisSpacing: 8, 
        ),
        itemCount: 20, 
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/200'),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
