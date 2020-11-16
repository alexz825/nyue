import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// 自定义异常
class AppException implements Exception {
  final String _message;
  final int _code;

  AppException([
    this._code,
    this._message,
  ]);

  String toString() {
    return "$_code$_message";
  }

  factory AppException.create(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        {
          return BadRequestException(-1, "请求取消");
        }
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        {
          return BadRequestException(-1, "连接超时");
        }
        break;
      case DioErrorType.SEND_TIMEOUT:
        {
          return BadRequestException(-1, "请求超时");
        }
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        {
          return BadRequestException(-1, "响应超时");
        }
        break;
      case DioErrorType.RESPONSE:
        {
          try {
            int errCode = error.response.statusCode;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                {
                  return BadRequestException(errCode, "请求语法错误");
                }
                break;
              default:
                {
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  return AppException(errCode, error.response.statusMessage);
                }
            }
          } on Exception catch (_) {
            return AppException(-1, "未知错误");
          }
        }
        break;
      default:
        {
          return AppException(-1, error.message);
        }
    }
  }
}

/// 请求错误
class BadRequestException extends AppException {
  BadRequestException([int code, String message]) : super(code, message);
}

/// 错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  Future onError(DioError err) {
    // error统一处理
    AppException appException = AppException.create(err);
    // 错误提示
    debugPrint('DioError===: ${appException.toString()}');
    err.error = appException;
    return super.onError(err);
  }
}
