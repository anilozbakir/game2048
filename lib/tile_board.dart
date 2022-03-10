//import 'dart:html';

import 'package:flame/components.dart';

import 'board.dart';

// import "package:flame/game.dart";
// import 'package:flame/input.dart';
// import 'package:flame/sprite.dart';

// import "dart:math";

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'board.dart';

// import "package:flame/game.dart";
// import 'package:flame/input.dart';
// import 'package:flame/sprite.dart';

// import "dart:math";

import 'dart:developer' as dv;
import 'rec_touch.dart';
import "dart:ui" as d;
import 'dart:developer';
import "board.dart";

// enum TileSet{
//   TILE_0,
//   TILE_2,
//   TILE_4,
//   TILE_8,
//   TILE_16,
//   TILE_32,
//   TILE_64,
//   TILE_128,
//   TILE_256,
//   TILE_512,
//   TILE_1024,
//   TILE_2048,
// }
class TileLine {
  int col;
  List<TileData>? oldList;
  List<TileData>? newList;
  List<int>? FreeTiles;
  // int pushindex = 0;
  TileLine({
    this.col = 0,
  }) {
    oldList = List.generate(col, (index) => new TileData());
    newList = List.generate(col, (index) => new TileData());
    FreeTiles = List.generate(0, (index) => 0);
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

  static List<TileLine> GetTransposeMatrix(List<TileLine> ls) {
    //create the new transposed list
    List<TileLine> lsOut = List.generate(
        ls[0].newList!.length, (index) => new TileLine(col: ls.length));

    for (int index1 = 0; index1 < ls.length; index1++) {
      for (int index2 = 0; index2 < ls[0].newList!.length; index2++) {
        lsOut[index2].oldList![index1].tileIndex =
            ls[index1].oldList![index2].tileIndex;
      }
    }
    return lsOut;
  }

  static bool PlaceNewTiles(List<TileLine> ls) {
    return true;
  }

  void GetLineTileValues(TileLine ls) {
    for (int index1 = 0; index1 < ls.oldList!.length; index1++) {
      oldList![index1].tileIndex = ls.oldList![index1].tileIndex;
    }
  }

  /// shift the line of tiles to right using the backup list
  /// then save
  void ShiftRight() {
    newList?.forEach((element) {
      element.clear(); //clear the new list
    });
    int len = oldList?.length ?? 0;
    if (len == 0) return;

    int newIndex = len - 1;
    newList?[len - 1].tileIndex = oldList![len - 1].tileIndex;
    for (int index = len - 2; index >= 0; index--) {
      if (newList![newIndex].tileIndex == 0) {
        //the previous one has empty tile
        newList?[newIndex].tileIndex = oldList![index].tileIndex;
        dv.log("previous was zero");
        continue;
      }
      bool shifted = newList?[newIndex].shifted ?? true;
      if (!shifted &&
          newList?[newIndex].tileIndex == oldList![index].tileIndex) {
        int indx = newList![newIndex].tileIndex;
        dv.log("new shift $newIndex $index $indx]");
        newList?[newIndex]
            .tileIndex++; //double the value ;since in our image increasing the
        //index means doubling the tile value.
        newIndex--;
        newList?[newIndex].shifted = true;
      } else {
        //there is a new element place it.
        newIndex--;
        int indx = newList![newIndex].tileIndex;
        dv.log("new element $newIndex $index $indx]");
        newList?[newIndex].tileIndex = oldList![index].tileIndex;
      }
    }
    FreeTiles!.clear();
    for (int i = 0; i < oldList!.length; i++) {
      oldList![i].tileIndex = newList![i].tileIndex;
      if (newList![i].tileIndex == 0) {
        FreeTiles!.add(i);
      }
    }
  }

  void ShiftLeft() {
    newList?.forEach((element) {
      element.clear(); //clear the new list
    });
    int len = oldList?.length ?? 0;
    if (len == 0) return;

    int newIndex = 0;
    newList?[0].tileIndex = oldList![0].tileIndex;
    for (int index = 1; index < len; index++) {
      if (newList![newIndex].tileIndex == 0) {
        //the previous one has empty tile
        newList?[newIndex].tileIndex = oldList![index].tileIndex;
        dv.log("previous was zero");
        continue;
      }
      bool shifted = newList?[newIndex].shifted ?? true;
      if (!shifted &&
          newList?[newIndex].tileIndex == oldList![index].tileIndex) {
        int indx = newList![newIndex].tileIndex;
        dv.log("new shift $newIndex $index $indx]");
        newList?[newIndex]
            .tileIndex++; //double the value ;since in our image increasing the
        //index means doubling the tile value.
        newIndex++;
        newList?[newIndex].shifted = true;
      } else {
        //there is a new element place it.
        newIndex++;
        int indx = newList![newIndex].tileIndex;
        dv.log("new element $newIndex $index $indx]");
        newList?[newIndex].tileIndex = oldList![index].tileIndex;
      }
    }
    for (int i = 0; i < oldList!.length; i++)
      oldList![i].tileIndex = newList![i].tileIndex;
  }

  void ApplyChanges() {
    oldList!.forEach((element) {
      element.tileImage!.changeSizeAndPosition(
          element.tileIndex, element.tileImage!.sprite!.srcSize);
    });
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
