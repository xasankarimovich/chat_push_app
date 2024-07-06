import 'package:chat_app/views/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All users"),
        centerTitle: true,
        actions: [
          DropdownButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            items: const [
              DropdownMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final users = snapshot.data!.docs;
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (context, index) => const Gap(20.0),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                onTap: () {
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                  final chatRoomId = getChatRoomId(currentUserId, user.id);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        chatRoomId: chatRoomId,
                        receiverId: user.id,
                        name: user['username'],
                      ),
                    ),
                  );
                },
                leading: const CircleAvatar(),
                title: Text(user['username']),
                subtitle: Text(user['email']),
              );
            },
          );
        },
      ),
    );
  }

  String getChatRoomId(String userId1, String userId2) {
    if (userId1.hashCode <= userId2.hashCode) {
      return '$userId1-$userId2';
    } else {
      return '$userId2-$userId1';
    }
  }
}