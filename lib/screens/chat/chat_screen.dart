import 'package:flutter/material.dart';

import '../../models/chat_message.dart';

import '../../widgets/message_bubble.dart';
import '../../core/services/chat_services.dart';
import '../../core/services/profile_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  final List<ChatMessage> messages = [];
  final ChatService chatService = ChatService();
  String userName = "User";
  bool isLoadingName = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final profile = await ProfileService().getUserProfile();
      if (mounted) {
        setState(() {
          userName = profile["name"] ?? "User";
          isLoadingName = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingName = false;
        });
      }
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!scrollController.hasClients) {
        return;
      }

      scrollController.animateTo(
        scrollController.position.maxScrollExtent,

        duration: const Duration(milliseconds: 300),

        curve: Curves.easeOut,
      );
    });
  }

  //function to send message
  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    final text = messageController.text.trim();

    messageController.clear();

    setState(() {
      messages.add(ChatMessage(isUser: true, message: text));
    });

    scrollToBottom();

    try {
      // Empty AI Bubble
      setState(() {
        messages.add(ChatMessage(isUser: false, message: ""));
      });

      scrollToBottom();
      //streams coming
      await for (final chunk in chatService.streamMessage(text)) {
        setState(() {
          messages.last.message += chunk;
        });

        scrollToBottom();
      }
    } catch (e) {
      setState(() {
        messages.last.message = "Something went wrong.";
      });
    }
  }

  @override
  void dispose() {
    messageController.dispose();

    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Career Buddy"),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),

            child: Row(
              children: [
                CircleAvatar(radius: 5, backgroundColor: Colors.green),

                SizedBox(width: 8),

                Text("Online"),
              ],
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          if (messages.isEmpty) _buildWelcome(),

          Expanded(
            child: ListView.builder(
              controller: scrollController,

              padding: const EdgeInsets.all(16),

              itemCount: messages.length,

              itemBuilder: (context, index) {
                return MessageBubble(message: messages[index]);
              },
            ),
          ),

          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildWelcome() {
    return Padding(
      padding: const EdgeInsets.all(24),

      child: Column(
        children: [
          Text(
            "Hi ${isLoadingName ? '...' : userName} 👋",

            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          const Text(
            "I'm your AI career mentor.\n\nAsk me anything about resumes, interviews, jobs or career growth.",

            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,

                decoration: InputDecoration(
                  hintText: "Type a message...",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            CircleAvatar(
              radius: 24,

              child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
