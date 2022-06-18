import 'package:app_mspr/models/user.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatelessWidget {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /** Build */
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
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
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
                      print(new User(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          passwordController.text
                      ));
                    } else if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Merci de vérifier votre adresse e-mail.'), backgroundColor: Colors.red)
                      );
                    } else if(password != rePassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Vos mots de passe ne correspondent pas.'), backgroundColor: Colors.red)
                      );
                      passwordController.text = '';
                      rePasswordController.text = '';
                    } else if(password != '' || rePassword != '' || email != '' || lastName != '' || firstName != '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Merci de remplir tous les champs.'), backgroundColor: Colors.red)
                      );
                    }

                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('Cerealis')),
                        body: ScanView(),
                      );
                    }));*/
                  },
                )
            ),
          ],
        ));
  }
}