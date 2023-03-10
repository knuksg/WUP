import 'dart:async';

import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

import 'dart:math';

import 'package:wup/app/data/model/biorhythm_model.dart';
import 'package:wup/app/modules/biorhythm/biorhythm_controller.dart';

class BiorhythmAnimation extends FlameGame with HasDraggables, HasTappables {
  final storage = GetStorage();
  final controller = BiorhythmController();

  bool isCameraMoved = false;
  late Vector2 cameraPosition;
  late Vector2 cameraVelocity;

  double baseHeight = 0;

  double baseWidth = 0;
  double centerWidth = 0;

  late TextComponent todayComponent;
  late SpriteComponent physicalComponent;
  late SpriteComponent emotionalComponent;
  late SpriteComponent intellectualComponent;
  double centerPhysical = 0;
  double centerEmotional = 0;
  double centerIntellectual = 0;
  List<BioData> data = [];
  int tapPositon = 16;

  @override
  Color backgroundColor() => Colors.white;

  @override
  FutureOr<void> onLoad() {
    // TODO: implement onLoad
    return super.onLoad();
  }

  @override
  void onMount() async {
    baseWidth = camera.viewport.canvasSize!.x;
    centerWidth = baseWidth / 2;

    final birthday = DateTime.parse(GetStorage().read('birthday'));
    final today = DateTime.now();
    final delta = today.difference(birthday).inDays;

    final bioList = List.generate(
      31,
      (index) {
        final date = today.add(Duration(days: index - 15));
        final countDays = delta + index - 15;
        var bioPhy = sin(2 * pi * countDays / 23) * 100;
        var bioEmo = sin(2 * pi * countDays / 28) * 100;
        var bioInt = sin(2 * pi * countDays / 33) * 100;

        bioPhy = double.parse(bioPhy.toStringAsFixed(1));
        bioEmo = double.parse(bioEmo.toStringAsFixed(1));
        bioInt = double.parse(bioInt.toStringAsFixed(1));

        return BioData(date, bioPhy, bioEmo, bioInt);
      },
    );

    data.addAll(bioList);

    final firstPhy = data.first.bioPhy;
    final firstEmo = data.first.bioEmo;
    final firstInt = data.first.bioInt;

    centerPhysical = data[16].bioPhy;
    centerEmotional = data[16].bioEmo;
    centerIntellectual = data[16].bioInt;

    storage.write('centerPhysical', data[16].bioPhy);
    storage.write('centerEmotional', data[16].bioEmo);
    storage.write('centerIntellectual', data[16].bioInt);

    final paint1 = Paint()..color = Colors.red;
    final paint2 = Paint()..color = Colors.blue;
    final paint3 = Paint()..color = Colors.green;

    final path0 = Path()..moveTo(198, camera.viewport.canvasSize!.y / 2 - 30);
    final path1 = Path()..moveTo(0, baseHeight + 100 - firstPhy);
    final path2 = Path()..moveTo(0, baseHeight + 100 - firstEmo);
    final path3 = Path()..moveTo(0, baseHeight + 100 - firstInt);
    final path4 = Path()..moveTo(0, baseHeight + 100 - firstPhy);
    final path5 = Path()..moveTo(0, baseHeight + 100 - firstEmo);
    final path6 = Path()..moveTo(0, baseHeight + 100 - firstInt);

    for (var i = 1; i <= 31; i++) {
      final countDays = delta + i - 15;
      var bioPhy = sin(2 * pi * countDays / 23) * 100;
      var bioEmo = sin(2 * pi * countDays / 28) * 100;
      var bioInt = sin(2 * pi * countDays / 33) * 100;

      bioPhy = double.parse(bioPhy.toStringAsFixed(1));
      bioEmo = double.parse(bioEmo.toStringAsFixed(1));
      bioInt = double.parse(bioInt.toStringAsFixed(1));

      final x = i * 30.0;
      final firstX = i * 30.0 + 198;
      final phyY = baseHeight + 100 - bioPhy;
      final emoY = baseHeight + 100 - bioEmo;
      final intY = baseHeight + 100 - bioInt;
      path1.lineTo(x, phyY);
      path2.lineTo(x, emoY);
      path3.lineTo(x, intY);

      if (i <= 9) {
        path0.lineTo(firstX, camera.viewport.canvasSize!.y / 2 - 30);
      }
      if (i <= 16) {
        path4.lineTo(x, phyY);
        path5.lineTo(x, emoY);
        path6.lineTo(x, intY);
      }
    }

    for (var i = 0; i < 300; i++) {
      add(
        CircleComponent(radius: 5)
          ..paint = paint1
          ..position = Vector2(0, baseHeight + 100 - firstPhy)
          ..anchor = Anchor.center
          ..add(
            MoveAlongPathEffect(
              path1,
              EffectController(
                duration: 5,
                startDelay: i * 0.03,
                infinite: true,
              ),
              absolute: true,
            ),
          ),
      );
      add(
        CircleComponent(radius: 5)
          ..paint = paint2
          ..position = Vector2(0, baseHeight + 100 - firstEmo)
          ..anchor = Anchor.center
          ..add(
            MoveAlongPathEffect(
              path2,
              EffectController(
                duration: 5,
                startDelay: i * 0.03,
                infinite: true,
              ),
              absolute: true,
            ),
          ),
      );
      add(
        CircleComponent(radius: 5)
          ..paint = paint3
          ..position = Vector2(0, baseHeight + 100 - firstInt)
          ..anchor = Anchor.center
          ..add(
            MoveAlongPathEffect(
              path3,
              EffectController(
                duration: 5,
                startDelay: i * 0.03,
                infinite: true,
              ),
              absolute: true,
            ),
          ),
      );
    }

    add(todayComponent = TextComponent()
      ..add(MoveAlongPathEffect(path0, EffectController(duration: 5))));

    camera.followComponent(todayComponent);

    final physicalImage = await images.load('Physical.png');
    add(physicalComponent = SpriteComponent.fromImage(physicalImage)
      ..size = Vector2.all(30)
      ..anchor = Anchor.center
      ..priority = Priority.kMaxOffset
      ..add(MoveAlongPathEffect(path4, EffectController(duration: 5))));

    final emotionalImage = await images.load('Emotional.png');
    add(emotionalComponent = SpriteComponent.fromImage(emotionalImage)
      ..size = Vector2.all(30)
      ..anchor = Anchor.center
      ..priority = Priority.kMaxOffset
      ..add(MoveAlongPathEffect(path5, EffectController(duration: 5))));

    final intellectualImage = await images.load('Intellectual.png');
    add(intellectualComponent = SpriteComponent.fromImage(intellectualImage)
      ..size = Vector2.all(30)
      ..anchor = Anchor.center
      ..priority = Priority.kMaxOffset
      ..add(MoveAlongPathEffect(path6, EffectController(duration: 5))));

    add(TextComponent(
      text: 'Today',
      textRenderer: TextPaint(
          style: const TextStyle(
        color: Colors.black,
      )),
      position: Vector2(30.0 * 16, baseHeight + 225),
      anchor: Anchor.center,
    ));

    add(TimerComponent(
        period: 5,
        onTick: () {
          isCameraMoved = true;
          overlays.add('NextButton');
          overlays.add('PreviousButton');
          overlays.add('TodayButton');
        }));

    cameraPosition = Vector2(30.0 * 16, camera.viewport.canvasSize!.y / 2 - 30);
    cameraVelocity = Vector2(0, camera.viewport.canvasSize!.y / 2 - 30);
  }

