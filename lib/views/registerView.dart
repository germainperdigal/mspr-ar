import 'package:app_mspr/models/user.dart';
import 'package:app_mspr/views/scanView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/material.dart';

/// Register view
class RegisterView extends StatelessWidget {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
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
                controller: lastNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
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
                  onPressed: () {
                    var password = passwordController.text;
                    var firstName = firstNameController.text;
                    var lastName = lastNameController.text;
                    var rePassword = rePasswordController.text;
                    var email = emailController.text;
                    if (
                    password != '' && rePassword != '' && email != '' && lastName != '' && firstName != '' &&
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)
                        && password == rePassword
                    ) {
                      var user = User(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          passwordController.text
                      );
                      FirebaseFirestore.instance.collection('users').doc().set({
                        "firstName": user.fName,
                        "lastName": user.lName,
                        "email": user.email,
                        "password": Crypt.sha256(user.password).toString()
                      }).then((doc) {
                        onSuccess(context, 'Bienvenue sur Céréalis');
                      }).catchError((error) {
                        handleError(context, error.toString());
                      });
                    } else if(password != '' || rePassword != '' || email != '' || lastName != '' || firstName != '') {
                      handleError(context, 'Merci de remplir tous les champs.');
                    } else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) == false) {
                      handleError(context, 'Merci de vérifier votre adresse e-mail.');
                    } else if(password != rePassword) {
                      handleError(context, 'Vos mots de passe ne correspondent pas.');
                    }

                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('Cerealis')),
                        body: ScanView(),
                      );
                    }));
                  },
                )
            ),
          ],
        ));
  }
}