import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/views/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      default:
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log in",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: TextButton(
              onPressed: () async {
                authProvider.handleSignIn().then((isSuccess) {
                  if (isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  }
                }).catchError((error, stackTrace) {
                  Fluttertoast.showToast(msg: error.toString());
                  authProvider.handleException();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Color(0xffdd4b39).withOpacity(0.8);
                    return Color(0xffdd4b39);
                  },
                ),
                splashFactory: NoSplash.splashFactory,
                padding: MaterialStateProperty.all<EdgeInsets>(
                  EdgeInsets.fromLTRB(30, 15, 30, 15),
                ),
              ),
              child: const Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          // Loading
          Positioned(
            child: authProvider.status == Status.authenticating
                ? LoadingView()
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
