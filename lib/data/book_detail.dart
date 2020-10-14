import 'dart:convert';
import 'package:nyue/data/util.dart';

import 'book_list_item.dart';
import 'book_chapter.dart';

class BookDetail {

  BookDetail({
    this.author,
    this.bookId,
    this.categoryName,
    this.chapterNum,
    this.coverImg,
    this.desc,
    this.recommend,
    this.title,
    this.update,
    this.word,
  });

  final String author;
  final int bookId;
  final String categoryName;
  final int chapterNum;
  final String coverImg;
  final String desc;
  final List<BookListItem> recommend;
  final String title;
  final BookChapter update;
  final String word;

  static fromRawJson(Map<String, dynamic> str) => BookDetail.fromJson(str);

  String toRawJson() => json.encode(toJson());

  factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
    author: json["author"],
    bookId: json["bookId"],
    categoryName: json["categoryName"],
    chapterNum: json["chapterNum"],
    coverImg: HTTP_IMAGE_ENDPOINT + json["coverImg"],
    desc: json["desc"],
    recommend: List<BookListItem>.from(json["recommend"].map((x) => BookListItem.fromJson(x))),
    title: json["title"],
    update: BookChapter.fromJson(json["update"]),
    word: json["word"],
  );

  Map<String, dynamic> toJson() => {
    "author": author,
    "bookId": bookId,
    "categoryName": categoryName,
    "chapterNum": chapterNum,
    "coverImg": coverImg.replaceAll(HTTP_IMAGE_ENDPOINT, ""),
    "desc": desc,
    "recommend": List<dynamic>.from(recommend.map((x) => x.toJson())),
    "title": title,
    "update": update.toJson(),
    "word": word,
  };
}