import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mingly/src/api_service/api_service.dart';
import 'package:mingly/src/constant/app_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> chatMessages = [];
  bool isTyping = false;

  Future<void> sendMessage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    // Add user message
    setState(() {
      chatMessages.add({"role": "user", "text": message});
      _messageController.clear();
      isTyping = true;
    });

    // Auto-scroll down
    _scrollToBottom();

    try {
      final response = await ApiService().postData(AppUrls.sendChat, {
        "message": message,
        "history": [],
      }, authToken: preferences.getString("authToken"));

      if (response.isNotEmpty) {
        final aiFullText = response["message"] ?? "No response from AI.";
        await _simulateTyping(aiFullText);
      } else {
        await _simulateTyping("❌ Server error occurred.");
      }
    } catch (e) {
      await _simulateTyping("⚠️ Network error: $e");
    } finally {
      setState(() => isTyping = false);
    }
  }

  /// Slowly types out AI message
  Future<void> _simulateTyping(String fullText) async {
    String currentText = "";
    chatMessages.add({"role": "ai", "text": currentText});
    setState(() {});

    for (int i = 0; i < fullText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 20)); // typing speed
      currentText += fullText[i];
      chatMessages[chatMessages.length - 1]["text"] = currentText;
      setState(() {});
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget buildMessageBubble(Map<String, dynamic> msg) {
    bool isUser = msg["role"] == "user";
    Color bubbleColor = isUser ? Colors.blue.shade100 : Colors.grey.shade200;
    Alignment align = isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isUser
                ? const Radius.circular(12)
                : const Radius.circular(0),
            bottomRight: isUser
                ? const Radius.circular(0)
                : const Radius.circular(12),
          ),
        ),
        child: SelectableText(
          msg["text"],
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar:  AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'AI Assistant',
          style: TextStyle( 
            color: theme.colorScheme.primary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                return buildMessageBubble(chatMessages[index]);
              },
            ),
          ),

          if (isTyping)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                "AI is typing...",
                style: TextStyle(color: Colors.grey),
              ),
            ),

          // Input field
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.black87),
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        hintStyle: const TextStyle(color: Colors.black),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: sendMessage,
                    icon: const Icon(Icons.send, color: Colors.black),
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
