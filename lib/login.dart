import 'package:app_mspr/main.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  /** Build */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cerealis',
      home: Scaffold(
        appBar: AppBar(title: const Text('Cerealis')),
        body: const MyStatefulWidget(),
      ),
    );
  }
}