//import 'dart:html';

import 'package:flame/components.dart';

import 'board.dart';
import "debug_conf.dart";
// import "package:flame/game.dart";
// import 'package:flame/input.dart';
// import 'package:flame/sprite.dart';

// import "dart:math";

// import "package:flame/game.dart";
// import 'package:flame/input.dart';
// import 'package:flame/sprite.dart';

// import "dart:math";

import 'dart:developer' as dv;

//import "board.dart";
import "dart:math";
import 'debug_conf.dart';

class TileLine {
  int col;
  List<TileData>? oldList;
  List<TileData>? newList;
  List<int>? freeTiles;
  // int pushindex = 0;
  TileLine({
    this.col = 0,
  }) {
    oldList = List.generate(col, (index) => TileData());
    newList = List.generate(col, (index) => TileData());
    freeTiles = List.generate(0, (index) => 0);
  }
  bool add(TileData tiledata) {
    //create a new tiledata with new reference.since it will only hold the new tileindex
    //after a change
    TileData tileD =
        TileData(tileIndex: tiledata.tileIndex, tileImage: tiledata.tileImage);

    newList!.add(tileD);
    oldList!.add(tiledata);
    return true;
  }

  static List<TileLine> getTransposeMatrix(List<TileLine> ls) {
    //create the new transposed list
    List<TileLine> lsOut = List.generate(
        ls[0].newList!.length, (index) => TileLine(col: ls.length));

    for (int index1 = 0; index1 < ls.length; index1++) {
      for (int index2 = 0; index2 < ls[0].newList!.length; index2++) {
        lsOut[index2].oldList![index1].tileIndex =
            ls[index1].oldList![index2].tileIndex;
      }
    }
    return lsOut;
  }

  refreshFreeTiles() {
    freeTiles!.clear();
    var index = 0;
    for (var element in oldList!) {
      if (element.tileIndex == 0) {
        freeTiles!.add(index);
      }
      index++;
    }
  }

  static int getTotalFree(List<TileLine> ls) {
    int total = 0;
    for (var element in ls) {
      element.refreshFreeTiles();
      total += element.freeTiles!.length;
    }

    return total;
  }

  static List<int> getAllFree(List<TileLine> ls) {
    var totalListofFree = List<int>.generate(0, (index) => 0);
    int indexRow = 0;
    for (var element in ls) {
      element.refreshFreeTiles();
      var sum = indexRow * element.oldList!.length; //index the tiles

      for (var arrayElement in element.freeTiles!) {
        totalListofFree.add(arrayElement + sum);
      }
      indexRow++;
    }
    return totalListofFree;
  }

  static bool placeNewTiles2(List<TileLine> ls, {int rndCount = 2}) {
    var totalFree = getAllFree(ls);
    if (totalFree.isEmpty) return false;
    if (totalFree.length == 1) {
      return true;
    }
    var rnd = Random();
    if (DebugConf.randomGeneration) {
      String total = "free tiles before: ";
      for (var element in totalFree) {
        total += "$element ";
      }

      dv.log(total);
    }

    int i = 0;
    while (i < 2) {
      int rndTileIndex = 3 * rnd.nextInt(100) +
          rnd.nextInt(100) +
          rnd.nextInt(100); //create random for placing index
      rndTileIndex %= totalFree.length;

      int tileNumber = totalFree[rndTileIndex];
      int col = tileNumber % ls.first.oldList!.length;
      int row = tileNumber ~/ ls.first.oldList!.length;

      ls[row].oldList![col].tileIndex = 1;
      totalFree.remove(tileNumber);
      if (totalFree.isEmpty) break;
      i++;
    }
    if (DebugConf.randomGeneration) {
      String total = "free tiles after: ";
      for (var element in totalFree) {
        total += "$element ";
      }
      dv.log(total);
    }
    return true;
  }

  void getLineTileValues(TileLine ls) {
    for (int index1 = 0; index1 < ls.oldList!.length; index1++) {
      oldList![index1].tileIndex = ls.oldList![index1].tileIndex;
    }
  }

