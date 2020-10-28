import 'package:flutter/material.dart';

abstract class BasePageAnimation {
  void draw(Canvas canvas);
}

class PageAnimationHelper {
  Offset currentTouchOffset;

  BasePageAnimation animation;

  PageAnimationHelper(this.currentTouchOffset, BasePageAnimation animation);

  Canvas draw(Canvas canvas) {
    return canvas;
  }
}
