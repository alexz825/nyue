import 'package:flutter/material.dart';

const _img_prefix = "https://imgapi.jiaston.com/BookFiles/BookImages/";

@immutable
class NetworkImg extends StatelessWidget {
  final String url;
  NetworkImg({@required this.url, Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.network(
      _img_prefix + url,
      fit: BoxFit.fill,
    );
  }
}
