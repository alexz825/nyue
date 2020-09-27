import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'util.dart';
class BookListItem {
  BookListItem({
    this.author,
    this.bookId,
    this.categoryName,
    this.chapterStatus,
    this.coverImg,
    this.desc,
    this.title,
    this.word,
  });

  final String author;
  final int bookId;
  final String categoryName;
  final String chapterStatus;
  final String coverImg;
  final String desc;
  final String title;
  final String word;


  static fromRawJson(Map<String, dynamic> str) => BookListItem.fromJson(str);

  String toRawJson() => json.encode(toJson());

  factory BookListItem.fromJson(Map<String, dynamic> json) => BookListItem(
    author: json["author"],
    bookId: json["bookId"],
    categoryName: json["categoryName"],
    chapterStatus: json["chapterStatus"],
    coverImg: HTTP_IMAGE_ENDPOINT + json["coverImg"],
    desc: json["desc"],
    title: json["title"],
    word: json["word"],
  );

  Map<String, dynamic> toJson() => {
    "author": author,
    "bookId": bookId,
    "categoryName": categoryName,
    "chapterStatus": chapterStatus,
    "coverImg": coverImg,
    "desc": desc,
    "title": title,
    "word": word,
  };
}
