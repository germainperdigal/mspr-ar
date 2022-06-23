import 'dart:convert';

import 'package:app_mspr/models/user.dart';
import 'package:app_mspr/views/scanView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Register view
class RegisterView extends StatelessWidget {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Handle error
  handleError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), backgroundColor: Colors.red)
    );
  }

  /// On success
  onSuccess(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bienvenue sur Céréalis.'), backgroundColor: Colors.green)
    );
  }

  /// Build
  @override
  Widget build(BuildContext context) {
    const hubSpotApiKey = 'eu1-af1d-09c8-4a81-a9db-4af88ba92c38';
    const hubSpotEndPoint = 'https://api.hubapi.com/contacts/v1/contact/?hapikey=eu1-af1d-09c8-4a81-a9db-4af88ba92c38';
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
                  'Inscription',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prénom',
                ),
              ),
            ),
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
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: rePasswordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirmation mot de passe',
                ),
              ),
            ),
            Container(
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('S\'inscrire'),
                  onPressed: () async {
                    var password = passwordController.text;
                    var firstName = firstNameController.text;
                    var rePassword = rePasswordController.text;
                    var email = emailController.text;
                    if (
                    password != '' && rePassword != '' && email != '' && firstName != '' &&
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)
                        && password == rePassword
                    ) {
                      var user = User(
                          firstNameController.text,
                          emailController.text,
                          passwordController.text
                      );
                      Map<String, String> headers = new Map();
                      headers["content-type"] =  "application/json";

                      var response = await http.post(
                          Uri.parse(hubSpotEndPoint),
                          headers: headers,
                          body: jsonEncode({
                            "properties": [
                              {
                                "property": "email",
                                "value": user.email
                              },
                              {
                                "property": "firstname",
                                "value": user.fName
                              }
                              ]
                          })
                      );

                      FirebaseFirestore.instance.collection('users').doc().set({
                        "firstName": user.fName,
                        "email": user.email,
                        "password": Crypt.sha256(user.password).toString()
                      }).then((doc) {
                        onSuccess(context, 'Bienvenue sur Céréalis');
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return Scaffold(
                            appBar: AppBar(title: const Text('Cerealis')),
                            body: ScanWidget(),
                          );
                        }));
                      }).catchError((error) {
                        handleError(context, error.toString());
                      });
                    } else if(password != '' || rePassword != '' || email != '' || firstName != '') {
                      handleError(context, 'Merci de remplir tous les champs.');
                    } else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) == false) {
                      handleError(context, 'Merci de vérifier votre adresse e-mail.');
                    } else if(password != rePassword) {
                      handleError(context, 'Vos mots de passe ne correspondent pas.');
                    }
                  },
                )
            ),
          ],
        ));
  }
}