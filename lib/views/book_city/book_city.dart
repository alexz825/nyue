import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/data/category.dart';
import 'package:nyue/network/api_list.dart';
import 'package:nyue/views/book_city/book_card.dart';
import 'package:nyue/views/util/CustomGridLayout.dart';
import 'package:nyue/views/util/navigator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class _BookCityUIProperty {
  static final categoryLineHeight = 100.0;
  static double get categoryCornerRadius {
    return (categoryLineHeight -
            categoryScrollViewInset.top -
            categoryScrollViewInset.bottom -
            categaryButtonInset.top -
            categaryButtonInset.bottom) /
        2;
  }

  static final categaryButtonInset = EdgeInsets.only(left: 10, right: 10);
  static final categoryScrollViewInset = EdgeInsets.fromLTRB(10, 0, 10, 0);
}

final _defaultSelectedItem = BookCityState("man", "hot", "week", 1);
final _allCategorires = AllCategories.defaultData();

class BookCityState {
  BookCityState(this.gender, this.category, this.rank, this.page);
  String gender;
  String category;
  String rank;
  int page;
  List<BaseBookModel> items = [];
  String errorString;

  List<String> get selected => [this.gender, this.category, this.rank];

  BookCityState update(
      {String gender, String category, String rank, int page}) {
    var newState =
        BookCityState(this.gender, this.category, this.rank, this.page);
    if (gender != null) {
      newState.gender = gender;
    }

    if (category != null) {
      newState.category = category;
    }

    if (rank != null) {
      newState.rank = rank;
    }

    if (page != null) {
      newState.page = page;
    }

    return newState;
  }
}

class BookCityStateInit extends BookCityState {
  BookCityStateInit(String gender, String category, String rank, int page)
      : super(gender, category, rank, page);
  @override
  BookCityStateInit update(
      {String gender, String category, String rank, int page}) {
    var state = super
        .update(gender: gender, category: category, rank: rank, page: page);
    return BookCityStateInit(
        state.gender, state.category, state.rank, state.page);
  }
}

class BookCityStateLoadingEnd extends BookCityState {
  BookCityStateLoadingEnd(String gender, String category, String rank, int page)
      : super(gender, category, rank, page);
  @override
  BookCityStateLoadingEnd update(
      {String gender, String category, String rank, int page}) {
    var state = super
        .update(gender: gender, category: category, rank: rank, page: page);
    return BookCityStateLoadingEnd(
        state.gender, state.category, state.rank, state.page);
  }
}

class BookCityCubit extends Cubit<BookCityState> {
  BookCityCubit() : super(_defaultSelectedItem);

  void selectGender(String gender) {
    HttpUtil.cancelPreviosCategoryRequest(
        state.gender, state.category, state.rank, state.page);
    var newState = BookCityState(gender, state.category, state.rank, 1);
    emit(newState);
    request(newState);
  }

  void selectCategory(String category) {
    HttpUtil.cancelPreviosCategoryRequest(
        state.gender, state.category, state.rank, state.page);
    var newState = BookCityState(state.gender, category, state.rank, 1);
    emit(newState);
    request(newState);
  }

  void selectRank(String rank) {
    HttpUtil.cancelPreviosCategoryRequest(
        state.gender, state.category, state.rank, state.page);
    var newState = BookCityState(state.gender, state.category, rank, 1);
    emit(newState);
    request(newState);
  }

  void loadMore() {
    state.page += 1;
    request(state);
  }

  void refresh() {
    state.page = 1;
    request(state);
  }

  request(BookCityState state) async {
    var newState = BookCityStateLoadingEnd(
        state.gender, state.category, state.rank, state.page);
    newState.items = state.items;
    HttpUtil.getCategory(state.gender, state.category, state.rank, state.page)
        .then((value) {
      if (newState.page <= 1) {
        newState.items = value;
        emit(newState);
      } else {
        newState.items.addAll(value);
        emit(newState);
      }
    }).catchError((e) {
      if (newState.items.length != 0 && newState.page <= 1) {
        newState.errorString = e.toString();
      }
      emit(newState);
    });
  }
}

class BookCity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BookCityState();
}

