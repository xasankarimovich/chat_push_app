// import 'package:chat_app/views/widgets/chat/message_bubble.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class Messages extends StatelessWidget {
//   final String chatRoomId;

//   const Messages({super.key, required this.chatRoomId});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection("chats")
//           .doc(chatRoomId)
//           .collection("messages")
//           .orderBy('createdAt', descending: true)
//           .snapshots(),
//       builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//         if (streamSnapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         final docs = streamSnapshot.data!.docs;
//         // print(docs);
//         return ListView.builder(
//           reverse: true,
//           itemCount: docs.length,
//           itemBuilder: (context, index) {
//             DateTime dt = docs[index]['createdAt'].toDate();
//             String formattedTime = DateFormat('HH:mm').format(dt);
//             return Container(
//               padding: const EdgeInsets.all(16.0),
//               child: MessageBubble(
//                 docs[index]['text'],
//                 docs[index]['userId'] == user!.uid,
//                 key: ValueKey(docs[index].id),
//                 sendTime: formattedTime,
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }

import 'package:chat_app/views/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatelessWidget {
  final String chatRoomId;

  const Messages({
    super.key,
    required this.chatRoomId,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("chats")
          .doc(chatRoomId)
          .collection("messages")
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = streamSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (context, index) {
            DateTime dt = docs[index]['createdAt'].toDate();
            String formattedTime = DateFormat('HH:mm').format(dt);
            final isMe = docs[index]['userId'] == user!.uid;

            return Container(
              padding: const EdgeInsets.all(16.0),
              child: MessageBubble(
                // key: ValueKey(docs[index].id),
                key: ValueKey(docs[index].id),
                message: docs[index].data().toString().contains('imageUrl')
                    ? docs[index]['imageUrl']
                    : docs[index]['text'],
                isMe: isMe,
                sendTime: formattedTime,
                isImage: docs[index].data().toString().contains('imageUrl'),
              ),
            );
          },
        );
      },
    );
  }
}