  void shiftRight() {
    var solidIndex = -1; //index for no atraction point
    var activeIndex = -1; //index for atraction point
    newList?.forEach((element) {
      element.tileIndex = 0; //clear the new list
    });

    var index = 0;
    if (DebugConf.shiftLoop) {
      dv.log("shifting right");
    }
    while (index < oldList!.length) {
      if (activeIndex > -1 &&
          solidIndex != activeIndex &&
          newList![activeIndex].tileIndex != 0 &&
          newList![activeIndex].tileIndex == oldList![index].tileIndex) {
        if (DebugConf.shiftLoop) {
          dv.log("adding same ${oldList![index].tileIndex}");
        }
        newList![activeIndex].tileIndex += 1;
        solidIndex = activeIndex;
      } else if (oldList![index].tileIndex != 0 &&
          activeIndex < (oldList!.length - 1)) {
        if (DebugConf.shiftLoop) {
          dv.log("adding new ${oldList![index].tileIndex}");
        }
        activeIndex++;
        newList![activeIndex].tileIndex = oldList![index].tileIndex;

        solidIndex = activeIndex - 1;
      }
      index++;
    }
    if (DebugConf.shiftLoop) {
      dv.log(
          "newlist ${newList![0].tileIndex}  ${newList![1].tileIndex} ${newList![2].tileIndex} ${newList![3].tileIndex}");
    }
    //now we have two different arrays
    for (var element in oldList!) {
      element.tileIndex = 0;
    }
    index = oldList!.length - 1;
    while (activeIndex > -1) {
      oldList![index].tileIndex = newList![activeIndex].tileIndex;
      activeIndex--;
      index--;
    }
    if (DebugConf.shiftLoop) {
      dv.log(
          "final list ${oldList![0].tileIndex}  ${oldList![1].tileIndex} ${oldList![2].tileIndex} ${oldList![3].tileIndex}");
    }
  }

  void shiftLefth() {
    var solidIndex = oldList!.length; //index for no atraction point
    var activeIndex = oldList!.length; //index for atraction point
    newList?.forEach((element) {
      element.tileIndex = 0; //clear the new list
    });

    var index = oldList!.length - 1;
    if (DebugConf.shiftLoop) {
      dv.log("shifting left");
    }
    while (index > -1) {
      if (activeIndex < oldList!.length &&
          newList![activeIndex].tileIndex != 0 &&
          newList![activeIndex].tileIndex == oldList![index].tileIndex &&
          solidIndex != activeIndex) {
        if (DebugConf.shiftLoop) {
          dv.log("adding same ${oldList![index].tileIndex}");
        }
        newList![activeIndex].tileIndex += 1;
        solidIndex = activeIndex;
      } else if (oldList![index].tileIndex != 0 && activeIndex > 0) {
        if (DebugConf.shiftLoop) {
          dv.log("adding new ${oldList![index].tileIndex}");
        }
        activeIndex--;
        newList![activeIndex].tileIndex = oldList![index].tileIndex;

        solidIndex = activeIndex + 1;
      }

      index--;
    }
    if (DebugConf.shiftLoop) {
      dv.log(
          "newlist ${newList![0].tileIndex}  ${newList![1].tileIndex} ${newList![2].tileIndex} ${newList![3].tileIndex}");
    }
    //now we have two different arrays
    for (var element in oldList!) {
      element.tileIndex = 0;
    }
    index = 0;
    while (activeIndex < oldList!.length) {
      oldList![index].tileIndex = newList![activeIndex].tileIndex;
      activeIndex++;
      index++;
    }
    if (DebugConf.shiftLoop) {
      dv.log(
          "final list ${oldList![0].tileIndex}  ${oldList![1].tileIndex} ${oldList![2].tileIndex} ${oldList![3].tileIndex}");
    }
  }

  void applyChanges() {
    for (var element in oldList!) {
      element.tileImage!.changeSizeAndPosition(
          element.tileIndex, element.tileImage!.sprite!.srcSize);
    }
  }
}

class TileData {
  int tileIndex;
  bool shifted;

  Tile? tileImage;
  TileData({this.tileIndex = 0, this.shifted = false, this.tileImage});
  void clear() {
    tileIndex = 0;
    shifted = false;
  }
}
