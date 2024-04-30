import 'package:chatgame/chatgame.dart';
import 'package:chatgame/components/textbox.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GamePlay extends StatelessWidget {
  GamePlay({super.key});

  Chatgame game = Chatgame();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: kDebugMode ? Chatgame() : game,
        overlayBuilderMap: {
          'TextField': (BuildContext context, Chatgame game) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: SizedBox(
                        width: 400,
                        child: TextField(
                          onSubmitted: (value) {
                            game.player.addMessage(TextBox(value));
                          },
                          decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    width: 3,
                                    color: Color.fromARGB(255, 176, 239, 255)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                    width: 3,
                                    color: Color.fromARGB(255, 176, 239, 255)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
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

class $value {}
