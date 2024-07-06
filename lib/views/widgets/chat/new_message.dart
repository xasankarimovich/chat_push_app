import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/utils.dart';

class NewMessage extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;

  const NewMessage({
    super.key,
    required this.chatRoomId,
    required this.receiverId,
  });

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _formKey = GlobalKey<FormState>();
  final _messageTextController = TextEditingController();
  String? _message;

  void _sendMessage() {
    _formKey.currentState!.save();

    if (_message != null && _message!.trim().isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection("chats")
          .doc(widget.chatRoomId)
          .collection("messages")
          .add({
        "text": _message,
        'createdAt': Timestamp.now(),
        'userId': user!.uid,
        'receiverId': widget.receiverId
      });
      _messageTextController.clear();
      setState(() {});
    }
  }

  Future<void> _sendImage(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    final storageRef = FirebaseStorage.instance.ref().child('chat_images').child(
        '${widget.chatRoomId}/${Timestamp.now().millisecondsSinceEpoch}.jpg');

    await storageRef.putFile(imageFile);
    final imageUrl = await storageRef.getDownloadURL();

    FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chatRoomId)
        .collection("messages")
        .add({
      "imageUrl": imageUrl,
      'createdAt': Timestamp.now(),
      'userId': user!.uid,
      'receiverId': widget.receiverId
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      await _sendImage(imageFile);
    }
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16 / 2,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 32,
              color: const Color(0xFF087949).withOpacity(0.08),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              const Icon(Icons.mic, color: AppStyle.kPrimaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16 * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: AppStyle.kPrimaryColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                      const SizedBox(width: 16 / 4),
                      Expanded(
                        child: TextFormField(
                          controller: _messageTextController,
                          onChanged: (value) {
                            setState(() {
                              _message = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "Type message",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      _messageTextController.text.trim().isEmpty
                          ? Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.attach_file,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                            onPressed: _pickImage,
                          ),
                          const SizedBox(width: 16 / 4),
                          IconButton(
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                            onPressed: _pickImage,
                          ),
                        ],
                      )
                          : IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: _sendMessage,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}