import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/views/book_city/card.dart';
import 'package:nyue/data/book_city_item.dart';
import 'package:nyue/data/book_list_item.dart';
import 'package:nyue/network/api_list.dart';
import 'package:nyue/views/book_detail/main.dart';

class BookCity extends StatefulWidget {
  BookCity({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BookCityState();
}

class _BookCityState extends State<BookCity> {

  ScrollController _scrollController = ScrollController();

  List<BookCityCardModel> cards = [];

  /// 书城当前页码
  int page = 1;
  // 保存当前页面所有专题对应的页码，每页八个，点击换一换+1
  Map<String, int> pages = {};

  @override
  Widget build(BuildContext context) {
    if (this.cards.length == 0) {
      return Center(
        child: Text("加载中..."),
      );
    }
    return Container(
      color: Color(0xfefefefe),
      child: RefreshIndicator(
        child: ListView.separated(
          controller: _scrollController,
          itemCount: max(1, this.cards.length),
          itemBuilder: (context, index) => BookCityCard(
            data: this.cards[index],
            handler: BookCityCardActionHandler(
                goMore: (){
                  // TODO: 跳转到对应category页面
                },
                refreshCategory: this.refreshCategory,
                gotoBookDetail: (int novelId) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return BookDetailPage(bookId: novelId);
                  }));
                }
            ),
          ),
          separatorBuilder: (context, index) {
            return Container(
              height: 10,
              color: Colors.grey.withAlpha(40),
            );
          },
        ),
        onRefresh: this._handleRefresh,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 初始化scrollView相关
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        this.request(this.page + 1);
      }
    });
    // 请求数据
    this.request(this.page);
  }

  Future<void> _handleRefresh() {
    return this.request(1);
  }

  Future<bool> refreshCategory(String category, int categoryId) {
    int page = this.pages[this.getCategoryKey(category, categoryId)] ?? 1; // 第一次请求就是第一页了
    page += 1;
    return this.requestCategory(category, categoryId, page);
  }

  Future<void> request(int page) {
    Future<List<BookCityCardModel>> result = HttpUtil.getCategoryDiscovery(page, BookCityCardModel.fromRawJson);
    return result.then((value) {
      print(value);
      this.setState(() {
        this.cards = value;
      });
      this.page += 1;
    }).catchError((error) {
      // TODO: 显示error页面，点击重新加载
      print(error);
    });
  }

  Future<bool> requestCategory(String category, int categoryId, int page) {
    Future<List<BookListItem>> data = HttpUtil.getDiscoveryAll(page, category, BookListItem.fromRawJson, pageSize: 8, categoryId: categoryId);
    return data.then((value) {
      print(value);
      // TODO: 更新某列数据
      this.pages[this.getCategoryKey(category, categoryId)] = page;
      this.setState(() {
        this.cards.firstWhere((element) => element.type == category && element.categoryId == categoryId)?.bookList = value;
      });
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  String getCategoryKey(String category, int id) {
    return category + '$id';
  }
}
