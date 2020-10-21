import 'package:flutter/cupertino.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/views/uikit/NetworkImg.dart';

class BookCard extends StatelessWidget {
  BookCard(@required this.model, {Key key}) : super(key: key);
  BaseBookModel model;
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 0.75,
            child: NetworkImg(model.img),
          ),
        ),
        Text(model.name, maxLines: 1,),
        Text(model.desc, maxLines: 1,)
      ],
    );
  }
}