  @override
  void render(Canvas canvas) async {
    // TODO: implement render
    super.render(canvas);

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
    );

    const textSpan0 = TextSpan(
      text: '0',
      style: textStyle,
    );

    const textSpan1 = TextSpan(
      text: '100',
      style: textStyle,
    );

    const textSpan2 = TextSpan(
      text: '-100',
      style: textStyle,
    );

    final textPainter0 = TextPainter(
      text: textSpan0,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    final textPainter1 = TextPainter(
      text: textSpan1,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final textPainter2 = TextPainter(
      text: textSpan2,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter0.layout();
    textPainter1.layout();
    textPainter2.layout();

    double x = 8.0;
    double y = 112;

    textPainter1.paint(canvas, Offset(x, 5));
    textPainter0.paint(canvas, Offset(x, y));
    textPainter2.paint(canvas, Offset(x, y + 120));

    final paint1 = Paint()
      ..color = const Color.fromARGB(99, 0, 0, 0)
      ..strokeWidth = 2;
    canvas.drawLine(const Offset(0, 25), Offset(baseWidth, 25), paint1);
    canvas.drawLine(Offset(0, y + 20), Offset(baseWidth, y + 20), paint1);
    canvas.drawLine(Offset(0, y + 120), Offset(baseWidth, y + 120), paint1);

    canvas.drawLine(
        Offset(centerWidth, 25), Offset(centerWidth, y + 120), paint1);
    canvas.drawLine(Offset(baseWidth / 4 + 10, 25),
        Offset(baseWidth / 4 + 10, y + 120), paint1);
    canvas.drawLine(Offset(baseWidth / 4 * 3 - 10, 25),
        Offset(baseWidth / 4 * 3 - 10, y + 120), paint1);
    canvas.drawLine(
        Offset(baseWidth - 20, 25), Offset(baseWidth - 20, y + 120), paint1);
    canvas.drawLine(const Offset(20, 25), Offset(20, y + 120), paint1);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    // TODO: implement onDragUpdate
    super.onDragUpdate(pointerId, info);
    final dragDelta = Vector2(info.delta.game.x, 0);
    final dragPos = cameraPosition - dragDelta;
    final maxPos = Vector2(30 * 31 - camera.viewport.effectiveSize.x / 2,
        camera.viewport.canvasSize!.y);
    final minPos = camera.viewport.effectiveSize / 2;
    cameraPosition.x = dragPos.x.clamp(minPos.x + 10, maxPos.x - 10);
    cameraPosition.y = camera.viewport.canvasSize!.y / 2 - 30;
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    // TODO: implement onDragEnd
    super.onDragEnd(pointerId, info);
    cameraVelocity = Vector2(0, camera.viewport.canvasSize!.y / 2 - 30);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isCameraMoved) {
      camera.followVector2(cameraPosition);
    }
  }
}
