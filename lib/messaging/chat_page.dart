import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Color(0xFFFAFAFA),
        title: Text(
          'Message',
          style: GoogleFonts.inter(
            color: const Color(0xFF1F2937),
            fontSize: 32.0,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}
