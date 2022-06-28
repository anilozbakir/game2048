// import 'dart:html';

import "package:flame/components.dart";
import 'dart:ui' as d;
import "package:flutter/material.dart";
import "dart:developer" as dv;
import "package:flame/components.dart" as cmp;
import 'package:flame/input.dart';
import 'package:game2048/game_board.dart';
import "game.dart";

class Tile extends SpriteComponent with cmp.Draggable {
  // creates a component that renders the crate.png sprite, with size 16 x 16  }
  static Sprite? spriteImage;
  Vector2 lastPostion = Vector2.all(0);
  static loadImage() async {
    spriteImage = await Sprite.load('p_2048_map_2.png');
  }

  Vector2 pos;
  int tile;
  MyGame parent;
  Vector2 positionInMatrix;
  Tile(this.parent, this.tile, this.pos, Vector2 scale, this.positionInMatrix)
      : super(size: Vector2.all(120)) {
    int col = tile % 4;
    int row = (tile ~/ 4).toInt();
    // log('row: $row,col:$col');
    sprite = Sprite(spriteImage!.image,
        srcPosition: Vector2(col * 120, row * 120), srcSize: Vector2(120, 120));
    dv.log("loading image ${pos}");
    this.scale = scale;
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
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

  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    parent.dragStart = positionInMatrix;
    return false;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo info) {
    lastPostion = info.eventPosition.global;
    return false;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo event) {
    var last = parent.getClickCoordinate(lastPostion);

    parent.dragEnd = last;
    return false;
  }
}
