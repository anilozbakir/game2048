import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import 'board.dart';

import 'dart:developer' as dv;
import "dart:ui" as d;
import "dart:math";

class MoveBuffer {
  List<Move> moves = <Move>[];
}

class Move {
  List<int> indexes = <int>[];
}
