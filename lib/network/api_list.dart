
import 'package:nyue/data/book_chapter.dart';
import 'package:nyue/data/book_city_item.dart';
import 'package:nyue/data/book_detail.dart';
import 'package:nyue/data/book_list_item.dart';
import 'package:nyue/data/chapter_content.dart';
import 'package:nyue/network/base.dart';
import 'package:nyue/network/const.dart';

const _PAGE_SIZE = 20;

class HttpUtil {
  // <List<BookCityCard>>
  static Future<List<BookCityCardModel>> getCategoryDiscovery(int page, ModelJsonConvert convert) async {
    List res = await Http().get(
        BAPI.categoryDiscover.value,
        params: {"pageSize": _PAGE_SIZE, "pageNum": page},
        keypath: "list"
        );

    return List<BookCityCardModel>.from(res.toList().map((e) {
      var data = Map<String, dynamic>.from(e);
      return convert(e) as BookCityCardModel;
    }));
  }

  static Future<List<BookListItem>> getDiscoveryAll(int page, String type, ModelJsonConvert convert, {int pageSize = _PAGE_SIZE, int categoryId = 0}) async {
    List res = await Http().get(
        BAPI.getDiscoveryAll.value,
        params: {"pageSize": pageSize, "pageNum": page, "type": type, "categoryId": categoryId},
        keypath: "list"
    );

    return List<BookListItem>.from(res.toList().map((e) {
      var data = Map<String, dynamic>.from(e);
      return convert(e) as BookListItem;
    }));
  }

  static Future<BookDetail> getBookDetail(int bookId, ModelJsonConvert convert) async {
    var res = await Http().get(
        BAPI.getBookDetail.value,
        params: {"bookId": bookId},
        keypath: ""
    );
    var value = Map<String, dynamic>.from(res);
    return convert(value) as BookDetail;
  }

  /**
   * bookId: 书籍id
   * chapterId: [可选] 从第几章节开始获取
   */
  static Future<List<Chapter>> getChapterList(int bookId, {double chapterId}) async {
    List res = await Http().get(
        BAPI.getChapterList.value,
        params: {"bookId": bookId, "chapterId": chapterId},
        keypath: "chapters"
    );
    return List<Chapter>.from(res.toList().map((e) => Chapter.fromRawJson(Map<String, dynamic>.from(e))));
  }

  static Future<List<ChapterContent>> getChapterContent(int bookId, List<int> chapterIdList) async {
    List res = await Http().post(
        BAPI.getChapterCotent.value,
        params: {"bookId": bookId, "chapterIdList": chapterIdList},
        keypath: "list"
    );

    return List<ChapterContent>.from(res.toList().map((e) => ChapterContent.fromRawJson(e)));
  }
}