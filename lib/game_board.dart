import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'board.dart';

// import "package:flame/game.dart";
// import 'package:flame/input.dart';
// import 'package:flame/sprite.dart';

// import "dart:math";

import 'dart:developer' as dv;
import "dart:ui" as d;
import 'dart:developer';
import "tile_board.dart";
import "dart:math";

class GameBoard extends PositionComponent {
  //final List<Tile> MyComponents = [];
  // // final List<d.Image> MyImages = [];
  // int rowCount = 5;
  // int colCount = 5;
  // Map<int, int> boardMap = {};
  // Map<int, int> freeTiles = {};
  // double screenCenterX = 0;
  // double screenCenterY = 0;
  // double sizeR = 60;
  // bool hasWon = false;

  List<TileLine>? tileArray;
  GameBoard({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Tile.loadImage();
    // MyComponents = List.generate(16, (i) {
    super.onLoad();
    //place the background
    dv.log("loading background");
    var scale = Vector2(0.5, 0.5);
    Sprite background = await Sprite.load('p_background.png',
        srcPosition: Vector2(0, 0), srcSize: Vector2(128 * 4, 128 * 4));
    SpriteComponent backsprite =
        SpriteComponent(sprite: background, scale: scale);

    add(backsprite);
    backsprite.position = Vector2(-60, -60) + size / 8;
    var pos = Vector2(
        backsprite.position.x * scale.x, backsprite.position.y * scale.y);
    dv.log('pos: $pos');

    tileArray = List.generate(4, (index) => new TileLine());
    Tile bg;
    for (int i = 0; i < 16; i++) {
      int row = (i ~/ 4);
      int col = (i % 4);
      var pos = Vector2(col.toInt() * 128, row.toInt() * 128);
      pos = Vector2(pos.x * scale.x, pos.y * scale.y);
      bg = Tile(0, pos, scale);

      bg.position = Vector2(0, 0) +
          Vector2((size.x / 8) * scale.x, (size.y / 8) * scale.y) +
          pos;
      pos = bg.position;

      // int col = i % 4;
      // int row = (i ~/ 4).toInt();
      dv.log('row: $row,col:$col, pos: $pos');
      add(bg);
      tileArray![row].add(TileData(tileIndex: bg.tile, tileImage: bg));
      // MyComponents.add(bg);
    }
    //place new tiles randomly
    TileLine.getTotalFree(tileArray!);
    TileLine.placeNewTiles2(tileArray!);
    for (var element in tileArray!) {
      element.ApplyChanges();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double t) {
    super.update(t);
  }
}
