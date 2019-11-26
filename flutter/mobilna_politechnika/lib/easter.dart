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
  Random rand = Random();
  Size screenSize;
  double y;
  double speed;
  double ground;
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
  var groundSprite =
      Sprite('spritesheet.png', x: 196, y: 0, width: 168, height: 56);

  List<Sprite> fontSprites = List<Sprite>(); //196,160

  EasterGame() {
    for (var i = 0; i <= 9; i++)
      fontSprites.add(Sprite('spritesheet.png',
          x: 196.0 + 12 * i, y: 158, width: 12, height: 18));
  }

  void resize(Size size) {
    screenSize = size;
    reset();
    super.resize(size);
  }

  void drawScore(Canvas canvas) {
    // there must be better way of doing this! :(
    var p = points ~/ 100 % 10;
    var s = false;
    var pos =
        Position(screenSize.width / 2 - 12, screenSize.height / 8);
    var size = Position(24, 26);
    if (p > 0) {
      fontSprites[p].renderPosition(canvas, pos, size: size);
      s = true;
      pos.x += 25;
    }
    p = points ~/ 10 % 10;
    if (p > 0 || s) {
      fontSprites[p].renderPosition(canvas, pos, size: size);
      pos.x += 25;
    }
    p = (points).toInt() % 10;
    fontSprites[p].renderPosition(canvas, pos, size: size);
  }

  void render(Canvas canvas) {
    bgSprite.render(canvas, width: screenSize.width, height: screenSize.height);

    double screenCenterX = screenSize.width / 2;
    double screenCenterY = screenSize.height / 2;
    Rect player = Rect.fromLTWH(
        screenCenterX * 0.75 - 20, screenCenterY - 20 + y, 30, 30);

    Position playerPos =
        Position(screenCenterX * 0.75 - 25, screenCenterY - 20 + y);
    Position playerSize = Position(40, 30);

    for (int i = 0; i < tubePos.length; i++) {
      var tube = tubePos[i];
      var height = tubeHeight[i];

      Rect tube1 =
          Rect.fromLTWH(tube, screenCenterY + height + 75, 50, (50 / 26) * 160);
      tubeDownSpirite.renderPosition(canvas, Position(tube1.left, tube1.top),
          size: Position(tube1.width, tube1.height));

      Rect tube2 = Rect.fromLTWH(tube,
          screenCenterY + height - (50 / 26) * 160 - 75, 50, (50 / 26) * 160);
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

    groundSprite.renderPosition(
        canvas, Position(ground, screenSize.height - 56),
        size: Position(
            screenSize.width * 1.5, (screenSize.width * 1.5 / 168) * 56));

    if (speed < -100)
      playerSprite2.renderPosition(canvas, playerPos, size: playerSize);
    else if (speed < 0)
      playerSprite1.renderPosition(canvas, playerPos, size: playerSize);
    else
      playerSprite.renderPosition(canvas, playerPos, size: playerSize);

    drawScore(canvas);
  }

  void update(double t) {
    if (started) {
      speed += 400 * t;
      y += speed * t;

      if (y > screenSize.height / 2 - 56 - 10) {
        dead = true;
        started = false;
      }

      ground -= 80 * t;
      if (ground < -screenSize.width / 3) ground = -4;

      for (int i = 0; i < tubePos.length; i++) {
        var tube = tubePos[i];
        tubePos[i] -= 80 * t;
        if (tube < -50) {
          tubePos[i] = 600 - 50.0;
          tubeHeight[i] = 50 - rand.nextDouble() * 100;
        }
        if (tube > (screenSize.width / 2 - 70) &&
            tubePos[i] <= (screenSize.width / 2 - 70)) points++;
      }
    }
  }

  void onTapDown(TapDownDetails d) {
    if (dead)
      reset();
    else
      started = true;
    speed = -280;
  }

  void reset() {
    speed = y = 0;
    ground = 0;
    points = 0;
    tubePos = [
      300.0 + screenSize.width,
      500.0 + screenSize.width,
      700.0 + screenSize.width
    ];
    tubeHeight = [0.0, -10.0, 10.0];
    started = false;
    dead = false;
  }
}
