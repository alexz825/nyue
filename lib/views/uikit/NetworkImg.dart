
import 'package:flutter/material.dart';
const _img_prefix = "https://imgapi.jiaston.com/BookFiles/BookImages/";
class NetworkImg extends StatelessWidget {
  String url;
  NetworkImg(@required this.url, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network("https://imgapi.jiaston.com/BookFiles/BookImages/" + url, fit: BoxFit.fill,);
  }
}