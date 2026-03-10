import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'package:google_fonts/google_fonts.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Move the margin outside so it doesn't affect the blur area
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              // Increased opacity slightly for better visibility
              color: Colors.white.withOpacity(0.3), 
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.sentiment_satisfied_alt_outlined, color: Color(0xFF000080)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: GoogleFonts.nunito(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Message...',
                      hintStyle: TextStyle(color: Color(0xFF1F2937)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Icon(Icons.mic_none_outlined, color: Color(0xFF1F2937)),
                const Icon(Icons.attach_file_outlined, color: Color(0xFF1F2937)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}