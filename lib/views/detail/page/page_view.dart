import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'painter.dart';

typedef PageContentWidgetBuilder = Widget Function(BuildContext context, Widget widget);


// 动画：层叠 curl 平滑

class PageView extends StatefulWidget {

  PageView({this.initialWidget, this.previousBuilder, this.nextBuilder, this.size, Key key}) : super(key: key);
  
  final Size size;
  final PageContentWidgetBuilder previousBuilder;
  final PageContentWidgetBuilder nextBuilder;
  final Widget initialWidget;

  @override
  State<StatefulWidget> createState() => _PageViewState();
}

class _PageViewState extends State<PageView> {
  PageContentPainter _painter;
  AnimationController _animationController;
  _PageViewState();

  GlobalKey firstCanvasKey = GlobalKey();
  GlobalKey secondCanvasKey = GlobalKey();
  GlobalKey thirdCanvasKey = GlobalKey();

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_painter == null) {
      return Container(
        child: Center(
          child: Text("无内容"),
        ),
      );
    }

    var _size = MediaQuery.of(context).size;

    Widget currentWidget;

    return GestureDetector(
      onPanEnd: (dimensions) {
        // RenderRepaintBoundary
        final boundary = firstCanvasKey.currentContext.findRenderObject() as RenderRepaintBoundary;
        
      },
        child: Stack(
      children: [
        RepaintBoundary(
          key: firstCanvasKey,
          child: widget.previousBuilder(context, widget.initialWidget),
        ),
        RepaintBoundary(
          key: secondCanvasKey,
          child: currentWidget ?? widget.initialWidget
        ),
        RepaintBoundary(
          key: thirdCanvasKey,
          child: widget.previousBuilder(context, widget.initialWidget),
        ),
      ],
    ));
  }

  Widget prevoisPage() {
    return widget.
  }

  @override
  void initState() {
    super.initState();
    // TODO: 通过修改_painter来解决内容问题
  }
}
