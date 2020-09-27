
import 'package:nyue/data/book_city_item.dart';
import 'package:nyue/data/book_list_item.dart';
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
}