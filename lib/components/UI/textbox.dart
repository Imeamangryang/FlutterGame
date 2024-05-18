import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

class TextBox extends TextBoxComponent {
  TextBox(String text)
      : super(
          text: text,
          textRenderer: TextPaint(
              style: const TextStyle(fontSize: 10, color: Color.fromARGB(255, 10, 10, 1))),
          boxConfig: const TextBoxConfig(maxWidth: 100, timePerChar: 0.08, growingBox: true),
        );

  @override
  Future<void> onLoad() async {
    debugMode = false;
    return super.onLoad();
  }

  final bgPaint = Paint()..color = const Color.fromARGB(255, 255, 255, 255);
  final borderPaint = Paint()
    ..color = const Color(0xFF000000)
    ..style = PaintingStyle.stroke;

  @override
  void render(Canvas canvas) {
    anchor = Anchor.centerLeft;
    RRect rrect = RRect.fromLTRBR(0, 0, width, height, const Radius.circular(10));
    canvas.drawRRect(rrect, bgPaint);
    canvas.drawRRect(rrect, borderPaint);
    position = Vector2(50, 30);
    super.render(canvas);
  }
}
