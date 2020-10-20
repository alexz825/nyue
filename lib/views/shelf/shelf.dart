import 'package:flutter/cupertino.dart';


class ShelfWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Shelf();
}

class _Shelf extends State<ShelfWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("书架"),
    );
  }
}