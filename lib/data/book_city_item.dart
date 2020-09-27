
import 'dart:convert';

import 'package:nyue/data/book_list_item.dart';

class BookCityCardModel {
  BookCityCardModel({
    this.bookList,
    this.categoryName,
    this.type,
    this.categoryId = 0,
  });

  List<BookListItem> bookList;
  final String categoryName;
  final String type;
  final int categoryId;

  static fromRawJson(Map<String, dynamic> str) => BookCityCardModel.fromJson(str);

  String toRawJson() => json.encode(toJson());

  factory BookCityCardModel.fromJson(Map<String, dynamic> json) => BookCityCardModel(
    bookList: List<BookListItem>.from(json["bookList"].map((x) => BookListItem.fromJson(x))),
    categoryName: json["categoryName"],
    categoryId: json["categoryId"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "bookList": List<dynamic>.from(bookList.map((x) => x.toJson())),
    "categoryName": categoryName,
    "categoryId": categoryId,
    "type": type,
  };
}
