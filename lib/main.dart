import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/providers/providers.dart';
import 'package:chat_app/views/screens/auth_screen.dart';
import 'package:chat_app/views/screens/home_screen.dart';
import 'package:chat_app/views/screens/main_screen.dart';
import 'package:chat_app/views/screens/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  MyApp({super.key, required this.prefs});

  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, AsyncSnapshot<User?> userSnapshot) {
          print(userSnapshot);
          if (userSnapshot.hasData) {
            return const MainScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}

// import 'package:chat_app/pages/splash_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// import 'providers/providers.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   runApp(MyApp(prefs: prefs));
// }
//
// class MyApp extends StatelessWidget {
//   final SharedPreferences prefs;
//
//   MyApp({super.key, required this.prefs});
//
//   final _firebaseFirestore = FirebaseFirestore.instance;
//   final _firebaseStorage = FirebaseStorage.instance;
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<AuthProvider>(
//           create: (_) => AuthProvider(
//             firebaseAuth: FirebaseAuth.instance,
//             googleSignIn: GoogleSignIn(),
//             prefs: this.prefs,
//             firebaseFirestore: this._firebaseFirestore,
//           ),
//         ),
//         Provider<SettingProvider>(
//           create: (_) => SettingProvider(
//             prefs: this.prefs,
//             firebaseFirestore: this._firebaseFirestore,
//             firebaseStorage: this._firebaseStorage,
//           ),
//         ),
//         Provider<HomeProvider>(
//           create: (_) => HomeProvider(
//             firebaseFirestore: this._firebaseFirestore,
//           ),
//         ),
//         Provider<ChatProvider>(
//           create: (_) => ChatProvider(
//             prefs: this.prefs,
//             firebaseFirestore: this._firebaseFirestore,
//             firebaseStorage: this._firebaseStorage,
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: "Chat app",
//         theme: ThemeData(
//           useMaterial3: true,
//         ),
//         home: SplashPage(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
