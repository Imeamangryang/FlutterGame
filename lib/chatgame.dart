import 'dart:async';
import 'dart:io';

import 'package:chatgame/components/characters/bulbasaur.dart';
import 'package:chatgame/components/characters/charmander.dart';
import 'package:chatgame/components/characters/pikachu.dart';
import 'package:chatgame/components/characters/squirtle.dart';
import 'package:chatgame/components/chat.dart';
import 'package:chatgame/components/levels.dart';
import 'package:chatgame/components/player.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chatgame extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks {
  String name;
  String character;
  late Player player;
  // late final Uri serveruri;
  // late final WebSocketChannel channel;
  Chatgame({required this.name, required this.character}) {
    // Player Setting
    if (character == 'Bulbasaur') {
      player = Bulbasaur(name);
    } else if (character == 'Charmander') {
      player = Charmander(name);
    } else if (character == 'Squirtle') {
      player = Squirtle(name);
    } else if (character == 'Pikachu') {
      player = Pikachu(name);
    }

    // WebSocket Connection
    // serveruri = Uri.parse('ws://localhost:8080/ws');
    // channel = WebSocketChannel.connect(serveruri);
  }

  @override
  Color backgroundColor() => const Color(0xFFE7DDB9);
  late CameraComponent cam;
  late JoystickComponent joystick;
  bool showjoystick = Platform.isAndroid || Platform.isIOS;

  @override
  final Level world = Level(levelName: 'lobby');

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    //cam = CameraComponent.withFixedResolution(world: world, width: 700, height: 320);
    cam = CameraComponent(world: world);
    cam.viewfinder.anchor = Anchor.center;
    cam.viewfinder.zoom = 2;
    cam.priority = 1;

    await addAll([cam, world]);

    // player.debugMode = true;
    // player2.debugMode = true;

    world.addPlayer(player);
    cam.follow(player);

    setplayer();

    if (showjoystick) {
      addJoystick();
      add(ChatButton()..priority = 2);
    }

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showjoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 2,
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
        player.playerDirection = Direction.left;
        break;
      case JoystickDirection.right:
        player.playerDirection = Direction.right;
        break;
      case JoystickDirection.up:
        player.playerDirection = Direction.up;
        break;
      case JoystickDirection.down:
        player.playerDirection = Direction.down;
        break;
      case JoystickDirection.upLeft:
        player.playerDirection = Direction.upleft;
        break;
      case JoystickDirection.upRight:
        player.playerDirection = Direction.upright;
        break;
      case JoystickDirection.downLeft:
        player.playerDirection = Direction.downleft;
        break;
      case JoystickDirection.downRight:
        player.playerDirection = Direction.downright;
        break;
      default:
        player.playerDirection = Direction.none;
        break;
    }
  }

  void setplayer() {
    // WebSocket Send Message
    // channel.sink.add('client says: hello');
    // player.playerID = const Uuid();
    // channel.sink.add(player.playerID.v4());

    // channel.stream.listen((event) {
    //   print(event);
    //   switch (event) {
    //     case 'playername':
    //       // channel.stream.take(2).listen((event) {
    //       //   print(event);
    //       //   print(event);
    //       // });
    //       break;
    //   }
    // });

    Player otherplayer = Charmander('test');
    world.addPlayer(otherplayer);
  }
}
