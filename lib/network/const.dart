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

class ResultEntity {
  ResultEntity({
    this.status,
    this.info,
  });

  final int status;
  final String info;

  factory ResultEntity.fromRawJson(dynamic str) => ResultEntity.fromJson(str);

  factory ResultEntity.fromJson(Map<String, dynamic> json) => ResultEntity(
    status: json["status"],
    info: json["info"],
  );

}

class ResponseError extends Error {
  String msg;
  ResponseError(this.msg);
}

