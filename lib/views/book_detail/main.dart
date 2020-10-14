
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/network/api_list.dart';
import 'package:nyue/views/BasePageWidget.dart';
import 'package:nyue/data/book_detail.dart';

///实现抽象方法，直接给界面复制
class _BookDetailWidget extends NetNormalWidget<BookDetail> {
  @override
  Widget buildContainer(BookDetail data) {
    return ListView(
      children: [
        Container(
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Image.network(data.coverImg),

              Container(
                margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BookDetailPage extends StatefulWidget {
  int bookId;
  BookDetailPage({Key key, @required this.bookId}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {

  String title = "书籍详情";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${title}"),
      ),
      body: FutureBuilderWidget<BookDetail>(
        commonWidget: _BookDetailWidget(),
        loadData: _loadData,
      )
    );
  }

  ///网络请求库
  Future<BookDetail> _loadData(BuildContext context) async {
    var res = await HttpUtil.getBookDetail(widget.bookId, BookDetail.fromRawJson).catchError((error) {
      print(error);
    });
    // this.setState(() {
    //   this.title = res.title;
    // });
    return res;
  }
}