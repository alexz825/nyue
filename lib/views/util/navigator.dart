import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/views/detail.dart';

class NavigatorUtil {
  NavigatorUtil();

  static void pushToDetail(BuildContext context, int bookId,
      {BaseBookModel book}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BookDetailPage(bookId);
    }));
  }
}
