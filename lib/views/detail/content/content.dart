import 'dart:ui';

import 'package:flutter/material.dart';

enum _SinglePageStates { next, previous, no }

class _SinglePage extends StatefulWidget {
  _SinglePage({@required this.child, @required this.status, Key key})
      : super(key: key);
  Widget child;
  _SinglePageStates status;
  AnimationController _controller;
  ValueNotifier<double> panoffset = ValueNotifier<double>(0);
  @override
  State<StatefulWidget> createState() => _SinglePageState();
}

class _SinglePageState extends State<_SinglePage>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  double _panOffset;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      right: widget.panoffset.value * size.width,
      width: size.width,
      height: size.height,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    widget._controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 250), value: 0);
    _animation =
        CurvedAnimation(parent: widget._controller, curve: Curves.linear)
          ..addListener(() {});
  }
}

typedef WidgetGet = Widget Function(Widget current);

class PageContentWidget extends StatefulWidget {
  PageContentWidget(
      {@required this.initial,
      @required this.previous,
      @required this.next,
      Key key})
      : super(key: key);

  WidgetGet previous;
  WidgetGet next;
  Widget initial;

  @override
  State<StatefulWidget> createState() => PageContentWidgetState();
}

enum _ChapterScrollState { next, previous, no }

class PageContentWidgetState extends State<PageContentWidget> {
  _ChapterScrollState _scrollState = _ChapterScrollState.no;

  double _panOffset = 0;
  var _isDragging = false;
  int currentIndex;
  var _children = [
    Container(
      color: Colors.red,
      child: Center(
        child: Text("1"),
      ),
    ),
    Container(
      color: Colors.blue,
      child: Center(
        child: Text("2"),
      ),
    ),
    Container(
      color: Colors.green,
      child: Center(
        child: Text("3"),
      ),
    ),
  ];

  List<Widget> children = [];

  @override
  void initState() {
    currentIndex = 1;
    var previous = widget.previous(widget.initial);
    this.children = [
      previous != null
          ? _SinglePage(
              child: previous,
            )
          : null,
      _SinglePage(
        child: widget.initial,
      ),
      _SinglePage(
        child: widget.next(widget.initial),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanUpdate: (details) => this._onPanUpdate(details, size),
      onPanEnd: (details) => this._onPanEnd(details, size),
      child: Stack(
        children: this.children.reversed.toList(),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  /**
   * 根据滑动初始状态判断是上一页还是下一页
   */
  _ChapterScrollState getState(double panDelta) {
    if (panDelta == 0) {
      return _ChapterScrollState.no;
    } else if (panDelta < 0) {
      return _ChapterScrollState.next;
    } else if (panDelta > 0) {
      return _ChapterScrollState.previous;
    }
    return _ChapterScrollState.no;
  }

  void scrollToNextPage({double from}) {}

  void scrollToPreviousPage({double from}) {}

  /**
   * 手势滑动
   */
  void _onPanUpdate(DragUpdateDetails details, Size size) {
    var delta = (size.width - details.globalPosition.dx) / size.width;
    if (_isDragging) {
      setState(() {
        _panOffset = delta;
      });
      return;
    }
    _isDragging = true;
    _scrollState = this.getState(details.delta.dx);

    // if (_scrollState == _ChapterScrollState.next) {
    //   _controller.value = 0;
    //   _controller.animateTo(delta);
    // } else if (_scrollState == _ChapterScrollState.previous) {
    //   _controller.value = 1;
    //   _controller.animateBack(delta);
    // }
  }

  /**
   * 手势滑动结束
   */
  void _onPanEnd(DragEndDetails details, Size size) {
    _isDragging = false;
    bool isVelocity = details.velocity.pixelsPerSecond.dx.abs() > 0;

    // if (_scrollState == _ChapterScrollState.next) {
    //   if (_panOffset > 0.5 || isVelocity) {
    //     _controller.forward(from: _panOffset);
    //   } else {
    //     _controller.reverse(from: _panOffset);
    //   }
    // } else if (_scrollState == _ChapterScrollState.previous) {
    //   if (_panOffset < 0.5 || isVelocity) {
    //     _controller.reverse(from: _panOffset);
    //   } else {
    //     _controller.forward(from: _panOffset);
    //   }
    // }
  }
}
