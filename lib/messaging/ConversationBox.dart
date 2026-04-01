import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import 'conversation_page.dart';

class Conversationbox extends StatelessWidget {
  const Conversationbox({
    super.key,
    required this.conversation,
    required this.imageUrl,
    required this.currentUserId, 
  });

  final ConversationModel conversation;
  final String imageUrl;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    
    final bool isMe = conversation.messages.isNotEmpty && 
                     conversation.messages.last.senderId == currentUserId;
    
    final String displayName = isMe ? "You" : conversation.conversationName;

    return InkWell(
      onTap: () {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationPage(
            conversation: conversation,
            imageUrl: imageUrl,
            currentUserId: currentUserId,
          ),
        ),
    );
},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16,8,16,8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl),
              radius: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.conversationName, 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${isMe ? 'You: ' : ''}${conversation.lastMessageText}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  conversation.lastMessageTime,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                
                if (conversation.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF000080),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${conversation.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white, 
                        fontSize: 10,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 20), 
              ],
            ),
          ],
        ),
      ),
    );
  }
}