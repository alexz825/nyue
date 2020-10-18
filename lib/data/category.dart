
const _ALL_CATEGORIES = {
  "gender": [
    {
      "type": "man",
      "name": "男"
    },
    {
      "type": "laydy",
      "name": "女"
    },
  ],
  "category": [
    {
      "type": "hot",
      "name": "最热"
    }, {
      "type": "commend",
      "name": "推荐"
    }, {
      "type": "over",
      "name": "完结"
    }, {
      "type": "collect",
      "name": "收藏"
    }, {
      "type": "new",
      "name": "新书"
    }, {
      "type": "vote",
      "name": "评分"
    }],
  "rank": [
    {
      "type": "week",
      "name": "周榜"
    }, {
      "type": "month",
      "name": "月榜"
    }, {
      "type": "total",
      "name": "总榜"
    },
  ]
};

class Category {
  Category({
    this.name,
    this.type,
  });

  final String name;
  final String type;

  static fromRawJson(Map<String, dynamic> str) => Category.fromJson(str);

  Map<String, dynamic> toRawJson() => toJson();

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    name: json["name"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
  };
}

class AllCategories {
  AllCategories({
    this.gender,
    this.category,
    this.rank
  });

  static AllCategories defaultData = AllCategories._fromRawJson(_ALL_CATEGORIES);

  final List<Category> gender;
  final List<Category> category;
  final List<Category> rank;

  static _fromRawJson(Map<String, dynamic> str) => AllCategories.fromJson(str);

  factory AllCategories.fromJson(Map<String, dynamic> json) => AllCategories(
    gender: json["gender"],
    category: json["category"],
    rank: json["rank"],
  );
}

