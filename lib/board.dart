// import 'dart:html';

import "package:flame/components.dart";
import 'dart:developer';
import 'dart:ui' as d;
import "package:flutter/material.dart";
// import "package:flame/game.dart";
// // import 'package:flame/input.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//class BoardGame extends SpriteComponent {}

class Tile extends SpriteComponent {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  Tile(this.tile, this.pos) : super(size: Vector2.all(120));
  Vector2 pos;
  int tile;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    int col = tile % 4;
    int row = (tile ~/ 4).toInt();
    // log('row: $row,col:$col');
    sprite = await Sprite.load('p_2048_map.png',
        srcPosition: Vector2(col * 120, row * 120), srcSize: Vector2(120, 120));

    anchor = Anchor.center;
  }

  void loadFromTileList(List<d.Image> listImage) async {
    tile++;
    int i = tile % 16;
    if (i >= listImage.length) {
      sprite?.image = listImage[i];
    }
  }

  void loadFromTileListi(int i, List<d.Image> listImage) async {
    if (i >= listImage.length) {
      sprite?.image = listImage[i];
    }
  }

  void changeSizeAndPosition(int ti, Vector2 size) {
    int col = ti % 4;
    int row = (ti ~/ 4).toInt();
    sprite!.srcPosition = Vector2(col * size.y, row * size.x);
  }

  void changeSizeAndPosition2() {
    tile++;
    int i = tile % 12;
    changeSizeAndPosition(i, sprite!.srcSize);
  }

  void changeSizeAndPosition3(int inc) {
    tile += inc.toInt();
    int i = tile % 12;
    changeSizeAndPosition(i, sprite!.srcSize);
  }
  // @override
  // bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   super.onKeyEvent(event, keysPressed);
  //   position += position + Vector2(0, 5);
  //   return true;
  // }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    // We don't need to set the position in the constructor, we can set it directly here since it will
    // be called once before the first time it is rendered.
    // position = Vector2(100, 100) + position / 2 + pos;
    // this.parent.
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}
