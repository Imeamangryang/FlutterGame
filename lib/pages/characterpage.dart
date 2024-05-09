import 'package:chatgame/pages/gamepage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CharacterMenu extends StatelessWidget {
  late String name;
  CharacterMenu({super.key, required this.name}) {
    name = name;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Choose Your Character',
                style: TextStyle(fontSize: 40),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                      'assets/images/Characters/Bulbasaur/Bulbasaur.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain),
                ),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide.none),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GamePlay(
                            name: name,
                            character: 'Bulbasaur',
                          )));
                },
              ),
              IconButton(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                      'assets/images/Characters/Charmander/Charmander.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain),
                ),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide.none),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GamePlay(
                            name: name,
                            character: 'Charmander',
                          )));
                },
              ),
              IconButton(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                      'assets/images/Characters/Squirtle/Squirtle.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain),
                ),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide.none),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GamePlay(
                            name: name,
                            character: 'Squirtle',
                          )));
                },
              ),
              IconButton(
                icon: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                      'assets/images/Characters/Pikachu/Pikachu.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain),
                ),
                style: ButtonStyle(
                  side: MaterialStateProperty.all(BorderSide.none),
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => GamePlay(
                            name: name,
                            character: 'Pikachu',
                          )));
                },
              ),
            ],
          ),
        ],
      )),
    );
  }
}
