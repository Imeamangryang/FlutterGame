import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatgame/components/UI/eating.dart';
import 'package:chatgame/components/berries.dart';
import 'package:chatgame/components/characters/bulbasaur.dart';
import 'package:chatgame/components/characters/charmander.dart';
import 'package:chatgame/components/characters/pikachu.dart';
import 'package:chatgame/components/characters/squirtle.dart';
import 'package:chatgame/components/UI/chat.dart';
import 'package:chatgame/components/levels.dart';
import 'package:chatgame/components/Player/player.dart';
import 'package:chatgame/components/UI/textbox.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Chatgame extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks, TapCallbacks, HasCollisionDetection {
  String name;
  String character;
  late Player player;
  late final Uri serveruri;
  late final WebSocketChannel channel;
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
    player.playerID = const Uuid().v4();

    //WebSocket Connection
    serveruri = Uri.parse('ws://218.55.63.234:8888/ws');
    channel = WebSocketChannel.connect(serveruri);

    sendMessage(character, 'JoinPlayer');
  }

  List<String> playerIDlist = [];
  List<Player> playerlist = [];

  @override
  Color backgroundColor() => const Color(0xFFE7DDB9);
  late CameraComponent cam;
  late JoystickComponent joystick;
  bool showjoystick = false;
  Direction previousDirection = Direction.none;

  @override
  final Level world = Level(levelName: 'lobby');

  List<String> berryList = [
    'belue-berry',
    'bluk-berry',
    'cheri-berry',
    'chesto-berry',
    'durin-berry',
    'enigma-berry',
    'figy-berry',
    'grepa-berry',
    'leppa-berry',
    'lum-berry',
    'mago-berry',
    'oran-berry',
    'pamtre-berry',
    'pecha-berry',
    'persim-berry',
    'rawst-berry',
    'sitrus-berry',
    'wiki-berry',
    'yache-berry'
  ];

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    cam = CameraComponent(world: world);
    cam.viewfinder.anchor = Anchor.center;
    cam.viewfinder.zoom = 2;
    cam.priority = 1;

    await addAll([cam, world]);

    // player.debugMode = true;

    world.addPlayer(player);
    cam.follow(player);

    listenMessage();

    for (int i = 0; i < berryList.length; i++) {
      final berry = Berry(berry: berryList[i], position: Vector2(300 + i * 30, 300));
      world.add(berry);
    }

    if (kIsWeb) {
    } else {
      if (Platform.isAndroid || Platform.isIOS) {
        showjoystick = true;
      }
    }
    if (showjoystick) {
      addJoystick();
    }
    add(ChatButton()..priority = 2);

    final eatbutton = EatingButton();
    add(eatbutton);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (showjoystick) {
      updateJoystick();
    }
    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final Direction newDirection;
    final isLEFTKeypressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    final isRIGHTKeypressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    final isUPKeypressed = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    final isDOWNKeypressed = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);

    if (isLEFTKeypressed && isUPKeypressed) {
      newDirection = Direction.upleft;
    } else if (isRIGHTKeypressed && isUPKeypressed) {
      newDirection = Direction.upright;
    } else if (isLEFTKeypressed && isDOWNKeypressed) {
      newDirection = Direction.downleft;
    } else if (isRIGHTKeypressed && isDOWNKeypressed) {
      newDirection = Direction.downright;
    } else if (isLEFTKeypressed) {
      newDirection = Direction.left;
    } else if (isRIGHTKeypressed) {
      newDirection = Direction.right;
    } else if (isUPKeypressed) {
      newDirection = Direction.up;
    } else if (isDOWNKeypressed) {
      newDirection = Direction.down;
    } else {
      newDirection = Direction.none;
    }

    if (newDirection != previousDirection) {
      player.playerDirection = newDirection;
      sendMessage(newDirection.toString(), 'MovePlayer');
      previousDirection = newDirection;
    }
    return super.onKeyEvent(event, keysPressed);
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
    final Direction newDirection;
    switch (joystick.direction) {
      case JoystickDirection.left:
        newDirection = Direction.left;
        break;
      case JoystickDirection.right:
        newDirection = Direction.right;
        break;
      case JoystickDirection.up:
        newDirection = Direction.up;
        break;
      case JoystickDirection.down:
        newDirection = Direction.down;
        break;
      case JoystickDirection.upLeft:
        newDirection = Direction.upleft;
        break;
      case JoystickDirection.upRight:
        newDirection = Direction.upright;
        break;
      case JoystickDirection.downLeft:
        newDirection = Direction.downleft;
        break;
      case JoystickDirection.downRight:
        newDirection = Direction.downright;
        break;
      default:
        newDirection = Direction.none;
        break;
    }

    if (newDirection != previousDirection) {
      player.playerDirection = newDirection;
      sendMessage(newDirection.toString(), 'MovePlayer');
      previousDirection = newDirection;
    }
  }

  void sendMessage(String msg, String event) {
    final message = jsonEncode({
      'Event': event,
      'PlayerID': player.playerID,
      'PlayerName': player.playername,
      'PosX': player.position.x,
      'PosY': player.position.y,
      'Message': msg
    });
    channel.sink.add(message);
  }

  void listenMessage() {
    channel.stream.listen((message) {
      final data = jsonDecode(message);

      switch (data['Event']) {
        case 'MessageSend':
          for (var player in playerlist) {
            if (player.playerID == data['PlayerID']) {
              player.addMessage(TextBox(data['Message']));
            }
          }
          break;
        case 'AddPlayer':
          setplayer(data['PlayerID'], data['PlayerName'], data['Message'],
              Vector2(data['PosX'], data['PosY']));
          break;
        case "RemovePlayer":
          var targetplayer;
          for (var player in playerlist) {
            if (player.playerID == data['PlayerID']) {
              targetplayer = player;
              playerIDlist.remove(player.playerID);
              world.remove(player);
            }
          }
          playerlist.remove(targetplayer);
        case 'MovePlayer':
          for (var otherplayer in playerlist) {
            if (otherplayer.playerID == data['PlayerID']) {
              switch (data['Message']) {
                case 'Direction.left':
                  otherplayer.playerDirection = Direction.left;
                  break;
                case 'Direction.right':
                  otherplayer.playerDirection = Direction.right;
                  break;
                case 'Direction.up':
                  otherplayer.playerDirection = Direction.up;
                  break;
                case 'Direction.down':
                  otherplayer.playerDirection = Direction.down;
                  break;
                case 'Direction.upleft':
                  otherplayer.playerDirection = Direction.upleft;
                  break;
                case 'Direction.upright':
                  otherplayer.playerDirection = Direction.upright;
                  break;
                case 'Direction.downleft':
                  otherplayer.playerDirection = Direction.downleft;
                  break;
                case 'Direction.downright':
                  otherplayer.playerDirection = Direction.downright;
                  break;
                case 'Direction.none':
                  otherplayer.playerDirection = Direction.none;
                  break;
              }
            }
          }

        default:
          break;
      }
    });
  }

  void setplayer(String playerID, String name, String character, Vector2 position) {
    late final Player otherplayer;
    if (character == 'Bulbasaur') {
      otherplayer = Bulbasaur(name);
    } else if (character == 'Charmander') {
      otherplayer = Charmander(name);
    } else if (character == 'Squirtle') {
      otherplayer = Squirtle(name);
    } else if (character == 'Pikachu') {
      otherplayer = Pikachu(name);
    }
    otherplayer.playerID = playerID;
    world.addPlayer(otherplayer);
    if (position.x != 0 || position.y != 0) {
      otherplayer.position = position;
    }

    playerlist.add(otherplayer);
    playerIDlist.add(otherplayer.playerID);
  }
}
