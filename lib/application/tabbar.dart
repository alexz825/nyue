import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/views/book_city/book_city.dart';
import 'package:nyue/views/shelf/shelf.dart';

class TempView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        GridView.count(
          crossAxisCount: 3,
          physics: NeverScrollableScrollPhysics(),
          // to disable GridView's scrolling
          shrinkWrap: true,
          // You won't see infinite size error
          children: <Widget>[
            Container(
              height: 24,
              color: Colors.green,
            ),
            Container(
              height: 24,
              color: Colors.blue,
            ),
          ],
        ),
        // ...... other list children.
      ],
    );
  }
}

class HomeTabbar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeTabbarState();
}

class HomeTabbarState extends State<HomeTabbar>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.white,
      home: Scaffold(
        appBar: AppBar(
          title: Text("看书呢"),
        ),
        body: SafeArea(
          child: SizedBox.expand(
            child: TabBarView(
              controller: controller,
              children: [ShelfWidget(), BookCity(), new TempView()],
            ),
          ),
        ),
        bottomNavigationBar: new Material(
            color: Colors.white,
            child: SafeArea(
              child: new TabBar(
                  controller: controller,
                  labelColor: Colors.deepPurpleAccent,
                  unselectedLabelColor: Colors.black26,
                  tabs: [
                    Tab(
                      text: "书架",
                      icon: Icon(Icons.book),
                    ),
                    Tab(
                      text: "书城",
                      icon: Icon(Icons.store),
                    ),
                    Tab(
                      text: "设置",
                      icon: Icon(Icons.settings),
                    ),
                  ]),
            )),
      ),
    );
  }
}
