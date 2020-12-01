import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyue/views/detail/bloc.dart';
import 'state.dart';
import 'content/reader.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class _LayoutPropery {
  var contentHorizontalPadding = 15.0;
}

class ChapterReader extends StatefulWidget {
  final int bookId;
  final int chapterId;
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

    return Scaffold(
        body: SizedBox.expand(
            child: Container(
                child: ReaderPageView(
      initial: Container(
        key: ValueKey<int>(1),
        color: Colors.white,
        child: Center(
          child: Text("1"),
        ),
      ),
      next: (Widget w) {
        var key = w.key as ValueKey<int>;
        print("next, and input Key: ${key.value}, outputKey: ${key.value + 1}");
        return Container(
          key: ValueKey<int>(key.value + 1),
          color: Colors.white,
          child: Center(
            child: Text("${key.value + 1}"),
          ),
        );
      },
      previous: (Widget w) {
        var key = w.key as ValueKey<int>;
        if (key == null || key.value == 0) {
          return null;
        }
        print("previous, and Key: ${key.value}, outputKey: ${key.value - 1}");
        return Container(
          key: ValueKey<int>(key.value - 1),
          color: Colors.white,
          child: Center(
            child: Text("${key.value - 1}"),
          ),
        );
      },
    ))));
  }

  @override
  void initState() {
    super.initState();
  }
}
