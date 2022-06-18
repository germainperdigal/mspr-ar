import 'package:flutter/material.dart';

import 'package:app_mspr/views/scanView.dart';
import 'package:app_mspr/views/registerView.dart';

void main() => (
    runApp(
        MaterialApp(home: MyApp())
    )
);

class MyApp extends StatelessWidget {
  /** Build */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber)
        ),
        title: 'La planète',
        home: Scaffold(
          appBar: AppBar(title: const Text('Cerealis')),
          body: const MyStatefulWidget(),
        )
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => LoginView();
}

class LoginView extends State<MyStatefulWidget> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                  'Se connecter',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
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
                //forgot password screen
              },
              child: const Text('Mot de passe oublié ?',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Se connecter'),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(title: const Text('Cerealis')),
                        body: ScanView(),
                      );
                    }));
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
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