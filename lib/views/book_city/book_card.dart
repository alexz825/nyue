import 'package:flutter/cupertino.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/util/theme_manager.dart';
import 'package:nyue/views/uikit/NetworkImg.dart';

class BookCard extends StatelessWidget {
  BookCard(@required this.model, {Key key}) : super(key: key);
  BaseBookModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ZTheme.color.white,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 0.75,
                child: NetworkImg(model.img),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Text(
                model.name,
                maxLines: 1,
                style: ZTheme.cardTitleStyle,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 3, 10, 5),
              child: Text(
                model.author,
                maxLines: 1,
                style: ZTheme.cardSubTitleStyle,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
