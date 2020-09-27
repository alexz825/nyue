import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 刷新按钮icon,带动画
class AnimateRefreshIcon extends AnimatedWidget {
  AnimateRefreshIcon({AnimationController controller}) : super(listenable: Tween(begin: 0.0, end:360.0).animate(controller));
  // _AnimateRefreshIconState createState() => _AnimateRefreshIconState();
  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return Transform.rotate(angle: animation.value, child: Icon(Icons.refresh, size: 16, color: Colors.green,),);
  }
}