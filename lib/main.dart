import 'package:app_mspr/login.dart';
import 'package:flutter/material.dart';

/// Main
void main() => (
    runApp(
        MaterialApp(home: BaseApp())
    )
);

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