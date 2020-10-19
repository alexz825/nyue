const _ALL_CATEGORIES = {
  "gender": [
    {
      "type": "man",
      "name": "男"
    },
    {
      "type": "lady",
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

  static List<List<Category>> defaultData() {
    var cate = AllCategories.fromJson(_ALL_CATEGORIES);
    return [cate.gender, cate.category, cate.rank];
  }

  static AllCategories all() => AllCategories.fromJson(_ALL_CATEGORIES);

  final List<Category> gender;
  final List<Category> category;
  final List<Category> rank;

  factory AllCategories.fromJson(Map<String, dynamic> json) {
    return AllCategories(
      gender: List<Category>.from(json["gender"].map((e) => Category.fromJson(e))),
      category: List<Category>.from(json["category"].map((e) => Category.fromJson(e))),
      rank: List<Category>.from(json["rank"].map((e) => Category.fromJson(e))),
    );
  }
}

class SelectedCategoryItem {
  String gender;
  String category;
  String rank;
  SelectedCategoryItem(this.gender, this.category, this.rank);
  static SelectedCategoryItem defaultItem = SelectedCategoryItem("man", "hot", "week");
}
