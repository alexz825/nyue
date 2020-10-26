import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nyue/views/detail/page_turn/page_turn_widget.dart';

class PageTurn extends StatefulWidget {
  PageTurn(
      {Key key,
      this.backgroundColor,
      this.duration,
      this.initialIndex,
      this.lastPage,
      this.showDragCutoff,
      this.pageCount,
      this.builder,
      this.cutoff})
      : super(key: key);

  final Color backgroundColor;
  final Function(BuildContext context, int index) builder;
  final Duration duration;
  final int initialIndex;
  final Widget lastPage;
  final bool showDragCutoff;
  final double cutoff;
  final pageCount;

  /// 第一个显示的widget
  // final Widget firstWidget;
  // final Widget Function(Widget current) prevous;
  // final Widget Function(Widget current) current;

  @override
  State<StatefulWidget> createState() => PageTurnState();
}

class PageTurnState extends State<PageTurn> with TickerProviderStateMixin {
  int pageNumber = 0;
  List<Widget> pages = [];
  List<AnimationController> _controllers = [];
  bool _isForward;

  @override
  void didUpdateWidget(PageTurn oldWidget) {
    if (oldWidget.builder != widget.builder) {
      _setup();
    }
    if (oldWidget.duration != widget.duration) {
      _setup();
    }
    if (oldWidget.backgroundColor != widget.backgroundColor) {
      _setup();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controllers.forEach((element) => element.dispose());
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  void _setup() {
    _controllers.clear();
    pages.clear();
    for (var i = 0; i < widget.pageCount; i++) {
      final _controller =
          AnimationController(value: 1, duration: widget.duration, vsync: this);
      _controllers.add(_controller);
      final _child = Container(
          child: PageTurnWidget(
        backgroundColor: widget.backgroundColor,
        amount: _controller,
        child: widget.builder(context, i),
      ));

      pages.add(_child);
    }

    pages = pages.reversed.toList();
    pageNumber = widget.initialIndex;
  }

  bool get _isLastPage => pages != null && (pages.length - 1) == pageNumber;
  bool get _isFirstPage => pageNumber == 0;

  void _turnPage(DragUpdateDetails details, BoxConstraints dimentions) {
    final _ratio = details.delta.dx / dimentions.maxWidth;
    if (_isForward == null) {
      if (details.delta.dx > 0) {
        _isForward = false;
      } else {
        _isForward = true;
      }
    }

    if (_isForward || pageNumber == 0) {
      _controllers[pageNumber].value += _ratio;
    } else {
      _controllers[pageNumber - 1].value += _ratio;
    }
  }

  Future _onDragFinish() async {
    if (_isForward != null) {
      if (_isForward) {
        if (!_isLastPage &&
            _controllers[pageNumber].value <= (widget.cutoff + 0.15)) {
          await nextPage();
        } else {
          await _controllers[pageNumber].forward();
        }
      } else {
        // print(
        // 'Val:${_controllers[pageNumber - 1].value} -> ${widget.cutoff + 0.28}');
        if (!_isFirstPage &&
            _controllers[pageNumber - 1].value >= widget.cutoff) {
          await previousPage();
        } else {
          if (_isFirstPage) {
            await _controllers[pageNumber].forward();
          } else {
            await _controllers[pageNumber - 1].reverse();
          }
        }
      }
    }
    _isForward = null;
  }

  Future nextPage() async {
    print('Next Page..');
    await _controllers[pageNumber].reverse();
    if (mounted)
      setState(() {
        pageNumber++;
      });
  }

  Future previousPage() async {
    print('Previous Page..');
    await _controllers[pageNumber - 1].forward();
    if (mounted)
      setState(() {
        pageNumber--;
      });
  }

  Future goToPage(int index) async {
    print('Navigate Page ${index + 1}..');
    if (mounted)
      setState(() {
        pageNumber = index;
      });
    for (var i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i].forward();
      } else if (i < index) {
        // _controllers[i].value = 0;
        _controllers[i].reverse();
      } else {
        if (_controllers[i].status == AnimationStatus.reverse)
          _controllers[i].value = 1;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: LayoutBuilder(
        builder: (context, dimentions) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragCancel: () => _isForward == null,
          onHorizontalDragUpdate: (details) => _turnPage(details, dimentions),
          onHorizontalDragEnd: (details) => _onDragFinish(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (pages != null)
                ...pages
              else ...[
                Container(
                  child: CircularProgressIndicator(),
                )
              ],
              Positioned.fill(
                  // 点击区域监测,出发上一页下一页
                  child: Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    flex: (widget.cutoff * 10).round(),
                    child: Container(
                      color: widget.showDragCutoff
                          ? Colors.blue.withAlpha(100)
                          : null,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _isFirstPage ? null : previousPage,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 10 - (widget.cutoff * 10).round(),
                    child: Container(
                      color: widget.showDragCutoff
                          ? Colors.red.withAlpha(100)
                          : null,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _isLastPage ? null : nextPage,
                      ),
                    ),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
