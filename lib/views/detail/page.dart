import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyue/views/detail/bloc.dart';

import 'state.dart';

class _LayoutPropery {
  var contentHorizontalPadding = 15.0;
}

class _ChapterPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChapterPageWidgetState();
}

enum _ChapterScrollState { next, previous, no }

class _ChapterPageWidgetState extends State<_ChapterPageWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  _ChapterScrollState _scrollState = _ChapterScrollState.no;

  double _startOffset = 0;
  double _rightOffset = 0;
  var _isDragging = false;
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 250), value: 0);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear)
      ..addListener(() {
        setState(() {
          _rightOffset = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (_isDragging) {
          return;
        }
        print(status);
        if (status == AnimationStatus.completed) {
          _children.insert(_children.length - 1, _children.removeAt(0));
        }
        setState(() {});
      });
  }

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

  @override
  Widget build(BuildContext context) {
    var size = window.physicalSize / window.devicePixelRatio;
    return GestureDetector(
      onPanUpdate: (details) {
        var delta = (size.width - details.globalPosition.dx) / size.width;
        if (_isDragging) {
          setState(() {
            _rightOffset = delta;
          });
          return;
        }
        _isDragging = true;
        _scrollState =
            this.getState(details.globalPosition.dx - this._startOffset);
        _controller.animateTo(delta);
      },
      onPanStart: (details) {
        _startOffset = details.globalPosition.dx;
      },
      onPanDown: (details) {},
      onPanEnd: (details) {
        _isDragging = false;
        var delta = (size.width - _rightOffset) / size.width;
        if (delta > 0.5) {
          _controller.forward(from: delta);
        } else {
          _controller.reverse(from: delta);
        }
      },
      child: Stack(
        children: [
          Positioned(
              right: 0,
              width: size.width,
              height: size.height,
              child: _children[0]),
          Positioned(
              right: size.width *
                  ((this._scrollState == _ChapterScrollState.next
                      ? _rightOffset
                      : 0)),
              width: size.width,
              height: size.height,
              child: _children[1]),
          Positioned(
              right: size.width *
                  (1 -
                      (this._scrollState == _ChapterScrollState.previous
                          ? _rightOffset
                          : 0)),
              width: size.width,
              height: size.height,
              child: _children[2]),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ChapterReader extends StatefulWidget {
  int bookId;
  int chapterId;
  ChapterReader(this.bookId, this.chapterId, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChapterReaderState();
}

class _ChapterReaderState extends State<ChapterReader> {
  double currentPageValue = 0;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChapterReaderBloc>(
          // 章节内容
          create: (_) => ChapterReaderBloc(
              ChapterReaderStateInitial(widget.bookId, widget.chapterId)),
        ),
        BlocProvider<ChapterReaderSettingBloc>(
          // 阅读设置
          create: (_) => ChapterReaderSettingBloc(ChapterReaderSettingState()),
        )
      ],
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    // context.bloc<ChapterReaderBloc>();
    return Scaffold(body: Container(child: _ChapterPageWidget()));
  }

  @override
  void initState() {
    super.initState();
  }
}
