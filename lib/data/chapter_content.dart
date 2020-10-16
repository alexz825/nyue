import 'dart:convert';
class ChapterContent {
  ChapterContent({
    this.content,
    this.id,
    this.name,
    this.v,
  });

  final String content;
  final double id;
  final String name;
  final int v;

  factory ChapterContent.fromRawJson(Map<String, dynamic> str) => ChapterContent.fromJson(str);

  String toRawJson() => json.encode(toJson());

  factory ChapterContent.fromJson(Map<String, dynamic> json) => ChapterContent(
    content: json["content"],
    id: json["id"].toDouble(),
    name: json["name"],
    v: json["v"],
  );

  Map<String, dynamic> toJson() => {
    "content": content,
    "id": id,
    "name": name,
    "v": v,
  };
}
