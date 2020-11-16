import 'package:nyue/data/book.dart';
import 'package:nyue/data/chapter.dart';
import 'package:nyue/data/search_result.dart';
import 'package:nyue/network/base.dart';

// api网页 https://www.cnblogs.com/maopixin/p/10457015.html#a1 搜索的还没加

class HttpUtil {
  /// 根据分类获取对应bookList
  static Future<List<BaseBookModel>> getCategory(
      String gender, String category, String rank, int page) async {
    List res = await Http()
        .get("top/$gender/top/$category/$rank/$page.html", keypath: "BookList");

    return List<BaseBookModel>.from(
        res.toList().map((e) => BaseBookModel.fromMap(e)));
  }

  /// 获取书籍详情
  static Future<BookModel> getBookDetail(int bookId) async {
    Map<String, dynamic> res =
        await Http().get("info/$bookId.html", keypath: "");

    return BookModel.fromMap(res);
  }

  /// 获取 章节内容
  /// bookId: 书籍id
  /// chapterId: chapterId
  static Future<ChapterContent> getChapterContent(
      int bookId, int chapterId) async {
    Map<String, dynamic> res =
        await Http().get("book/$bookId/$chapterId.html", keypath: "");

    return ChapterContent.fromMap(res);
  }

  /// 获取 章节目录
  /// bookId: 书籍id
  ///
  static Future<List<ChapterWrapper>> getChapterList(int bookId) async {
    List res = await Http().get("book/$bookId/", keypath: "list");

    return List<ChapterWrapper>.from(
        res.toList().map((e) => ChapterWrapper.fromMap(e)));
  }

  /// 搜索
  static Future<List<SearchResultItem>> search(String keyword, int page) async {
    List res = await Http()
        .get("search.aspx?key=$keyword&page=$page&siteid=app", keypath: "");

    return List<SearchResultItem>.from(
        res.toList().map((e) => SearchResultItem.fromMap(e)));
  }

  static void cancelPreviosCategoryRequest(
      String gender, String category, String rank, int page) {
    var path = "top/$gender/top/$category/$rank/$page.html";
    Http().cancelRequest(path);
  }
}
