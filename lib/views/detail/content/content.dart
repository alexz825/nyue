import 'dart:ui';
import 'package:flutter/material.dart';

@immutable
class _SinglePage extends AnimatedWidget {
  _SinglePage(
      {Key key,
      @required Animation<double> animation,
      @required this.child,
      @required this.controller})
      : super(key: key, listenable: animation);

  final Widget child;
  final AnimationController controller;
  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var animation = listenable as Animation<double>;
    return Positioned(
      right: size.width * animation.value,
      width: size.width,
      height: size.height,
      child: Container(
        decoration: animation.value == 0 || animation.value == 1
            ? null
            : BoxDecoration(boxShadow: [
                BoxShadow(color: Color(0x09000000), offset: Offset(10, 0))
              ]),
        child: child,
      ),
    );
  }
}

typedef WidgetGet = Widget Function(Widget current);

class PageContentWidget extends StatefulWidget {
  PageContentWidget(
      {@required this.initial,
      @required this.previous,
      @required this.next,
      Key key})
      : super(key: key);

  final WidgetGet previous;
  final WidgetGet next;
  final Widget initial;

  @override
  State<StatefulWidget> createState() => PageContentWidgetState();
}

enum _ChapterScrollState { next, previous, no }

class PageContentWidgetState extends State<PageContentWidget>
    with TickerProviderStateMixin {
  _ChapterScrollState _scrollState = _ChapterScrollState.no;

  int currentIndex;

  List<_SinglePage> children = [];
  Map<Widget, AnimationController> controllers = {};

  /// 获取当前显示的widget
  /// 1. 需要提前设置scrollState
  /// 2. 需要提前判断是否是第一页或者最后一页
  _SinglePage get _currentShowingWidget {
    switch (this._scrollState) {
      case _ChapterScrollState.previous:
        return children[currentIndex - 1];
      case _ChapterScrollState.next:
        return children[currentIndex];
      default:
        return null;
    }
  }

  @override
  void initState() {
    currentIndex = 0;
    this.children = [
      createPage(
        widget.initial,
      ),
    ];
    super.initState();
  }

  @override
  void didUpdateWidget(PageContentWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanUpdate: (details) => this._onPanUpdate(details, size),
      onPanEnd: (details) => this._onPanEnd(details, size),
      child: Stack(
        children: List<Widget>.from(this.children.reversed.toList()),
      ),
    );
  }

  @override
  void dispose() {
    this.children.forEach((element) {
      element.controller.dispose();
    });
    super.dispose();
  }

  /// 根据滑动初始状态判断是上一页还是下一页
  /// [panDelta] 滑动的距离
  _ChapterScrollState getState(double panDelta) {
    if (panDelta == 0) {
      return _ChapterScrollState.no;
    } else if (panDelta < 0) {
      return _ChapterScrollState.next;
    } else if (panDelta > 0) {
      return _ChapterScrollState.previous;
    }
    return _ChapterScrollState.no;
  }

  /// 滑动到下一页
  void scrollToNextPage({double from}) {
    var targetIndex = this.currentIndex;
    var targetWidget = this.children[targetIndex];
    // 如果不是已经结束的
    if (targetWidget.controller.status != AnimationStatus.completed ||
        targetWidget.controller.status != AnimationStatus.dismissed) {
      targetWidget.controller.forward(from: from);
    }
    this.currentIndex = targetIndex + 1;
    print(this.currentIndex);
    this.children.add(
        this.createPage(widget.next(this.children[this.currentIndex].child)));
    this.setupChildren();
  }

  /// 滑动到上一页
  void scrollToPreviousPage({double from}) {
    var targetIndex = this.currentIndex - 1;
    var targetWidget = this.children[targetIndex];
    // 如果不是已经结束的
    if (targetWidget.controller.status != AnimationStatus.completed ||
        targetWidget.controller.status != AnimationStatus.dismissed) {
      targetWidget.controller.reverse();
    }
    //insert之后目标widget的位置自动+1了，不需要再设置currentIndex了
    var previousContent = widget.previous(this.children[targetIndex].child);
    var page = this.createPage(previousContent);
    this.children.insert(0, page);
    this.currentIndex = targetIndex + 1;
    this.setupChildren();
  }

  /// 插入page到指定位置，并设置当前可见状态
  bool insertChild(_SinglePage page, int index) {
    if (this.children[index].key == page.key) {
      return false;
    }
    this.children.insert(index, page);
    this.setupChildren();
    return true;
  }

  /// 设置所有页面当前的位置
  /// 如果是正在动画的不变，不是正在动画的按照规则配置
  void setupChildren() {
    this.children.asMap().forEach((index, element) {
      if (element.controller.isAnimating) {
        // 正在动画，忽视
        return;
      }
      if (index < currentIndex) {
        element.controller.value = 1;
      } else {
        element.controller.value = 0;
      }
    });
    setState(() {});
  }

  void restoreScrollStatus() {
    this._scrollState = _ChapterScrollState.no;
  }

  /// 手势滑动
  void _onPanUpdate(DragUpdateDetails details, Size size) {
    var delta = (size.width - details.globalPosition.dx) / size.width;

    /// scrolling with panGesutre
    if (this._scrollState != _ChapterScrollState.no) {
      var _controller = _currentShowingWidget.controller;

      if (_controller == null) {
        return;
      }
      setState(() {
        _controller.value = delta;
      });
      return;
    }

    /// start pan gesture
    // 1. 设置当前状态
    var _scrollState = this.getState(details.delta.dx);
    // 2. 获取要显示的view
    var currentShowingWidget = this.children[this.currentIndex].child;

    WidgetGet getter;
    int insertIndex;
    switch (_scrollState) {
      case _ChapterScrollState.next:
        getter = widget.next;
        insertIndex = this.children.length - 1;
        break;
      case _ChapterScrollState.previous:
        getter = widget.previous;
        insertIndex = 0;
        break;
      default:
        break;
    }
    if (getter == null) {
      this.restoreScrollStatus();
      return;
    }
    var willShowWidget = getter(currentShowingWidget);
    if (willShowWidget == null) {
      this.restoreScrollStatus();
      return;
    }

    bool insertSuccess =
        this.insertChild(createPage(willShowWidget), insertIndex);

    // if (insertSuccess) {
    //   this.restoreScrollStatus();
    //   return;
    // }
    this._scrollState = _scrollState;
    var _controller = _currentShowingWidget.controller;
    if (_scrollState == _ChapterScrollState.next) {
      _controller.value = 0;
      _controller.animateTo(delta);
      setState(() {
        this.children.add(createPage(willShowWidget));
      });
    } else if (_scrollState == _ChapterScrollState.previous) {
      _controller.value = 1;
      _controller.animateBack(delta);
      this.setState(() {
        this.currentIndex += 1;
      });
    }
  }

  /// 手势滑动结束
  void _onPanEnd(DragEndDetails details, Size size) {
    bool isVelocity = details.velocity.pixelsPerSecond.dx.abs() > 0;
    var _widget = _currentShowingWidget;
    var _controller = _widget.controller;
    var _panOffset = _controller.value;

    if (_scrollState == _ChapterScrollState.next) {
      if (_panOffset > 0.5 || isVelocity) {
        _controller
            .forward(from: _panOffset)
            .then((value) => {this.animatedDone(_widget)});
        this.scrollToNextPage();
      } else {
        _controller.reverse(from: _panOffset);
      }
    } else if (_scrollState == _ChapterScrollState.previous) {
      if (_panOffset < 0.5 || isVelocity) {
        _controller.reverse(from: _panOffset).then((value) {
          print("dskjla;fsjifds;af");
          this.animatedDone(_widget);
        });
        this.scrollToPreviousPage();
      } else {
        _controller.forward(from: _panOffset);
      }
    }
    this.restoreScrollStatus();
  }

  void animatedDone(_SinglePage page) {
    print("done");
    if (this.children.length < 5) {
      return;
    }
    // print(this.children);
    // print(page);
    this.children.remove(page);
    print("children.length === $(this.children.length)");
    // var max = this.currentIndex + 2;
    // var min = this.currentIndex - 2;
    // var currentShowing = this._currentShowingWidget;
    // this.children.asMap().forEach((index, element) {
    //   if ((index < min || index > max) && !element.controller.isAnimating) {}
    // });
  }

  _SinglePage createPage(Widget child) {
    AnimationController controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.linear);

    return _SinglePage(
      animation: animation,
      controller: controller,
      child: child,
    );
  }
}
