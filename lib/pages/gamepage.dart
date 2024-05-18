import 'package:chatgame/chatgame.dart';
import 'package:chatgame/components/UI/textbox.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class GamePlay extends StatelessWidget {
  late String name;
  late String character;
  late Chatgame game;
  GamePlay({super.key, required this.name, required this.character}) {
    game = Chatgame(name: name, character: character);
    name = name;
    character = character;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: game,
        //game: kDebugMode ? Chatgame(name: name, character: character) : game,
        overlayBuilderMap: {
          'TextField': (BuildContext context, Chatgame game) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: SizedBox(
                        width: 400,
                        child: TextField(
                          onSubmitted: (value) {
                            game.player.addMessage(TextBox(value));
                            game.sendMessage(value, 'MessageSend');
                          },
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(width: 3, color: Color.fromARGB(255, 176, 239, 255)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide:
                                    BorderSide(width: 3, color: Color.fromARGB(255, 176, 239, 255)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              labelText: '',
                              alignLabelWithHint: false,
                              filled: true,
                              fillColor: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
