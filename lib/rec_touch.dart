import "dart:ui";

class RectTouch {
  Rect R;
  bool touch = false;
  int x;
  int y;
  RectTouch(this.R, this.x, this.y, {this.touch = false});
}
