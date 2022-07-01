import 'dart:ffi';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import "../../game_platform_config.dart";
import 'dart:convert';

class GameData {
  static Map<MatrixFormat, GameParameters> data =
      Map<MatrixFormat, GameParameters>();
}

class GameParameters {
 
  MatrixFormat format = MatrixFormat.map4x4;
  int highScore = 0;
  DateTime lastLogin = DateTime.now();
  String lastGame = "";
  Uint8List get decodeGame {
    return base64Decode(lastGame);
  }

  set encodeGame(Uint8List list) {
    lastGame = base64Encode(list);
  }

  GameParameters.temp();

  GameParameters(
      {required this.format, required this.lastGame  }) {}
  GameParameters.fromMap(Map<String, dynamic> map)
      : format = MatrixFormat.values[map["format"]],
        highScore = map["highScore"],
        lastLogin = DateTime.parse(map["lastLogin"]),
        lastGame = map["lastGame"];

  // String   lastGame {
  //   return base64Decode(lastGame);

  //}
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
   // map["id"] = id;
    map["format"] = format;
    map["highScore"] = highScore;
    map["lastLogin"] = DateTime.now().toIso8601String();
    map["lastGame"] = decodeGame;
    return map;
  }
}
