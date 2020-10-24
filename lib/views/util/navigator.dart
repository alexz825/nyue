import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/views/detail.dart';
import 'package:nyue/views/detail/page.dart';

class NavigatorUtil {
  NavigatorUtil();

  static void pushToDetail(BuildContext context, int bookId,
      {BaseBookModel book}) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return BookDetailPage(bookId);
    }));
  }

  static void pushsToReader(BuildContext context, int bookId, int chapterId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ChapterReader(bookId, chapterId);
    }));
  }
}
