import 'package:flutter/material.dart';
import 'package:nyue/network/api_list.dart';
import 'package:nyue/views/detail/bloc.dart';
import 'reader/page.dart';
import 'state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        children: [],
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
      body: _ChapterPageWidget(),
    );
  }

  @override
  void initState() {}
}
