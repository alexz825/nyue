
import 'dart:convert';

class BaseBookModel {
  BaseBookModel({
    this.id,
    this.name,
    this.author,
    this.img,
    this.desc,
    this.cName,
    this.score,
    this.lastChapter,
    this.lastChapterId
  });

  final int id;
  final String name;
  final double score;
  final String img;

  final String author;
  final String desc;
  final String cName;

  final int lastChapterId;
  final String lastChapter;

  factory BaseBookModel.fromJson(String str) => BaseBookModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BaseBookModel.fromMap(Map<String, dynamic> json) => BaseBookModel(
    id: json["Id"],
    name: json["Name"],
    img: json["Img"],
    score: json["Score"].toDouble(),
    desc: json["Desc"] == null ? "" : json["Desc"],
    author: json["Author"] == null ? "" : json["Author"],
    cName: json["CName"] == null ? "" : json["CName"],
    lastChapter: json["LastChapter"] == null ? "" : json["LastChapter"],
    lastChapterId: json["LastChapterId"] == null ? 0 : json["LastChapterId"],
  );

  Map<String, dynamic> toMap() => {
    "Id": id,
    "Name": name,
    "Author": author,
    "Img": img,
    "Desc": desc,
    "CName": cName,
    "Score": score,
    "LastChapterId": lastChapterId,
    "lastChapter": lastChapter
  };
}

class BookModel extends BaseBookModel {
  BookModel({
    int id,
    String name,
    String img,
    String author,
    String desc,
    String cName,
    String lastChapter,
    int lastChapterId,

    this.cId,
    this.lastTime,
    this.firstChapterId,
    this.bookStatus,
    this.sameUserBooks,
    this.sameCategoryBooks,
    this.bookVote,
  }) : super(id: id, name: name, author: author, desc: desc, cName: cName, score: bookVote.score, img: img);

  final int cId;
  final String lastTime;
  final int firstChapterId;
  final String bookStatus;
  final List<BaseBookModel> sameUserBooks;
  final List<BaseBookModel> sameCategoryBooks;
  final BookVote bookVote;

  factory BookModel.fromJson(String str) => BookModel.fromMap(json.decode(str));

  @override
  String toJson() {
    return json.encode(toMap()) + super.toJson();
  }

  factory BookModel.fromMap(Map<String, dynamic> json) => BookModel(
    id: json["Id"],
    name: json["Name"],
    img: json["Img"],
    author: json["Author"],
    desc: json["Desc"],
    cId: json["CId"],
    cName: json["CName"],
    lastTime: json["LastTime"],
    firstChapterId: json["FirstChapterId"],
    lastChapter: json["LastChapter"],
    lastChapterId: json["LastChapterId"],
    bookStatus: json["BookStatus"],
    sameUserBooks: List<BaseBookModel>.from(json["SameUserBooks"].map((x) => BaseBookModel.fromMap(x))),
    sameCategoryBooks: List<BaseBookModel>.from(json["SameCategoryBooks"].map((x) => BaseBookModel.fromMap(x))),
    bookVote: BookVote.fromMap(json["BookVote"]),
  );

  Map<String, dynamic> toMap() => {
    "Id": id,
    "Name": name,
    "Img": img,
    "Author": author,
    "Desc": desc,
    "CId": cId,
    "CName": cName,
    "LastTime": lastTime,
    "FirstChapterId": firstChapterId,
    "LastChapter": lastChapter,
    "LastChapterId": lastChapterId,
    "BookStatus": bookStatus,
    "SameUserBooks": List<dynamic>.from(sameUserBooks.map((x) => x.toMap())),
    "SameCategoryBooks": List<dynamic>.from(sameCategoryBooks.map((x) => x.toMap())),
    "BookVote": bookVote.toMap(),
  };
}

class BookVote {
  BookVote({
    this.bookId,
    this.totalScore,
    this.voterCount,
    this.score,
  });

  final int bookId;
  final int totalScore;
  final int voterCount;
  final double score;

  factory BookVote.fromJson(String str) => BookVote.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BookVote.fromMap(Map<String, dynamic> json) => BookVote(
    bookId: json["BookId"],
    totalScore: json["TotalScore"],
    voterCount: json["VoterCount"],
    score: json["Score"].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    "BookId": bookId,
    "TotalScore": totalScore,
    "VoterCount": voterCount,
    "Score": score,
  };
}



