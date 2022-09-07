import "package:flutter/material.dart";
import "dart:math";
import "package:flame/components.dart";

class Constants {
  static Map<TargetPlatform, Constant> constants = {
    TargetPlatform.android: Constant.Android(),
    TargetPlatform.windows: Constant.Windows(),
  };
  static Map<MatrixFormat, Dimensions> MatrixConstants = {
    MatrixFormat.map4x4:
        Dimensions(matrix: Vector2(4, 4), scale: Vector2(0.5, 0.5)),
    MatrixFormat.map5x5:
        Dimensions(matrix: Vector2(5, 5), scale: Vector2(0.375, 0.375)),
    MatrixFormat.map6x6:
        Dimensions(matrix: Vector2(6, 6), scale: Vector2(0.35, 0.35)),
  };
}

class Constant {
  var scale = Vector2(0.5, 0.5);
  var start = Vector2.all(0);

  Constant.Android() {
    scale = Vector2(0.8, 0.8);
    start = Vector2(50, 20);
  }
  Constant.Windows() {
    scale = Vector2(2,2);
    start = Vector2(50, 20);
  }
}

enum MatrixFormat { map4x4, map5x5, map6x6 }

class Dimensions {
  Vector2 matrix;
  Vector2 scale;
  Dimensions({required this.matrix, required this.scale});
}
