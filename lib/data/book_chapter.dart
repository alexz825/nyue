import 'dart:convert';

class BookDetailChapter {
  BookDetailChapter({
    this.chapterId,
    this.chapterName,
    this.chapterStatus,
    this.time,
  });

  final double chapterId;
  final String chapterName;
  final String chapterStatus;
  final int time;

  static fromRawJson(Map<String, dynamic> str) => BookDetailChapter.fromJson(str);

  String toRawJson() => json.encode(toJson());

  factory BookDetailChapter.fromJson(Map<String, dynamic> json) => BookDetailChapter(
    chapterId: json["chapterId"].toDouble(),
    chapterName: json["chapterName"],
    chapterStatus: json["chapterStatus"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "chapterId": chapterId,
    "chapterName": chapterName,
    "chapterStatus": chapterStatus,
    "time": time,
  };
}

class Chapter {
  Chapter({
    this.id,
    this.name,
    this.v,
  });

  final double id;
  final String name;
  final int v;

  factory Chapter.fromRawJson(Map<String, dynamic> str) => Chapter.fromJson(str);

  String toRawJson() => json.encode(toJson());

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json["id"].toDouble(),
    name: json["name"],
    v: json["v"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "v": v,
  };
}