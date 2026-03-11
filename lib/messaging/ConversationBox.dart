import 'package:flutter/material.dart';
import '../models/chat_model.dart';

class Conversationbox extends StatelessWidget {
  const Conversationbox({
    super.key,
    required this.conversation,
    required this.ImageUrl,
  });
  final ConversationModel conversation;
  final String ImageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(ImageUrl), radius: 28),
              SizedBox(width: 16),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text('patrick ')],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
