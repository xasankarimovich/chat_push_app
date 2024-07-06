import 'package:chat_app/views/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  void _getUserDetails(String useEmail, String userName, String userPassword,
      bool isLogin) async {
    UserCredential _userCredential;
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLogin) {
        _userCredential = await _auth.signInWithEmailAndPassword(
          email: useEmail,
          password: userPassword,
        );
      } else {
        _userCredential = await _auth.createUserWithEmailAndPassword(
          email: useEmail,
          password: userPassword,
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(_userCredential.user!.uid)
            .set({
          'username': userName,
          'email': useEmail,
        });
      }
    } on FirebaseException catch (e) {
      var msg = "Kechirasiz malumot nimagadir yo'q";

      if (e.message != null) {
        msg = e.message!;
      }

      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text("Ok"),
            ),
          ],
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_getUserDetails, _isLoading),
    );
  }
}