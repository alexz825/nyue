import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// // 自定义card里面grid view高度
class CustomGridLayout extends SliverGridDelegateWithFixedCrossAxisCount {

  CustomGridLayout(
      int crossAxisCount,
      ) : super(
    crossAxisCount: crossAxisCount,
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
      mainAxisStride: childMainAxisExtent + mainAxisSpacing, // 轴跨度 = 图片高度 + 文字高度 + 上下行距主
      crossAxisStride: layout.crossAxisStride,
      childMainAxisExtent: childMainAxisExtent,
      childCrossAxisExtent: layout.childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }
}