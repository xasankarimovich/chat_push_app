import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final isValid = _formKey.currentState?.validate();
    if (!isValid!) return;

    setState(() {
      _isLoading = true;
    });

    String? imageUrl;
    if (_profileImage != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${user.uid}.jpg');
      await ref.putFile(_profileImage!);
      imageUrl = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'username': _usernameController.text,
      if (imageUrl != null) 'imageUrl': imageUrl,
    });

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    _usernameController.text = userData['username'];
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_profileImage != null)
                CircleAvatar(
                  radius: 40,
                  backgroundImage: FileImage(_profileImage!),
                )
              else
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      'https://www.gravatar.com/avatar/${_auth.currentUser?.uid}?d=identicon'), // Placeholder image
                ),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Upload Profile Picture'),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _usernameController,
                  decoration:
                  const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
              const Gap(20.0),
              TextButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}