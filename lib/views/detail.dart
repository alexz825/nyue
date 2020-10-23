import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/network/api_list.dart';
import 'package:nyue/views/uikit/NetworkImg.dart';

class _LayoutProperty {
  static var ListViewPadding = EdgeInsets.fromLTRB(10, 10, 10, 10);
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
            return contentScrollView(state);
          },
        )));
  }

  Widget contentScrollView(BookDetailStateSuccess state) {
    return Container(
      padding: EdgeInsets.lef,
        child: ListView(
      children: [bookInfoView(state.book)],
    ));
  }

  Widget bookInfoView(BookModel book) {
    return Stack(
      children: [
        Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              margin: ,
              child: AspectRatio(
                aspectRatio: 0.75,
                child: NetworkImg(book.img),
              ),
              height: 100,
            ),
            Flex(
              direction: Axis.vertical,
              children: [
                Text(book.name),
                Text(book.author),
                Text("状态：" + book.bookStatus)
              ],
            ),
          ],
        )
      ],
    );
  }
}
