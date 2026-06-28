import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,

        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,

        children: [
          if (!isUser)
            const CircleAvatar(
              radius: 18,
              child: Icon(Icons.smart_toy, size: 18),
            ),

          if (!isUser) const SizedBox(width: 8),

          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

              decoration: BoxDecoration(
                color: isUser ? Colors.blue : Colors.grey.shade200,

                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),

                  topRight: const Radius.circular(18),

                  bottomLeft: Radius.circular(isUser ? 18 : 4),

                  bottomRight: Radius.circular(isUser ? 4 : 18),
                ),
              ),

              child: Text(
                message.message,

                style: TextStyle(
                  fontSize: 15,
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),

          if (isUser) const SizedBox(width: 8),

          if (isUser)
            const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 18)),
        ],
      ),
    );
  }
}
