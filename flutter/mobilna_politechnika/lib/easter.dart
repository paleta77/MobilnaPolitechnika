import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
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
  double y = 0;
  double speed = 0;
  Random rand = Random();
  int points = 0;
  bool started = false;
  bool dead = false;

  var tubePos = [200.0, 400.0, 600.0];
  var tubeHeight = [0.0, -10.0, 10.0];

  void resize(Size size) {
    screenSize = size;
    print(screenSize);
    super.resize(size);
  }

  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint paint = Paint();
    paint.color = Color(0xff000000);

    canvas.drawRect(rect, paint);

    double screenCenterX = screenSize.width / 2;
    double screenCenterY = screenSize.height / 2;
    Rect player =
        Rect.fromLTWH(screenCenterX - 20, screenCenterY - 20 + y, 40, 40);

    paint.color = Color(0xffffffff);
    canvas.drawRect(player, paint);

    for (int i = 0; i < tubePos.length; i++) {
      var tube = tubePos[i];
      var height = tubeHeight[i];

      Rect tube1 = Rect.fromLTWH(
          tube, screenCenterY + 75 + height, 50, screenCenterY - 75 - height);
      canvas.drawRect(tube1, paint);

      Rect tube2 = Rect.fromLTWH(tube, 0, 50, screenCenterY - 75 + height);
      canvas.drawRect(tube2, paint);

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
    if(dead)
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
