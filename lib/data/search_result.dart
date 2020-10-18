import 'dart:convert';

class SearchResultItem {
  SearchResultItem({
    this.id,
    this.name,
    this.author,
    this.img,
    this.desc,
    this.bookStatus,
    this.lastChapterId,
    this.lastChapter,
    this.cName,
    this.updateTime,
  });

  final String id;
  final String name;
  final String author;
  final String img;
  final String desc;
  final String bookStatus;
  final String lastChapterId;
  final String lastChapter;
  final String cName;
  final DateTime updateTime;

  factory SearchResultItem.fromJson(String str) => SearchResultItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchResultItem.fromMap(Map<String, dynamic> json) => SearchResultItem(
    id: json["Id"],
    name: json["Name"],
    author: json["Author"],
    img: json["Img"],
    desc: json["Desc"],
    bookStatus: json["BookStatus"],
    lastChapterId: json["LastChapterId"],
    lastChapter: json["LastChapter"],
    cName: json["CName"],
    updateTime: DateTime.parse(json["UpdateTime"]),
  );

  Map<String, dynamic> toMap() => {
    "Id": id,
    "Name": name,
    "Author": author,
    "Img": img,
    "Desc": desc,
    "BookStatus": bookStatus,
    "LastChapterId": lastChapterId,
    "LastChapter": lastChapter,
    "CName": cName,
    "UpdateTime": updateTime.toIso8601String(),
  };
}