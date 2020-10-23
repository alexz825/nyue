import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/network/api_list.dart';

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
      child: Center(
        child: Text(state.book.desc.toString()),
      ),
    );
  }
}
