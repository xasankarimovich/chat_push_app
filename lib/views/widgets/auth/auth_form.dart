import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final Function getUserDetails;
  final bool isLoading;
  const AuthForm(this.getUserDetails, this.isLoading, {super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _userData = {"email": "", "username": "", "password": ""};
  bool isLogin = true;

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      widget.getUserDetails(
        _userData['email']!.trim(),
        _userData['username']!.trim(),
        _userData['password']!.trim(),
        isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email manzili",
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return "Iltimos to'gri email manzil kiriting.";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userData['email'] = newValue!;
                    },
                  ),
                  if (!isLogin)
                    TextFormField(
                      key: const ValueKey("username"),
                      decoration: const InputDecoration(
                        labelText: "Username",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Iltimos username kiriting.";
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _userData['username'] = newValue!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey("parol"),
                    decoration: const InputDecoration(
                      labelText: "Parol",
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Iltimos parol kiriting.";
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userData['password'] = newValue!;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      onPressed: _submit,
                      child: Text(isLogin ? "Kirish" : "Ro'yxantdan o'tish"),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: Text(isLogin ? "Ro'yxatdan o'tish" : "Kirish"),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}