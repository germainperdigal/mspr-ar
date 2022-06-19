import 'package:app_mspr/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Main
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: 'AIzaSyC6-Wxh7pxzs8x-1V2HIk8ceA1aNf1FYwQ', appId: "1:116789126327:web:e33e739557a25864901932", messagingSenderId: "116789126327", projectId: "cerealis-2bef9")
  );
  runApp(
      MaterialApp(home: BaseApp())
  );
}

/// Base app
class BaseApp extends StatelessWidget {
  /// Build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber)
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text('Cerealis')),
          body: const LoginWidget(),
        )
    );
  }
}