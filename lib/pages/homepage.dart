import 'package:chatgame/pages/gamepage.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String nickname;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Text('Pokemon Chat!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 50, shadows: [
                      const Shadow(
                          blurRadius: 10,
                          color: Color.fromARGB(255, 0, 0, 0),
                          offset: Offset(0, 0))
                    ]))),
            SizedBox(
              width: 400,
              child: TextField(
                onSubmitted: (value) {
                  nickname = value;
                },
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                          width: 2.5, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      borderSide: BorderSide(
                          width: 2.5, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                    labelText: '닉네임',
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0), fontSize: 25),
                    filled: true,
                    fillColor: Color.fromARGB(255, 214, 242, 255)),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => GamePlay()));
                },
                child: const Text('Play'))
          ],
        ),
      ),
    );
  }
}
