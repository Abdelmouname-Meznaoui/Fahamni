import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isTextEmpty = _controller.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(20, 0, 0, 128),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: (){},
                child: const Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                  color: Color(0xFF000080),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: GoogleFonts.nunito(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Message...',
                    hintStyle: TextStyle(color: Color(0xFF1F2937)),
                    border: InputBorder.none,
                  ),
                ),
              ),

              if (_isTextEmpty) ...[
                GestureDetector(
                  onTap: (){},
                  child: const Icon(
                    Icons.attach_file_outlined,
                    color: Color(0xFF1F2937),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: (){},
                  child: const Icon(
                    Icons.mic_none_outlined,
                    color: Color(0xFF1F2937),
                    size: 24,
                  ),
                ),
              ] else
                Transform.rotate(
                  angle:
                      -45 *
                      (3.14159 / 180), // Rotates 45 degrees counter-clockwise
                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF000080),
                      size: 28,
                    ),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
