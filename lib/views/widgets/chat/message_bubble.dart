import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../utils/utils.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String sendTime;
  final bool isImage;

  const MessageBubble({
    required this.message,
    required this.isMe,
    required super.key,
    required this.sendTime,
    required this.isImage,
  });

  void _editMessage(BuildContext context) {
  }

  void _deleteMessage(BuildContext context) {
    // FirebaseFirestore.instance.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            GestureDetector(
              onLongPress: () {
                showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 100, 100, 100),
                  items: [
                    if (isMe)
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.black),
                            Gap(10),
                            Text('Edit'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          Gap(10),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ).then((value) {
                  if (value == 'edit') {
                    _editMessage(context);
                  } else if (value == 'delete') {
                    _deleteMessage(context);
                  }
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: isMe
                        ? const Radius.circular(12.0)
                        : const Radius.circular(20.0),
                    topRight: isMe
                        ? const Radius.circular(20.0)
                        : const Radius.circular(12),
                    bottomLeft: isMe
                        ? const Radius.circular(20)
                        : const Radius.circular(0),
                    bottomRight: isMe
                        ? const Radius.circular(0)
                        : const Radius.circular(20.0),
                  ),
                  color: isMe
                      ? AppStyle.kPrimaryColor.withOpacity(0.8)
                      : AppStyle.kPrimaryColor.withOpacity(0.3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isImage)
                      Image.network(
                        message,
                        fit: BoxFit.cover,
                      )
                    else
                      Text(
                        message,
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black),
                      ),
                    const Gap(10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          sendTime,
                          style: TextStyle(
                            color: isMe ? Colors.white70 : Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // if (isMe)
            //   const Positioned(
            //     right: 0,
            //     bottom: 0,
            //     child: Icon(
            //       Icons.check,
            //       size: 15,
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }
}