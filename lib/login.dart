import 'dart:typed_data';

import 'package:app_mspr/views/registerView.dart';
import 'package:app_mspr/views/scanView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

/// Login widget
class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => LoginView();
}

/// LoginView
class LoginView extends State<LoginWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Redirect to scan
  redirectToScan() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
            title: const Text('Cerealis'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Show Snackbar',
                onPressed: () {},
              )
            ],
        ),
        body: ScanWidget(),
      );
    }));
  }

  /// Handle error
  handleError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), backgroundColor: Colors.red)
    );
  }

  @override
  Widget build(BuildContext context) {
    final LocalStorage storage = new LocalStorage('user');

    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Bienvenue !',
                  style: TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Adresse e-mail',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                redirectToScan();
              },
              child: const Text('Se connecter en tant qu\'invité',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Se connecter'),
                  onPressed: () {
                    if (passwordController.text != '' && emailController.text != '') {
                      FirebaseFirestore.instance.collection('users').where('email', isEqualTo: emailController.text)
                          .snapshots().listen((event) {
                        if (event.docs.isNotEmpty && Crypt(event.docs[0]['password']).match(passwordController.text)) {
                          redirectToScan();
                          storage.setItem('user', emailController.text);
                        } else {
                          handleError(context, 'Impossible de reconnaitre vos identifiants');
                        }
                      });
                    }
                  },
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Nouvel utilisateur ?'),
                TextButton(
                  child: const Text(
                    'S\'inscrire !',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('Cerealis')),
                        body: RegisterView(),
                      );
                    }));
                  },
                )
              ],
            ),
          ],
        ));
  }
}