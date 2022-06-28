// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/material.dart';
// import "debug_conf.dart";
// import 'tile.dart';

// // import "package:flame/game.dart";
// // import 'package:flame/input.dart';
// // import 'package:flame/sprite.dart';

// // import "dart:math";

// import 'dart:developer' as dv;
// import "dart:ui" as d;
// import 'dart:developer';
// import "tile_board.dart";
// import "dart:math";
// import "dart:math";

// class GameBoard extends PositionComponent {
//   //final List<Tile> MyComponents = [];
//   // // final List<d.Image> MyImages = [];
//   // int rowCount = 5;
//   // int colCount = 5;
//   // Map<int, int> boardMap = {};
//   // Map<int, int> freeTiles = {};
//   // double screenCenterX = 0;
//   // double screenCenterY = 0;
//   // double sizeR = 60;
//   // bool hasWon = false;

//   int matrixCol = 0;
//   int matrixRow = 0;
//   FlameGame? main;
//   bool first = true;
//   Vector2 _dragStart = Vector2.all(0);
//   set dragStart(Vector2 value) {
//     //  if (value.x > 0 && value.y > 0) {
//     _dragStart = value;
//     //  }
//   }

//   Vector2 _dragEnd = Vector2.all(0);
//   set dragEnd(Vector2 value) {
//     //  if (value.x > 0 && value.y > 0) {
//     _dragEnd = value;
//     dv.log("drag start at $_dragStart");
//     dv.log("drag end at $_dragEnd");
//     var diff = _dragEnd - _dragStart;
//     if (diff.x > diff.y) {}
//     var x = diff.x < 0 ? diff.x * (-1) : diff.x;
//     var y = diff.y < 0 ? diff.y * (-1) : diff.y;
//     dv.log("end $_dragEnd diff $diff $x $y");
//     if (x > y) {
//       //horizantal m<ove
//       if (diff.x <= 0) {
//         //left
//         moveLeft();
//       } else {
//         //right
//         moveRight();
//       }
//     } else {
//       //vertical move
//       if (diff.y <= 0) {
//         // up
//         moveUp();
//       } else {
//         //down
//         moveDown();
//       }
//     }
//     // }
//   }

//   List<TileLine>? tileArray;
//   SpriteComponent? backsprite;
//   GameBoard(
//       {required Vector2 position,
//       required Vector2 size,
//       required Vector2 matrix})
//       : super(position: position, size: size) {
//     matrixCol = matrix.x.toInt();
//     matrixRow = matrix.y.toInt();
//   }
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     await Tile.loadImage();
//     // MyComponents = List.generate(16, (i) {
//     super.onLoad();
//     //place the background
//     dv.log("loading background matrix: $matrixCol x $matrixRow");
//     var scale = Vector2(0.5, 0.5);
//     var background = await Sprite.load('p_background.png',
//         srcPosition: Vector2(0, 0), srcSize: Vector2(128, 128));
//     var bScale =
//         Vector2(matrixCol.toDouble() * scale.x, matrixRow.toDouble() * scale.y);
//     backsprite = SpriteComponent(sprite: background, scale: bScale);

//     // add(backsprite!);
//     backsprite!.position = size / 8;
//     var posBackGround = Vector2(
//         backsprite!.position.x * scale.x, backsprite!.position.y * scale.y);
//     dv.log('pos: $posBackGround');
//     backsprite!.position = posBackGround;
//     tileArray = List.generate(matrixRow, (index) => TileLine());
//     //backsprite!.position += position;
//     Tile bg;
//     for (int i = 0; i < matrixRow * matrixCol; i++) {
//       int row = (i ~/ matrixCol);
//       int col = (i % matrixCol);
//       var pos = Vector2(col.toInt() * 128, row.toInt() * 128);
//       pos = Vector2(pos.x * scale.x, pos.y * scale.y);
//       bg = Tile(this, 0, pos, scale, Vector2(col.toDouble(), row.toDouble()));

//       bg.position = posBackGround + pos; // + position;
//       pos = bg.position;

//       // int col = i % 4;b
//       // int row = (i ~/ 4).toInt();
//       dv.log('row: $row,col:$col, pos: $pos');
//       // add(bg);
//       tileArray![row].add(TileData(tileIndex: bg.tile, tileImage: bg));
//       // MyComponents.add(bg);
//     }
//     //place new tiles randomly
//     TileLine.getTotalFree(tileArray!);
//     TileLine.placeNewTiles2(tileArray!);
//     for (var element in tileArray!) {
//       element.applyChanges();
//     }
//   }

//   addToFlameGame(FlameGame main) {
//     this.main = main;

//     if (first) {
//       main.add(backsprite!);
//     }

//     for (TileLine tileLine in tileArray!) {
//       for (var tile in tileLine.oldList!) {
//         main.add(tile.tileImage!);
//       }
//     }

//     first = false;
//   }

//   @override
//   void render(Canvas canvas) {
//     super.render(canvas);
//   }

