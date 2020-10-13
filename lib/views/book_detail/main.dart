
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/views/BasePageWidget.dart';

///实现抽象方法，直接给界面复制
class CommonWidget extends NetNormalWidget<String> {
  @override
  Widget buildContainer(String t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(t),
          Text(t + "sss"),
        ],
      ),
    );
  }
}

class BookDetail extends StatefulWidget {
  int bookId;
  BookDetail({Key key, @required this.bookId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.bookId}"),
      ),
      body: FutureBuilderWidget(
        commonWidget: CommonWidget(),
        loadData: _loadData,
      )
      // Center(
      //   child: Text("详情页${widget.bookId}"),
      // ),
    );
  }

  ///网络请求库
  Future<dynamic> _loadData(BuildContext context) async {

    await Future.delayed(Duration(seconds: 1), (){
      print('延时1s执行');
    });
    throw Error();
    return "ssss";
  }

  @override
  void retryCall() {
    Navigator.of(context).pop();
  }
}