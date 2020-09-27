
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nyue/data/book_city_item.dart';
import 'package:nyue/data/book_list_item.dart';
import 'package:nyue/views/uikit/AnimateRefreshIcon.dart';

class BookCityCardActionHandler {
  VoidCallback goMore;
  Future<bool> Function(String category, int categoryId) refreshCategory;

  BookCityCardActionHandler({this.goMore, this.refreshCategory});
}

// 自定义card里面grid view高度
class _MyGridDelegate extends SliverGridDelegateWithFixedCrossAxisCount {

  _MyGridDelegate() : super(
    crossAxisCount: 4,
  );
  @override
  double get childAspectRatio => 0.75;
  @override
  double get crossAxisSpacing => 10;
  @override
  double get mainAxisSpacing => 10;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    SliverGridRegularTileLayout layout = super.getLayout(constraints);

    final double usableCrossAxisExtent = constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1);
    final double childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;
    final double childMainAxisExtent = childCrossAxisExtent / childAspectRatio + 50;
    
    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: childMainAxisExtent + mainAxisSpacing, // 主轴跨度 = 图片高度 + 文字高度 + 上下行距
      crossAxisStride: layout.crossAxisStride,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: layout.childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }
}

// 书籍card
class _BookItemCard extends StatelessWidget {
  final BookListItem data;
  const _BookItemCard({
    Key key,
    this.data
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // FadeInImage.assetNetwork(placeholder: "", image: data.coverImg),
        AspectRatio(
          aspectRatio: 0.75,
          child: Container(
            color: Color(0xf5f5f5ff),
            child: Image.network(
              data.coverImg,
            ),
          )
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            this.data.title,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            this.data.desc,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardBottom extends StatefulWidget {
  final void Function() goMore;
  Future<bool> Function() refreshCategory;
  _CardBottom({Key key, this.goMore, this.refreshCategory}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardBottomState();
}

class _CardBottomState extends State<_CardBottom> with SingleTickerProviderStateMixin {

  var _buttonTextStyle = TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w400);

  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Flex(
        direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: FlatButton(
              onPressed: this.widget.goMore,
              child: Text("查看全部", style: _buttonTextStyle,),
            ),
          ),
          VerticalDivider(
            width: 1.0,
            color: Colors.grey,
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            flex: 2,
            child: FlatButton.icon(
              onPressed: () { // 点击刷新按钮
                if (this.animationController.isAnimating) {
                  return;
                }
                this.animationController.repeat();
                this.widget.refreshCategory().whenComplete(() {
                  this.animationController.stop();
                  this.animationController.reset();
                });
              },
              icon: AnimateRefreshIcon(controller: this.animationController),
              label: Text("换一批", style: _buttonTextStyle,),
            ),
          ),
        ],
      ),
    );
  }
}

class BookCityCard extends StatelessWidget {

  final BookCityCardModel data;
  BookCityCardActionHandler handler;

  BookCityCard({Key key, this.data, this.handler}) : super(key: key);

  var gridDelegate = _MyGridDelegate();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                width: 3,
                height: 15,
                color: Colors.green,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  data.categoryName,
                  maxLines: 1,
                ),
              )
            ],
          ),
          GridView(
            padding: EdgeInsets.all(10),
            gridDelegate: gridDelegate,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: this.data.bookList.map((e) => _BookItemCard(data: e,)).toList(),
          ),
          _CardBottom(
            goMore: this.handler.goMore,
            refreshCategory: this.refreshCategory(this.data.type, this.data.categoryId),
          )
        ],
      ),
    );
  }
  
  Future<bool> Function() refreshCategory(String category, int categoryId) {
    return () {
      return this.handler.refreshCategory(category, categoryId);
    };
  }
}