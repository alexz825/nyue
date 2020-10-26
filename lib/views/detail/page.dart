import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyue/views/detail/bloc.dart';
import 'package:nyue/views/detail/page_turn/page_turn.dart';

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

  var pages = [
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.green,
    )
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: pages,
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
    MultiBlocProvider(
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

    return BlocProvider<ChapterReaderBloc>(
        create: (context) {
          ChapterReaderBloc(
              ChapterReaderStateInitial(widget.bookId, widget.chapterId));
        },
        child: _content(context));
  }

  Widget _content(BuildContext context) {
    return Scaffold(
      body: PageTurn(
        builder: (context, index) {
          return Container(
            child: Center(
              child: Text("page  ${index}"),
            ),
          );
        },
        pageCount: 10,
        cutoff: 0.2,
        showDragCutoff: false,
        backgroundColor: Colors.white,
        initialIndex: 0,
        duration: Duration(milliseconds: 300),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
