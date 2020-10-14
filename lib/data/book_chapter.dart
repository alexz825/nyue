import 'dart:convert';

class BookChapter {
  BookChapter({
    this.chapterId,
    this.chapterName,
    this.chapterStatus,
    this.time,
  });

  final double chapterId;
  final String chapterName;
  final String chapterStatus;
  final int time;

  static fromRawJson(Map<String, dynamic> str) => BookChapter.fromJson(str);

  String toRawJson() => json.encode(toJson());

  factory BookChapter.fromJson(Map<String, dynamic> json) => BookChapter(
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