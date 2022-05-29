import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import "package:flame/game.dart";
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

main() {
  final myGame =
      MyGame(GameBoard(size: Vector2(640, 480), position: Vector2(100, 100)));
  runApp(
    GameWidget(
      game: myGame,
    ),
  );
}

class MyGame extends FlameGame with KeyboardEvents {
  //int twopower=1;
  GameBoard game;
  MyGame(this.game) : super();
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    //  GameBoard g1=g? ??
    add(game);
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
      Vector2 dir = Vector2(1, 0);
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        dv.log("down key");
        dir = Vector2(0, 1);
        List<TileLine> transpose = TileLine.GetTransposeMatrix(game.tileArray!);
        transpose.forEach((element) {
          element.shiftRight2();
        });
        List<TileLine> transpose2 = TileLine.GetTransposeMatrix(transpose);
        int index = 0;
        if (!TileLine.PlaceNewTiles(transpose2)) {
          dv.log("game end");
          return KeyEventResult.handled;
        }
        game.tileArray!.forEach((element) {
          dv.log('$index');

          element.GetLineTileValues(transpose2[index++]);
          element.ApplyChanges();
        });
        putNewTiles();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        dv.log("up key");
        dir = Vector2(0, -1);

        List<TileLine> transpose = TileLine.GetTransposeMatrix(game.tileArray!);
        transpose.forEach((element) {
          element.shiftLeft2();
        });
        List<TileLine> transpose2 = TileLine.GetTransposeMatrix(transpose);
        int index = 0;
        game.tileArray!.forEach((element) {
          dv.log('$index');
          element.GetLineTileValues(transpose2[index++]);

          element.ApplyChanges();
        });
        putNewTiles();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        dv.log(" left");
        dir = Vector2(-1, 0);
        game.tileArray!.forEach((element) {
          element.shiftLeft2();
          element.ApplyChanges();
        });
        putNewTiles();
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        dv.log(" right");
        dir = Vector2(1, 0);
        int line = 1;
        game.tileArray!.forEach((element) {
          dv.log("line:${line++}");
          element.shiftRight2();
          element.ApplyChanges();
        });
        putNewTiles();
      }
      //   game.MyComponents[0].position += Matrix2(5, 0, 0, 5) * dir;
      //   game.MyComponents[0].loadFromTileList(game.MyImages);
      //  game.MyComponents[0].changeSizeAndPosition3(dir.x.toInt());
    }
    return KeyEventResult.ignored;
  }

  putNewTiles() {
    TileLine.PlaceNewTiles2(game.tileArray!);
    game.tileArray!.forEach((element) {
      element.ApplyChanges();
    });
  }

//   @override
//   void render(Canvas canvas) {
// / TO DO implement render

// //print("screen size x y ${screenCenterX} {$screenCenterY}");
//     //rectangles=[];
//     g.render(canvas);
//     MyComponents?.getRange(0, -1).forEach((element) {
//       element.onGameResize(size);
//     });
//   }

//   @override
//   void update(double dt) {
//     // ...
//   }
}
