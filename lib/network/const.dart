import 'dart:convert';
/**
 * 网络请求错误码
 */
enum NetworkCode {
  NETWORK_ERROR,
  NETWORK_TIMEOUT,
  NETWORK_JSON_EXCEPTION,
  SUCCESS,
  OTHER
}

/**
 * 错误码对应描述
 */
extension NetworkCodeMessage on NetworkCode {
  String get message {
    switch (this) {
      case NetworkCode.NETWORK_ERROR:
        return '网络错误';
      default:
        return '未知错误';
    }
  }
}

/**
 * 请求方法
 */
enum HttpMethod {
  GET,
  POST
}

/**
 * backend api
 */
enum BAPI {
  categoryDiscover,
  getSpecialList,
  getDiscoveryAll, // 发现页分类内容
  getBookDetail, // 获取书籍详情
  getChapterList, // 获取书籍章节列表
  getChapterCotent, // 获取章节内容
}

extension ParseToAPIString on BAPI {
  String get value {
    switch (this) {
      case BAPI.categoryDiscover:
        return 'app/open/api/category/discovery';
      case BAPI.getSpecialList:
        return 'app/open/api/book/getSpecialList';
      case BAPI.getDiscoveryAll:
        return 'app/open/api/category/discoveryAll';
      case BAPI.getBookDetail:
        return 'app/open/api/book/getDetail';
      case BAPI.getChapterList:
        return 'app/open/api/chapter/getByBookId';
      case BAPI.getChapterCotent:
        return 'app/open/api/chapter/get';
      default:
        return '';
    }
  }
}

class ResultEntity {
  ResultEntity({
    this.code,
    this.msg,
  });

  final int code;
  final String msg;

  factory ResultEntity.fromRawJson(dynamic str) => ResultEntity.fromJson(str);

  String toRawJson() => json.encode(toJson());

  factory ResultEntity.fromJson(Map<String, dynamic> json) => ResultEntity(
    code: json["code"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "msg": msg,
  };
}

class ResponseError extends Error {
  String msg;
  ResponseError(this.msg);
}

