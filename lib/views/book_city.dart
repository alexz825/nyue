import 'package:flutter/cupertino.dart';
import 'package:nyue/network/api_list.dart';

class BookCity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookCityState();
  }
}

class _BookCityState extends State<BookCity> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("书城"),
    );
  }

  @override
  void initState() {
    // HttpUtil.getCategory("lady", "commend", "month", 1).then((value) {
    //   print(value);
    // }).catchError((e) {
    //   print(e);
    // });
  }
}