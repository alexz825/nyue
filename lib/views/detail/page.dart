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

class _ChapterPageWidgetState extends State<_ChapterPageWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double panOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    // var size = context.size;
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          panOffset = details.delta.dx;
        });
      },
      child: Stack(
        children: [
          Positioned(
            right: panOffset,
            child: Container(
              color: Colors.red,
            ),
          ),
          Positioned(
            right: panOffset,
            child: Container(
              color: Colors.blue,
            ),
          ),
          Positioned(
            right: panOffset,
            child: Container(
              color: Colors.green,
            ),
          ),
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
