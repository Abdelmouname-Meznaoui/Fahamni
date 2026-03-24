import 'package:fahamni/messaging/conversation_doc_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_model.dart';
import 'Message_input.dart';
import 'messagerow.dart';
import 'inside_conversation_buttons.dart';

class ConversationPage extends StatefulWidget {
  final ConversationModel conversation;
  final String imageUrl;
  final String currentUserId;

  const ConversationPage({
    super.key,
    required this.conversation,
    required this.imageUrl,
    required this.currentUserId,
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showDetails = false; // toggles the media/members/attachments panel

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.conversation.conversationName,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1F2937),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'En ligne',
                  style: GoogleFonts.inter(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
  IconButton(
    onPressed: () {
      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ConversationDocPage(
      imageUrl: widget.imageUrl,
      name: widget.conversation.conversationName,
      conversation: widget.conversation,
    ),
  ),
);
    },
    icon: const Icon(
      Icons.info_outline,
      color: Color(0xFF1F2937),
    ),
  ),
],
      ),
      body: Column(
        children: [
          // date header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'TODAY, ${TimeOfDay.now().format(context)}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: widget.conversation.messages.length,
              itemBuilder: (context, index) {
                final msg = widget.conversation.messages[index];
                final bool isMe = msg.senderId == widget.currentUserId;
                return MessageRow(
                  message: msg,
                  isMe: isMe,
                  senderAvatarUrl: isMe
                      ? 'https://static.wikia.nocookie.net/viacom4633/images/4/47/Spongebob.png/revision/latest?cb=20241216025934'
                      : widget.imageUrl,
                );
              },
            ),
          ),

         

          // message input
          Container(
            margin: const EdgeInsets.all(16),
            child: const MessageInput(),
          ),
        ],
      ),
    );
  }
}