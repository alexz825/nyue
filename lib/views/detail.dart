import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/network/api_list.dart';
import 'package:nyue/util/theme_manager.dart';
import 'package:nyue/views/uikit/NetworkImg.dart';

class _LayoutProperty {
  static var ListViewPadding = EdgeInsets.fromLTRB(15, 10, 15, 10);
  // static var BookInfoPadding = EdgeInsets.fromLTRB(0, 10, 0, 0);
  static var BookInfoDescPadding = EdgeInsets.fromLTRB(15, 0, 15, 0);
  static var bottomHeight = 50.0;
}

abstract class BookDetailState {}

class BookDetailStateLoading implements BookDetailState {}

class BookDetailStateSuccess implements BookDetailState {
  @override
  BookModel book;

  BookDetailStateSuccess(this.book);
}

class BookDetailBloc extends Cubit<BookDetailState> {
  BookDetailBloc(BookDetailState state) : super(state);

  Future request(int bookId) {
    return HttpUtil.getBookDetail(bookId).then((value) {
      emit(BookDetailStateSuccess(value));
    });
  }
}

class BookDetailPage extends StatelessWidget {
  int bookId;
  BookDetailPage(@required this.bookId, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("书籍详情"),
        ),
        body: BlocProvider<BookDetailBloc>(create: (_) {
          var bloc = BookDetailBloc(BookDetailStateLoading());
          bloc.request(this.bookId);
          return bloc;
        }, child: BlocBuilder<BookDetailBloc, BookDetailState>(
          builder: (context, state) {
            if (state is BookDetailStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return contentScrollView(context, state);
          },
        )));
  }

  Widget contentScrollView(BuildContext context, BookDetailStateSuccess state) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(child: ListView(children: [bookInfoView(state.book)])),
        Container(
          height: _LayoutProperty.bottomHeight +
              MediaQuery.of(context).padding.bottom,
          color: Colors.black,
          child: Flex(
            direction: Axis.horizontal,
          ),
        )
      ],
    );
  }

  Widget bookInfoView(BookModel book) {
    return Column(
      children: [
        Container(
          margin: _LayoutProperty.ListViewPadding,
          child: Container(
            height: 130,
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10),
                  child: AspectRatio(
                    aspectRatio: 0.75,
                    child: NetworkImg(book.img),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 5,
                  direction: Axis.vertical,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        book.name,
                        style: ZTheme.titleStyle,
                      ),
                    ),
                    Text(
                      "作者：" + book.author,
                      style: ZTheme.subTitleStyle,
                    ),
                    Text(
                      "分类：" + book.cName,
                      style: ZTheme.subTitleStyle,
                    ),
                    Text("状态：" + book.bookStatus, style: ZTheme.subTitleStyle),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          margin: _LayoutProperty.BookInfoDescPadding,
          child: Text(
            book.desc,
            style: ZTheme.descStyle,
          ),
        ),
      ],
    );
  }
}
