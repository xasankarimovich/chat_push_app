import 'package:chat_app/views/widgets/chat/messages.dart';
import 'package:chat_app/views/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;
  final String receiverId;
  final String name;

  const ChatScreen({
    super.key,
    required this.chatRoomId,
    required this.receiverId,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackButton(),
            const CircleAvatar(
              backgroundColor: Colors.black,
            ),
            const Gap(16 * 0.75),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  "Active 3m ago",
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_phone),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          const SizedBox(width: 16 / 2),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(chatRoomId: chatRoomId),
          ),
          NewMessage(chatRoomId: chatRoomId, receiverId: receiverId),
        ],
      ),
    );
  }
}