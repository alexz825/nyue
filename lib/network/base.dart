import 'dart:convert';
import 'package:dio/dio.dart';
import 'const.dart';
import 'exception.dart';
import 'cache.dart';

typedef T ModelJsonConvert<T>(Map<String, dynamic> json);

const _HTTP_ENDPOINT = "https://shuapi.jiaston.com/";

class Http {
  ///超时时间
  static const int CONNECT_TIMEOUT = 30000;
  static const int RECEIVE_TIMEOUT = 30000;

  static Http _instance = Http._internal();
  factory Http() => _instance;

  Dio dio;
  Map<String, CancelToken> _cancelToken = {};

  Http._internal() {
    if (dio == null) {
      // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
      BaseOptions options = new BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,

        // 响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: RECEIVE_TIMEOUT,

        // Http请求头.
        headers: {},
      );

      dio = new Dio(options);

      // 添加error拦截器
      dio.interceptors.add(ErrorInterceptor());
      // 添加缓存
      dio.interceptors.add(NetCacheInterceptor());
      this.init(baseUrl: _HTTP_ENDPOINT);
    }
  }

  ///初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  void init(
      {String baseUrl,
      int connectTimeout,
      int receiveTimeout,
      List<Interceptor> interceptors}) {
    dio.options = dio.options.merge(
      baseUrl: baseUrl ?? _HTTP_ENDPOINT,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors..addAll(interceptors);
    }
  }

  /// restful get 操作
  Future get(
    String path, {
    Map<String, dynamic> params,
    String keypath = "",
    Options options,
    bool noCache = !CACHE_ENABLE,
    String cacheKey = "",
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.merge(extra: {
      "noCache": noCache,
      "cacheKey": cacheKey.length == 0 ? path + params.toString() : cacheKey,
      "cacheDisk": cacheDisk,
    });
    var ctoken = CancelToken();
    this.storeCancelToken(path, ctoken, params: params);
    Response response;
    response = await dio.get(path,
        queryParameters: params, options: requestOptions, cancelToken: ctoken);
    this.storeCancelToken(path, null, params: params);
    var jsonValue = response.data;
    print("get  " + response.request.uri.toString());

    return this.processResponseData(jsonValue, keypath);
  }

  /// restful get 操作
  Future post(
    String path, {
    Map<String, dynamic> params,
    String keypath = "",
    Options options,
    bool noCache = !CACHE_ENABLE,
    String cacheKey = "",
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions = requestOptions.merge(extra: {
      "noCache": noCache,
      "cacheKey": cacheKey.length == 0 ? path + params.toString() : cacheKey,
      "cacheDisk": cacheDisk,
    });

    var ctoken = CancelToken();
    this.storeCancelToken(path, ctoken, params: params);

    requestOptions.contentType = "application/json";
    Response response;

    response = await dio.post(path,
        data: params, options: requestOptions, cancelToken: ctoken);
    this.storeCancelToken(path, null, params: params);
    var jsonValue = response.data;
    print("post  " + response.request.uri.toString());

    return this.processResponseData(jsonValue, keypath);
  }

  dynamic processResponseData(jsonValue, String keypath) {
    if (!(jsonValue is Map<String, dynamic>)) {
      var arrayWithCommaEndRegex = "},]";
      if (jsonValue is String && jsonValue.contains(arrayWithCommaEndRegex)) {
        jsonValue =
            (jsonValue as String).replaceAll(arrayWithCommaEndRegex, "}]");
      }
      jsonValue = json.decode(jsonValue);
    }

    var entity = ResultEntity.fromRawJson(jsonValue);
    if (entity.status != 1) {
      throw ResponseError(entity.info);
    }

    var res = Map<String, dynamic>.from(jsonValue["data"]);
    if (keypath.length == 0) {
      return res;
    }

    return res[keypath];
  }

  void storeCancelToken(String path, CancelToken token,
      {Map<String, dynamic> params}) {
    var key = path + (params == null ? "" : params.toString());
    if (token == null) {
      this._cancelToken.remove(key);
      return;
    }
    this._cancelToken[key] = token;
  }

  void cancelRequest(String path, {Map<String, dynamic> params}) {
    var token =
        this._cancelToken[path + (params == null ? "" : params.toString())];
    if (token != null) {
      token.cancel("cancel by user");
      this.storeCancelToken(path, null);
    }
  }
}
