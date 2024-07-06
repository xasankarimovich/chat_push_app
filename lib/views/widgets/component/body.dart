import 'package:chat_app/views/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/utils.dart';
import 'chat_card.dart';
import 'filled_.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          color: AppStyle.kPrimaryColor,
          child: Row(
            children: [
              FillOutlineButton(press: () {}, text: "Recent Message"),
              const SizedBox(width: 16),
              FillOutlineButton(
                press: () {},
                text: "Active",
                isFilled: false,
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const CircularProgressIndicator();
              final users = snapshot.data!.docs;
              return ListView.separated(
                itemCount: users.length,
                separatorBuilder: (context, index) => const Gap(20.0),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                  final chatRoomId = getChatRoomId(currentUserId, user.id);

                  final lastMessage = user.data().containsKey('lastMessage')
                      ? user['lastMessage']
                      : 'No messages yet';
                  final lastActive = user.data().containsKey('lastActive')
                      ? user['lastActive']
                      : 'Unknown';
                  final imageUrl = user.data().containsKey('imageUrl')
                      ? user['imageUrl']
                      : 'https://via.placeholder.com/150';
                  final isOnline = user.data().containsKey('isOnline')
                      ? user['isOnline']
                      : false;

                  final isMe = user.id == currentUserId;
                  // print(isMe);

                  return ChatCard(
                    onPressed: () {
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
                    name: isMe ? "Saved massage" : user['username'],
                    lastMessage: lastMessage,
                    lastActive: lastActive,
                    imageUrl: isMe
                        ? "https://imgs.search.brave.com/IqvW_gBIXwEy9MV39Ri3WFze5QS0QTEhp44s_l4CY7A/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9ibG9n/Lmludml0ZW1lbWJl/ci5jb20vY29udGVu/dC9pbWFnZXMvc2l6/ZS93NjAwLzIwMjQv/MDcvUHJvbW90ZS15/b3VyLVRlbGVncmFt/LXN1YmNyaWJlcnMt/Ym90LnBuZw"
                        : imageUrl,
                    isOnline: isOnline,
                  );
                },
              );
            },
          ),
        ),
      ],
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