import 'package:flame/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'dart:math';

class Easter extends StatefulWidget {
  @override
  _EasterState createState() => new _EasterState();
}

class _EasterState extends State<Easter> {
  bool ready = true;
  void startGame() {}
  @override
  Widget build(BuildContext context) {
    var game = EasterGame();
    return ready ? game.widget : Container(color: Colors.white);
  }
}

class EasterGame extends Game with TapDetector {
  Size screenSize;
  double y;
  double speed;
  Random rand = Random();
  int points;
  bool started;
  bool dead;

  List<double> tubePos;
  List<double> tubeHeight;

  var bgSprite = Sprite('spritesheet.png', width: 144, height: 255);
  var playerSprite = Sprite('spritesheet.png', x: 144, width: 17, height: 12);
  var playerSprite1 =
      Sprite('spritesheet.png', x: 144 + 17.0, width: 17, height: 12);
  var playerSprite2 =
      Sprite('spritesheet.png', x: 144 + 17.0 * 2, width: 17, height: 12);
  var tubeUpSpirite =
      Sprite('spritesheet.png', x: 144, y: 36, width: 26, height: 160);
  var tubeDownSpirite =
      Sprite('spritesheet.png', x: 144 + 26.0, y: 36, width: 26, height: 160);

  void resize(Size size) {
    screenSize = size;
    reset();
    super.resize(size);
  }

  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint paint = Paint();
    paint.color = Color(0xff000000);
    canvas.drawRect(rect, paint);
    bgSprite.render(canvas, width: screenSize.width, height: screenSize.height);

    double screenCenterX = screenSize.width / 2;
    double screenCenterY = screenSize.height / 2;
    Rect player =
        Rect.fromLTWH(screenCenterX - 20, screenCenterY - 20 + y, 30, 30);

    paint.color = Color(0xffffffff);
    //canvas.drawRect(player, paint);
    if (speed < -100)
      playerSprite2.renderPosition(
          canvas, Position(player.left - 5, player.top),
          size: Position(40, 30));
    else if (speed < 0)
      playerSprite1.renderPosition(
          canvas, Position(player.left - 5, player.top),
          size: Position(40, 30));
    else
      playerSprite.renderPosition(canvas, Position(player.left - 5, player.top),
          size: Position(40, 30));

    for (int i = 0; i < tubePos.length; i++) {
      var tube = tubePos[i];
      var height = tubeHeight[i];

      Rect tube1 = Rect.fromLTWH(
          tube, screenCenterY + 75 + height, 50, screenCenterY - 75 - height);
      //canvas.drawRect(tube1, paint);
      tubeDownSpirite.renderPosition(canvas, Position(tube1.left, tube1.top),
          size: Position(tube1.width, tube1.height));
     
      Rect tube2 = Rect.fromLTWH(tube, 0, 50, screenCenterY - 75 + height);
      //canvas.drawRect(tube2, paint);
      tubeUpSpirite.renderPosition(canvas, Position(tube2.left, tube2.top),
          size: Position(tube2.width, tube2.height));

      Rect inter1 = tube1.intersect(player);
      Rect inter2 = tube2.intersect(player);
      if ((inter1.width > 0 && inter1.height > 0) ||
          (inter2.width > 0 && inter2.height > 0)) {
        dead = true;
        started = false;
      }
    }

    final TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: points.toString(), style: TextStyle(color: Colors.red)),
        textDirection: TextDirection.ltr)
      ..layout(maxWidth: 200);
    textPainter.paint(canvas, Offset(screenCenterX, 50));
  }

  void update(double t) {
    if (started) {
      speed += 400 * t;
      y += speed * t;

      if (y > screenSize.height / 2) reset();

      for (int i = 0; i < tubePos.length; i++) {
        var tube = tubePos[i];
        tubePos[i] -= 80 * t;
        if (tube < -50) {
          tubePos[i] = 600 - 50.0;
          tubeHeight[i] = rand.nextDouble() * 100;
        }
        if (tube > (screenSize.height / 2 + 50 + 50) &&
            tubePos[i] <= (screenSize.height / 2 + 50 + 50)) points++;
      }
    }
  }

  void onTapDown(TapDownDetails d) {
    if (dead)
      reset();
    else
      started = true;
    speed = -300;
  }

  void reset() {
    speed = y = 0;
    points = 0;
    tubePos = [300.0, 500.0, 700.0];
    tubeHeight = [0.0, -10.0, 10.0];
    started = false;
    dead = false;
  }
}