class _BookCityState extends State<BookCity>
    with AutomaticKeepAliveClientMixin<BookCity> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (_) {
        var cubit = BookCityCubit();
        cubit.request(cubit.state);
        return cubit;
      },
      child: buildContentView(),
    );
  }

  /*
  content widget
  */
  Widget buildContentView() {
    // var bloc = context.bloc<BookCityCubit>();
    // var state = bloc.state;

    return BlocBuilder<BookCityCubit, BookCityState>(
      builder: (context, state) {
        var bloc = context.bloc<BookCityCubit>();
        if (state is BookCityStateLoadingEnd) {
          _refreshController.loadComplete();
        }
        return SmartRefresher(
          enablePullDown: false,
          enablePullUp: state.page < 5,
          onRefresh: () {
            bloc.refresh();
          },
          onLoading: () {
            bloc.loadMore();
          },
          controller: _refreshController,
          child: CustomScrollView(
            slivers: <Widget>[
              //头部
              // SliverAppBar(
              //   pinned: true,
              //   flexibleSpace: FlexibleSpaceBar(
              //     title: Text('水平横向滑动'),
              //   ),
              // ),

              SliverList(
                  delegate: SliverChildBuilderDelegate((context, section) {
                return buildCategorySection(section);
              }, childCount: _allCategorires.length)),

              BlocBuilder<BookCityCubit, BookCityState>(
                buildWhen: (previous, current) =>
                    previous.items.length != current.items.length ||
                    previous.items != current.items,
                builder: (context, state) {
                  return SliverPadding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    sliver: SliverGrid(
                      gridDelegate: CustomGridLayout(3),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return GestureDetector(
                          onTap: () {
                            NavigatorUtil.pushToDetail(
                                context, state.items[index].id,
                                book: state.items[index]);
                          },
                          child: BookCard(state.items[index]),
                        );
                      }, childCount: state.items.length),
                    ),
                  );
                },
              ),
              buildLoading(),
            ],
          ),
        );
      },
    );
  }

  /*
  顶部三行分类
   */
  Widget buildCategorySection(int section) {
    var sectionData = _allCategorires[section];
    return Container(
        margin: section == 0
            ? EdgeInsets.only(top: 10)
            : section == _allCategorires.length - 1
                ? EdgeInsets.only(bottom: 5)
                : EdgeInsets.zero,
        height: 30,
        padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
        child: BlocBuilder<BookCityCubit, BookCityState>(
          buildWhen: (previous, current) =>
              previous.selected[section] != current.selected[section],
          builder: (context, state) {
            return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sectionData.length,
                separatorBuilder: (context, index) {
                  return VerticalDivider(
                    width: 5,
                    color: Color(0x00ffffff),
                  );
                },
                itemBuilder: (context, item) {
                  var itemData = sectionData[item];
                  var isSelected = itemData.type == state.selected[section];
                  return GestureDetector(
                    onTap: () {
                      var bloc = context.bloc<BookCityCubit>();
                      switch (section) {
                        case 0:
                          bloc.selectGender(itemData.type);
                          break;
                        case 1:
                          bloc.selectCategory(itemData.type);
                          break;
                        case 2:
                          bloc.selectRank(itemData.type);
                          break;
                        default:
                          break;
                      }
                    },
                    child: Container(
                        padding: _BookCityUIProperty.categaryButtonInset,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                _BookCityUIProperty.categoryCornerRadius)),
                            color:
                                isSelected ? Colors.green : Color(0x00ffffff)),
                        child: Center(
                          child: Text(
                            sectionData[item].name,
                            style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Color(0xff333333),
                                fontSize: 13),
                          ),
                        )),
                  );
                });
          },
        ));
  }

  Widget buildLoading() {
    return BlocBuilder<BookCityCubit, BookCityState>(
      // buildWhen: (previous, current) => current.items.length == 0,
      builder: (context, state) {
        if (state.items.length != 0) {
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, section) {
            return Container(height: 0);
          }, childCount: 0));
        }
        return SliverFillRemaining(
            child: Center(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.errorString == null
                ? [CircularProgressIndicator()]
                : [
                    Text(state.errorString),
                    RaisedButton(
                        onPressed: () =>
                            context.bloc<BookCityCubit>().request(state),
                        child: Text("点击重试"))
                  ],
          ),
        ));
      },
    );
  }
}
