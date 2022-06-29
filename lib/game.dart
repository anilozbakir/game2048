import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import "package:flame/game.dart";
import 'package:game2048/debug_conf.dart';
import 'package:game2048/game_board.dart';

// import "package:flame/game.dart";
import 'package:flame/input.dart';
// import 'package:flame/sprite.dart';

// import "dart:math";

// import 'dart:developer' as dv;
// import "RecTouch.dart";
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dv;
import "tile_board.dart";
import "tile.dart";
import "game_platform_config.dart";
// main() {
//   final myGame = MyGame(GameBoard(
//       size: Vector2(800, 640),
//       position: Vector2(100, 100),
//       matrix: Vector2(6, 6)));
//   runApp(
//     GameWidget(
//       game: myGame,
//     ),
//   );
// }

class MyGame extends FlameGame
    with KeyboardEvents, HasTappables, HasDraggables {
  //int twopower=1;
  TextPaint gameOverText = TextPaint(
      style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 24));
  TextPaint scoreText = TextPaint(style: const TextStyle(fontSize: 24));
  ButtonComponent undoButton = ButtonComponent(onPressed: () {});
  ButtonComponent homeButton = ButtonComponent();
  int matrixCol = 0;
  int matrixRow = 0;
  Vector2 size;
  MatrixFormat matrix;
  late Vector2 scale;
  MyGame({required this.size, required this.matrix}) : super() {
    var matrixOut = Constants.MatrixConstants[matrix]!.matrix;
    matrixCol = matrixOut.x.toInt();
    matrixRow = matrixOut.y.toInt();
    scale = Constants.MatrixConstants[matrix]!.scale;

    dv.log("selected platform ${defaultTargetPlatform}");
    var scale2 = Constants.constants[defaultTargetPlatform]!.scale;
    var strart = Constants.constants[defaultTargetPlatform]!.scale;
    scale = Vector2(scale.x * scale2.x, scale.y * scale2.y);

    dv.log("selected platform ${TargetPlatform.android}");
  }
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await Tile.loadImage();
    // MyComponents = List.generate(16, (i) {
    super.onLoad();
    //place the background
    dv.log("loading background matrix: $matrixCol x $matrixRow");

    var background = await Sprite.load('p_background.png',
        srcPosition: Vector2(0, 0), srcSize: Vector2(128, 128));
    var bScale =
        Vector2(matrixCol.toDouble() * scale.x, matrixRow.toDouble() * scale.y);
    backsprite = SpriteComponent(sprite: background, scale: bScale);

    add(backsprite!);

    backsprite!.position = size / 8;
    var posBackGround = Vector2(
        backsprite!.position.x * scale.x, backsprite!.position.y * scale.y);
    dv.log('pos: $posBackGround');
    backsprite!.position = posBackGround;
    tileArray = List.generate(matrixRow, (index) => TileLine());
    //backsprite!.position += position;
    Tile bg;
    for (int i = 0; i < matrixRow * matrixCol; i++) {
      int row = (i ~/ matrixCol);
      int col = (i % matrixCol);
      var pos = Vector2(col.toInt() * 128, row.toInt() * 128);
      pos = Vector2(pos.x * scale.x, pos.y * scale.y);
      bg = Tile(this, 0, pos, scale, Vector2(col.toDouble(), row.toDouble()));

      bg.position = posBackGround + pos; // + position;
      pos = bg.position;

      // int col = i % 4;b
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
      element.applyChanges();
    }
    var buttonNewSprite = await Sprite.load('new_button.png',
        srcPosition: Vector2(0, 0), srcSize: Vector2(128, 128));
    undoButton.add(SpriteComponent(
      sprite: buttonNewSprite,
    ));
    undoButton.position =
        tileArray![matrixRow - 1].oldList![0].tileImage!.position +
            tileArray![matrixRow - 1].oldList![0].tileImage!.size * 1.1;
  }

  @override
  bool onTapDown(int pointerId, TapDownInfo event) {
    super.onTapDown(pointerId, event);
    if (DebugConf.tap) {
      dv.log("Player tap down on ${event.eventPosition.game}");
    }
    var v = getClickCoordinate(event.eventPosition.game);
    v.floor();
    if (DebugConf.tap) {
      dv.log(" coordination on board $v");
    }
    return true;
  }

  @override
  bool onTapUp(int info, TapUpInfo event) {
    super.onTapUp(info, event);
    if (DebugConf.tap) {
      dv.log("Player tap up on ${event.eventPosition.game}");
    }
    return true;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    if (isKeyDown) {
      //dv.log("key down");
      // if (isSpace && isKeyDown) {
      //   if (keysPressed.contains(LogicalKeyboardKey.altLeft) ||
      //       keysPressed.contains(LogicalKeyboardKey.altRight)) {
      //     dv.log("pressed alt");
      //   } else {}
      //   return KeyEventResult.handled;
      //  }
      if (isKeyDown) {
        if (DebugConf.matrixChange) {
          var total = "before:\n";
          for (TileLine row in tileArray!) {
            for (var element in row.oldList!) {
              total += "${element.tileIndex} ";
            }
            total += "\n";
          }
          dv.log(total);
        }
      }

      if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        moveDown();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        moveUp();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        moveLeft();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        moveRight();
      }
      //   game.MyComponents[0].position += Matrix2(5, 0, 0, 5) * dir;
      //   game.MyComponents[0].loadFromTileList(game.MyImages);
      //  game.MyComponents[0].changeSizeAndPosition3(dir.x.toInt());
    }
    return KeyEventResult.ignored;
  }

  Vector2 _dragStart = Vector2.all(0);
  set dragStart(Vector2 value) {
    //  if (value.x > 0 && value.y > 0) {
    _dragStart = value;
    //  }
  }

  Vector2 _dragEnd = Vector2.all(0);
  set dragEnd(Vector2 value) {
    //  if (value.x > 0 && value.y > 0) {
    _dragEnd = value;
    dv.log("drag start at $_dragStart");
    dv.log("drag end at $_dragEnd");
    var diff = _dragEnd - _dragStart;
    if (diff.x > diff.y) {}
    var x = diff.x < 0 ? diff.x * (-1) : diff.x;
    var y = diff.y < 0 ? diff.y * (-1) : diff.y;
    dv.log("end $_dragEnd diff $diff $x $y");
    if (x > y) {
      //horizantal m<ove
      if (diff.x <= 0) {
        //left
        moveLeft();
      } else {
        //right
        moveRight();
      }
    } else {
      //vertical move
      if (diff.y <= 0) {
        // up
        moveUp();
      } else {
        //down
        moveDown();
      }
    }
    // }
  }

  List<TileLine>? tileArray;
  SpriteComponent? backsprite;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void update(double t) {
    super.update(t);
  }

  Vector2 getClickCoordinate(Vector2 coordinate) {
    //  dv.log("board $matrixRow   $matrixCol");
    // dv.log("board position $position");
    // dv.log(
    //     " bg pos:${backsprite!.position} scale ${backsprite!.scale}  h ${backsprite!.height} w ${backsprite!.width}");
    double width =
        matrixCol * 128 * tileArray![0].oldList![0].tileImage!.scale.x;
    double height =
        matrixCol * 128 * tileArray![0].oldList![0].tileImage!.scale.y;
    Vector2 start = tileArray![0].oldList![0].tileImage!.position;
    var tl = tileArray![0].oldList![0].tileImage!;
    // dv.log(
    //     " tl0 pos:${tl.position} scale ${tl.scale}  h ${tl.height} w ${tl.width}");
    // // backsprite!.position;
    // dv.log(" tile width $width ");
    // return Vector2(-1, -1);
    //coordinate -= position;
    // if (coordinate.x >= start.x &&
    //     coordinate.x < (start.x + width) &&
    //     coordinate.y >= start.y &&
    //     coordinate.y < (start.y + height)) {
    double x = coordinate.x - start.x;
    x = x / (128 * tileArray![0].oldList![0].tileImage!.scale.x);
    double y = coordinate.y - start.y;
    y = y / (128 * tileArray![0].oldList![0].tileImage!.scale.y);
    return Vector2(x, y);
    // } else {
    //   return Vector2(-1, -1);
    // }
  }

  moveDown() {
    dv.log("down key");
//----

    List<TileLine> transpose = TileLine.getTransposeMatrix(tileArray!);
    transpose.forEach((element) {
      element.shiftRight();
    });
    List<TileLine> transpose2 = TileLine.getTransposeMatrix(transpose);
//---
    int index = 0;

    tileArray!.forEach((element) {
      //   dv.log('$index');

      element.getLineTileValues(transpose2[index++]);
      element.applyChanges();
    });
    if (DebugConf.matrixChange) {
      var total = "after:\n";
      for (TileLine row in tileArray!) {
        for (var element in row.oldList!) {
          total += "${element.tileIndex} ";
        }
        total += "\n";
      }
      dv.log(total);
    }
    putNewTiles();
    refresh();
  }

  refresh() {
    // if (parent != null) {
    //   for (var child in parent!.children) {
    //     if (child is Tile) {
    //       parent!.remove(child);
    //     }
    //   }
    //   if (main != null) addToFlameGame(main!);
    // }
  }

  moveUp() {
    if (DebugConf.keyLog) {
      dv.log("up key");
    }

    List<TileLine> transpose = TileLine.getTransposeMatrix(tileArray!);
    transpose.forEach((element) {
      element.shiftLeft();
    });
    List<TileLine> transpose2 = TileLine.getTransposeMatrix(transpose);
    int index = 0;

    tileArray!.forEach((element) {
      //dv.log('$index');
      element.getLineTileValues(transpose2[index++]);

      element.applyChanges();
    });
    if (DebugConf.matrixChange) {
      var total = "after:\n";
      for (TileLine row in tileArray!) {
        for (var element in row.oldList!) {
          total += "${element.tileIndex} ";
        }
        total += "\n";
      }
      dv.log(total);
    }
    putNewTiles();
    refresh();
  }

  moveLeft() {
    if (DebugConf.keyLog) {
      dv.log(" left");
    }

    tileArray!.forEach((element) {
      element.shiftLeft();
      element.applyChanges();
    });
    putNewTiles();
    refresh();
  }

  moveRight() {
    if (DebugConf.keyLog) {
      dv.log(" right");
    }

    //  int line = 1;
    tileArray!.forEach((element) {
      // dv.log("line:${line++}");
      element.shiftRight();
      element.applyChanges();
    });
    if (DebugConf.matrixChange) {
      var total = "after:\n";
      for (TileLine row in tileArray!) {
        for (var element in row.oldList!) {
          total += "${element.tileIndex} ";
        }
        total += "\n";
      }
      dv.log(total);
    }
    putNewTiles();
    refresh();
  }

  // putNewTiles() {
  //   for (var element in main!.children) {
  //     if (element is Tile ) {
  //        var e=TileData(   )
  //       element.tileImage!.changeSizeAndPosition(
  //           element.tileIndex, element.tileImage!.sprite!.srcSize);
  //     }
  //   }
  // }

  putNewTiles() {
    TileLine.placeNewTiles2(tileArray!);
    tileArray!.forEach((element) {
      element.applyChanges();
    });
  }
}
