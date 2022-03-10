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
    // MyComponents = List.generate(16, (i) {

    //place the background
    Sprite background = await Sprite.load('p_background.png',
        srcPosition: Vector2(0, 0), srcSize: Vector2(128 * 4, 128 * 4));
    SpriteComponent backsprite =
        SpriteComponent(sprite: background, scale: Vector2(1, 1));

    add(backsprite);
    backsprite.position = Vector2(-60, -60) + size / 8;
    var pos = backsprite.position;
    dv.log('pos: $pos');

    tileArray = List.generate(4, (index) => new TileLine());
    Tile bg;
    for (int i = 0; i < 16; i++) {
      int row = (i ~/ 4);
      int col = (i % 4);
      var pos = Vector2(col.toInt() * 128, row.toInt() * 128);

      bg = Tile(0, pos);

      bg.position = Vector2(0, 0) + size / 8 + pos;
      pos = bg.position;
      super.onLoad();
      // int col = i % 4;
      // int row = (i ~/ 4).toInt();
      dv.log('row: $row,col:$col, pos: $pos');
      add(bg);
      tileArray![row].add(TileData(tileIndex: bg.tile, tileImage: bg));
      // MyComponents.add(bg);
    }
    //place new tiles randomly
    TileLine.getTotalFree(tileArray!);
    TileLine.PlaceNewTiles(tileArray!);
    tileArray!.forEach((element) {
      element.ApplyChanges();
    });
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
