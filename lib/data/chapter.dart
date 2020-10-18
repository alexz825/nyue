import 'dart:convert';

class ChapterContent {
  ChapterContent({
    this.id,
    this.name,
    this.cid,
    this.cname,
    this.pid,
    this.nid,
    this.content,
    this.hasContent,
  });

  final int id;
  final String name;
  final int cid;
  final String cname;
  final int pid;
  final int nid;
  final String content;
  final int hasContent;

  factory ChapterContent.fromJson(String str) => ChapterContent.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChapterContent.fromMap(Map<String, dynamic> json) => ChapterContent(
    id: json["id"],
    name: json["name"],
    cid: json["cid"],
    cname: json["cname"],
    pid: json["pid"],
    nid: json["nid"],
    content: json["content"],
    hasContent: json["hasContent"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "cid": cid,
    "cname": cname,
    "pid": pid,
    "nid": nid,
    "content": content,
    "hasContent": hasContent,
  };
}

class Chapter {
  Chapter({
    this.id,
    this.name,
    this.hasContent,
  });

  final int id;
  final String name;
  final bool hasContent;

  factory Chapter.fromJson(String str) => Chapter.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Chapter.fromMap(Map<String, dynamic> json) => Chapter(
    id: json["id"],
    name: json["name"],
    hasContent: json["hasContent"] == 1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "hasContent": hasContent,
  };
}

/**
 * 卷
 */
class ChapterWrapper {
  ChapterWrapper({
    this.id,
    this.name,
    this.list,
  });

  final int id;
  final String name;
  final List<Chapter> list;

  factory ChapterWrapper.fromJson(String str) => ChapterWrapper.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ChapterWrapper.fromMap(Map<String, dynamic> json) => ChapterWrapper(
    id: json["id"],
    name: json["name"],
    list: List<Chapter>.from(json["list"].map((x) => Chapter.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "list": List<dynamic>.from(list.map((x) => x.toMap())),
  };
}
