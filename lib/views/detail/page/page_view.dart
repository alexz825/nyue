import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nyue/views/detail/page_turn/curl_effect.dart';

import 'painter.dart';

typedef PageContentWidgetBuilder = Widget Function(
    BuildContext context, Widget widget);

// 动画：层叠 curl 平滑

class CustomPageView extends StatefulWidget {
  CustomPageView(
      {this.initialWidget,
      this.previousBuilder,
      this.nextBuilder,
      this.size,
      Key key})
      : super(key: key);

  final Size size;
  final PageContentWidgetBuilder previousBuilder;
  final PageContentWidgetBuilder nextBuilder;
  final Widget initialWidget;

  @override
  State<StatefulWidget> createState() => _PageViewState();
}

class _PageViewState extends State<CustomPageView> {
  PageContentPainter _painter;
  AnimationController _animationController;
  _PageViewState();

  GlobalKey firstCanvasKey = GlobalKey();
  GlobalKey secondCanvasKey = GlobalKey();
  GlobalKey thirdCanvasKey = GlobalKey();
  Widget currentWidget;

  Map<int, ui.Image> _images = {};

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _captureImage(Duration timestamp) async {
    RenderRepaintBoundary first = firstCanvasKey.currentContext
        .findRenderObject() as RenderRepaintBoundary;
    RenderRepaintBoundary second = secondCanvasKey.currentContext
        .findRenderObject() as RenderRepaintBoundary;
    RenderRepaintBoundary third = thirdCanvasKey.currentContext
        .findRenderObject() as RenderRepaintBoundary;

    if (first.debugNeedsPaint ||
        second.debugNeedsPaint ||
        third.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 20));
      return _captureImage(timestamp);
    }

    first.toImage().then((value) {
      this._images[0] = value;
    });

    second.toImage().then((value) {
      this._images[1] = value;
    });

    third.toImage().then((value) {
      this._images[2] = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback(_captureImage);
    return GestureDetector(
        onPanEnd: (dimensions) {
          final boundary = firstCanvasKey.currentContext.findRenderObject()
              as RenderRepaintBoundary;
          // boundary.toImage();
          Canvas canvas;
        },
        child: Stack(
          children: [
            this._images[0]
                ? CustomPaint(
                    painter: PageTurnCurlEffect(
                        amount: 0.3,
                        image: this._images[0],
                        backgroundColor: Colors.white),
                    size: Size.infinite,
                  )
                : RepaintBoundary(
                    key: firstCanvasKey,
                    child:
                        widget.previousBuilder(context, widget.initialWidget),
                  ),
            this._images[1] ??
                RepaintBoundary(
                    key: secondCanvasKey,
                    child: currentWidget ?? widget.initialWidget),
            this._images[2] ??
                RepaintBoundary(
                  key: thirdCanvasKey,
                  child: widget.previousBuilder(context, widget.initialWidget),
                ),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    // TODO: 通过修改_painter来解决内容问题
  }
}

class PageViewPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
