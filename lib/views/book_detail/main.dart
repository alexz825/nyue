
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/network/api_list.dart';
import 'package:nyue/util/time.dart';
import 'package:nyue/views/BasePageWidget.dart';
import 'package:nyue/data/book_detail.dart';
import 'package:intl/intl.dart';

class Seperator extends StatelessWidget {
  Color color;
  Seperator({this.color, key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: color == null ? Color(0xffe5e5e5) : color,
    );
  }
}

///实现抽象方法，直接给界面复制
class _BookDetailWidget extends NetNormalWidget<BookDetail> {
  @override
  Widget buildContainer(BookDetail data) {
    if (data == null) {
      return Center(
        child: Text("暂无数据"),
      );
    } else {
      var format = DateFormat("yyyy-HH-dd hh:mm:ss");

      return SafeArea(
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: ListView(
                  children: [
                    Container(
                      // 顶部封面和名字
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      height: 140,
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          AspectRatio(
                            aspectRatio: 0.75,
                            child: Image.network(data.coverImg),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Flex(
                              direction: Axis.vertical,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Color(0xff333333)),
                                ),
                                Container(
                                  height: 8,
                                ),
                                Text(
                                  data.author,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xff666666)),
                                ),
                                Container(
                                  height: 5,
                                ),
                                Text(
                                  data.categoryName + "  " + data.word,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xff999999)),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // 描述
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(data.desc, style: TextStyle(fontSize: 15, color: Color(0xff333333)),),
                    ),
                    Container(
                      // 最新章节
                      height: 50,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.alarm, size: 25, color: Color(0xff666666),),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: Text(data.update.chapterName, style: TextStyle(color: Color(0xff999999)),),
                            ),
                          ),
                          Text("${format.format(DateTime.fromMillisecondsSinceEpoch(data.update.time))}", style: TextStyle(color: Color(0xff55eeee)),),
                          Icon(Icons.arrow_forward_ios, size: 25, color: Color(0xff666666))
                        ],
                      ),
                    ),
                    Seperator(),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.menu, size: 25, color: Color(0xff666666),),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 5, right: 5),
                              child: Text("共 ${data.chapterNum} 章", style: TextStyle(color: Color(0xff999999)),),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 25, color: Color(0xff666666))
                        ],
                      ),
                    ),
                    Seperator()
                  ],
                )
            ),
            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            //     Container(
            //       padding: EdgeInsets.only(left: 20, right: 20),
            //       decoration: BoxDecoration(
            //           color: Colors.green,
            //           borderRadius: BorderRadius.all(Radius.circular(20))
            //       ),
            //     ),
            //     Positioned(
            //       // top: -10,
            //       child: Center(child: Text("开始阅读", style: TextStyle(fontSize: 17, color: Colors.white), ),),
            //     )
            //   ],
            // )
            Container(
                height: 40,
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(child: FlatButton.icon(onPressed: null, icon: Icon(Icons.file_download), label: Text("下载")),),
                    Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // TODO: 开始阅读
                          },
                          child: Container(
                            child: Center(
                              child: Text(
                                "开始阅读",
                                style: TextStyle(fontSize: 17, color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(20))),
                      ),
                    )
                    ),
                    Expanded(
                      child: FlatButton.icon(onPressed: null, icon: Icon(Icons.bookmark), label: Text("书架")),
                    )
                  ],
                )
            ),
          ],
        ),
      );
    }
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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