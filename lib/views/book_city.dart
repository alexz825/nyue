import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/data/category.dart';
import 'package:nyue/network/api_list.dart';

class BookCity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookCityState();
  }
}

class _BookCityState extends State<BookCity> {


  List<List<Category>> categoriesData = [];
  List<Category> selected;
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        //头部
        // SliverAppBar(
        //   pinned: true,
        //   flexibleSpace: FlexibleSpaceBar(
        //     title: Text('水平横向滑动'),
        //   ),
        // ),
        //横向滑动区域
        SliverToBoxAdapter(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            height: 200,
            child: Column(
              children: List<Widget>.from(this.categoriesData.map((sectionData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sectionData.length,
                  itemBuilder: (context, row) {
                    var category = sectionData[row];
                    return Container(
                      height: 40,
                      child: Text(category.name),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.green
                      ),
                    );
                  },
                );
              })),
            )
          )
        ),

        //垂直列表
        SliverList(
          delegate: SliverChildBuilderDelegate((content, index) {
            return Card(
              color: Colors.primaries[index % Colors.primaries.length],
              child: Container(
                height: 100,
                alignment: Alignment.center,
                child: Text(index.toString()),
              ),
            );
          }, childCount: 30),
        )

      ],
    );
  }

  @override
  void initState() {
    this.categoriesData = AllCategories.defaultData();
    if (this.selected == null) {
      this.selected = [this.categoriesData[0][0], this.categoriesData[1][0], this.categoriesData[2][0]];
    }
    this.setState(() {

    });
    // HttpUtil.getCategory("lady", "commend", "month", 1).then((value) {
    //   print(value);
    // }).catchError((e) {
    //   print(e);
    // });
  }

  request() {
    HttpUtil.getCategory(this.selected[0].type, this.selected[1].type, this.selected[2].type, this.page).then((value) {
      // TODO: 刷新页面
    }).catchError(() {

    });
  }
}

class _CategoryItem extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<_CategoryItem> {
  @override
  Widget build(BuildContext context) {

  }
}