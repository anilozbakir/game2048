import "package:flame/game.dart";

import "package:flame/components.dart";
import 'package:flame/input.dart';
import "package:flame/palette.dart";
import "dart:ui";
import "dart:developer" as dv;

class Rows {
  Vector2 topPadding;
  Vector2 bottomPadding;
  Vector2 leftPadding;
  Vector2 rightPadding;
  Vector2 componentDimension;
  Vector2 _presentPosition = Vector2.all(0);
  double _xoffset = 0;
  int rowIndex = 0;
  Map<String, GameText> texts = {};
  List<ButtonComponent> buttons = [];
  List<SpriteComponent> images = [];
  Rows(Vector2 presentPosition,
      {required this.componentDimension,
      required this.topPadding,
      required this.bottomPadding,
      required this.leftPadding,
      required this.rightPadding}) {
    _presentPosition = presentPosition + topPadding;
    _xoffset = presentPosition.x;
  }

  Vector2 get presentPosition {
    return _presentPosition;
  }

  addText(GameText paint) {
    _presentPosition += rightPadding;
    paint.position = presentPosition;
    dv.log("adding text to ${presentPosition}");
    texts[paint.title] = paint;
    _presentPosition += Vector2(componentDimension.x, 0);
    _presentPosition += leftPadding;
  }

  addButton(ButtonComponent component) {
    _presentPosition += rightPadding;
    component.position = presentPosition;
    dv.log("adding button to ${presentPosition}");
    buttons.add(component);

    _presentPosition += Vector2(componentDimension.x, 0);
    _presentPosition += leftPadding;
  }

  addComponent(SpriteComponent component) {
    _presentPosition += rightPadding;
    component.position = presentPosition;
    dv.log("adding component to ${presentPosition}");
    images.add(component);
    _presentPosition += Vector2(componentDimension.x, 0);
    _presentPosition += leftPadding;
  }

  newRow() {
    rowIndex++;
    _presentPosition = Vector2(
        _xoffset,
        _presentPosition.y +
            componentDimension.y +
            topPadding.y +
            bottomPadding.y);
  }

  render(Canvas c) {
    for (var text in texts.values) {
      text.paint.render(c, text.message, text.position);
    }
  }
}

class GameText {
  String title;
  TextPaint paint;
  Vector2 _position = Vector2(0, 0);
  set position(Vector2 pos) {
    _position = pos;
  }

  Vector2 get position {
    return _position;
  }

  String message;
  GameText({required this.title, required this.paint, required this.message});
}
