
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 阅读地址
// https://juejin.im/post/6844903906766487566

typedef LoadDataFuture<T> = Future<T> Function(BuildContext context);

abstract class NetNormalWidget<T> extends StatelessWidget {
  final T bean;

  NetNormalWidget({this.bean});

  @override
  Widget build(BuildContext context) {
    return buildContainer(bean);
  }

  Widget buildContainer(T t);
}

abstract class ErrorCallback {
  void retryCall();
}

class NetworkErrorWidget extends StatelessWidget {
  final Widget errorChild;
  final ErrorCallback callback;

  NetworkErrorWidget({@required this.errorChild, this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: errorChild,
      onTap: () => callback?.retryCall(),
    );
  }
}

class FutureBuilderWidget<T> extends StatefulWidget {
  final Widget loadingWidget;
  final Widget errorWidget;
  final NetNormalWidget<T> commonWidget;

  final LoadDataFuture<T> loadData;

  FutureBuilderWidget(
      {
        @required this.commonWidget,
        @required this.loadData,
        this.loadingWidget,
        this.errorWidget
      });

  @override
  State<StatefulWidget> createState() {
    return _FutureBuilderWidgetState<T>();
  }
}

///网络请求 失败 Widget
class NetErrorWidget extends StatelessWidget {
  final Widget errorChild;
  final ErrorCallback callback;

  NetErrorWidget({@required this.errorChild, this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: errorChild,
      onTap: () => callback?.retryCall(),
    );
  }
}

class _FutureBuilderWidgetState<T> extends State<FutureBuilderWidget> with ErrorCallback {

  bool isRequesting = false;
  Future loadData;

  @override
  void initState() {
    super.initState();
    this.request();
  }
  // 默认加载页面
  final defaultLoading = Center(
    child: CircularProgressIndicator(),
  );

  Widget _defaultError(dynamic error) {
    return Center(
      child: Text(error.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: this.request(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              return widget.loadingWidget ?? defaultLoading;
            default:
              if (snapshot.hasError) {
                ///网络出错
                if (widget.errorWidget != null) {
                  ///自定义出错界面
                  if (widget.errorWidget is NetErrorWidget) {
                    return widget.errorWidget;
                  } else {
                    ///只自定义界面显示内容
                    return NetErrorWidget(
                      errorChild: widget.errorWidget,
                      callback: this,
                    );
                  }
                } else {
                  ///选用默认出错界面
                  return NetErrorWidget(
                    errorChild: _defaultError(snapshot.error),
                    callback: this,
                  );
                }
              }
              return widget.commonWidget.buildContainer(snapshot.data);
          }
        });
  }

  @override
  void retryCall() {
    this.request();
    setState(() {
      ///通知State重新构建界面需要
    });
  }

  Future request() {
    if (this.isRequesting && this.loadData != null) {
      return this.loadData;
    }
    this.isRequesting = true;
    this.loadData = widget.loadData(context).whenComplete(() {
      this.isRequesting = false;
    });
  }
}

