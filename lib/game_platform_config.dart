import "package:flutter/material.dart";
import "dart:math";
import "package:flame/components.dart";

class Constants {
  static Map<TargetPlatform, Constant> constants = {
    TargetPlatform.android: Constant.Android(),
    TargetPlatform.windows: Constant.Windows(),
  };
}

class Constant {
  var scale = Vector2(0.5, 0.5);
  Constant.Android() {
    scale = Vector2(0.5, 0.5);
  }
  Constant.Windows() {
    scale = Vector2(0.75, 0.75);
  }
}

enum MatrixFormat { map4x4, map5x7, map9x9 }

Map<MatrixFormat, Dimensions> MatrixConstants = {
  MatrixFormat.map4x4:
      Dimensions(matrix: Vector2(4, 4), scale: Vector2(0.5, 0.5)),
  MatrixFormat.map5x7:
      Dimensions(matrix: Vector2(5, 7), scale: Vector2(0.5, 0.5)),
  MatrixFormat.map9x9:
      Dimensions(matrix: Vector2(9, 9), scale: Vector2(0.5, 0.5)),
};

class Dimensions {
  Vector2 matrix;
  Vector2 scale;
  Dimensions({required this.matrix, required this.scale});
}
