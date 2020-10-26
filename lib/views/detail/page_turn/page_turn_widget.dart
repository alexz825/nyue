import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nyue/views/detail/page_turn/curl_effect.dart';

class PageTurnWidget extends StatefulWidget {
  const PageTurnWidget(
      {Key key,
      this.amount,
      this.backgroundColor = const Color(0xffffffcc),
      this.child})
      : super(key: key);

  final Animation<double> amount;
  final Color backgroundColor;
  final Widget child;

  @override
  State<StatefulWidget> createState() => _PageTurnWidgetState();
}

class _PageTurnWidgetState extends State<PageTurnWidget> {
  final _boundaryKey = GlobalKey();
  ui.Image _image;

  @override
  void didUpdateWidget(PageTurnWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child) {
      _image = null;
    }
  }

  void _captureImage(Duration timestamp) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary =
        _boundaryKey.currentContext.findRenderObject() as RenderRepaintBoundary;

    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 20));
      return _captureImage(timestamp);
    }

    final image = await await boundary.toImage(pixelRatio: pixelRatio);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return CustomPaint(
        painter: PageTurnCurlEffect(
            amount: widget.amount,
            image: _image,
            backgroundColor: widget.backgroundColor),
        size: Size.infinite,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback(_captureImage);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final size = constraints.biggest;
        return Stack(
          overflow: Overflow.clip,
          children: [
            Positioned(
              left: 1 + size.width,
              top: 1 + size.height,
              width: size.width,
              height: size.height,
              child: RepaintBoundary(
                key: _boundaryKey,
                child: widget.child,
              ),
            )
          ],
        );
      },
    );
  }
}