//   @override
//   void update(double t) {
//     super.update(t);
//   }

//   Vector2 getClickCoordinate(Vector2 coordinate) {
//     //  dv.log("board $matrixRow   $matrixCol");
//     // dv.log("board position $position");
//     // dv.log(
//     //     " bg pos:${backsprite!.position} scale ${backsprite!.scale}  h ${backsprite!.height} w ${backsprite!.width}");
//     double width =
//         matrixCol * 128 * tileArray![0].oldList![0].tileImage!.scale.x;
//     double height =
//         matrixCol * 128 * tileArray![0].oldList![0].tileImage!.scale.y;
//     Vector2 start = tileArray![0].oldList![0].tileImage!.position;
//     var tl = tileArray![0].oldList![0].tileImage!;
//     // dv.log(
//     //     " tl0 pos:${tl.position} scale ${tl.scale}  h ${tl.height} w ${tl.width}");
//     // // backsprite!.position;
//     // dv.log(" tile width $width ");
//     // return Vector2(-1, -1);
//     coordinate -= position;
//     // if (coordinate.x >= start.x &&
//     //     coordinate.x < (start.x + width) &&
//     //     coordinate.y >= start.y &&
//     //     coordinate.y < (start.y + height)) {
//     double x = coordinate.x - start.x;
//     x = x / (128 * tileArray![0].oldList![0].tileImage!.scale.x);
//     double y = coordinate.y - start.y;
//     y = y / (128 * tileArray![0].oldList![0].tileImage!.scale.y);
//     return Vector2(x, y);
//     // } else {
//     //   return Vector2(-1, -1);
//     // }
//   }

//   moveDown() {
//     dv.log("down key");
// //----

//     List<TileLine> transpose = TileLine.getTransposeMatrix(tileArray!);
//     transpose.forEach((element) {
//       element.shiftRight();
//     });
//     List<TileLine> transpose2 = TileLine.getTransposeMatrix(transpose);
// //---
//     int index = 0;

//     tileArray!.forEach((element) {
//       //   dv.log('$index');

//       element.getLineTileValues(transpose2[index++]);
//       element.applyChanges();
//     });
//     if (DebugConf.matrixChange) {
//       var total = "after:\n";
//       for (TileLine row in tileArray!) {
//         for (var element in row.oldList!) {
//           total += "${element.tileIndex} ";
//         }
//         total += "\n";
//       }
//       dv.log(total);
//     }
//     putNewTiles();
//     refresh();
//   }

//   refresh() {
//     if (parent != null) {
//       for (var child in parent!.children) {
//         if (child is Tile) {
//           parent!.remove(child);
//         }
//       }
//       if (main != null) addToFlameGame(main!);
//     }
//   }

//   moveUp() {
//     if (DebugConf.keyLog) {
//       dv.log("up key");
//     }

//     List<TileLine> transpose = TileLine.getTransposeMatrix(tileArray!);
//     transpose.forEach((element) {
//       element.shiftLeft();
//     });
//     List<TileLine> transpose2 = TileLine.getTransposeMatrix(transpose);
//     int index = 0;

//     tileArray!.forEach((element) {
//       //dv.log('$index');
//       element.getLineTileValues(transpose2[index++]);

//       element.applyChanges();
//     });
//     if (DebugConf.matrixChange) {
//       var total = "after:\n";
//       for (TileLine row in tileArray!) {
//         for (var element in row.oldList!) {
//           total += "${element.tileIndex} ";
//         }
//         total += "\n";
//       }
//       dv.log(total);
//     }
//     putNewTiles();
//     refresh();
//   }

//   moveLeft() {
//     if (DebugConf.keyLog) {
//       dv.log(" left");
//     }

//     tileArray!.forEach((element) {
//       element.shiftLeft();
//       element.applyChanges();
//     });
//     putNewTiles();
//     refresh();
//   }

//   moveRight() {
//     if (DebugConf.keyLog) {
//       dv.log(" right");
//     }

//     //  int line = 1;
//     tileArray!.forEach((element) {
//       // dv.log("line:${line++}");
//       element.shiftRight();
//       element.applyChanges();
//     });
//     if (DebugConf.matrixChange) {
//       var total = "after:\n";
//       for (TileLine row in tileArray!) {
//         for (var element in row.oldList!) {
//           total += "${element.tileIndex} ";
//         }
//         total += "\n";
//       }
//       dv.log(total);
//     }
//     putNewTiles();
//     refresh();
//   }

//   // putNewTiles() {
//   //   for (var element in main!.children) {
//   //     if (element is Tile ) {
//   //        var e=TileData(   )
//   //       element.tileImage!.changeSizeAndPosition(
//   //           element.tileIndex, element.tileImage!.sprite!.srcSize);
//   //     }
//   //   }
//   // }

//   putNewTiles() {
//     TileLine.placeNewTiles2(tileArray!);
//     tileArray!.forEach((element) {
//       element.applyChanges();
//     });
//   }
// }
