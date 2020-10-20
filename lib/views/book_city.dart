import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nyue/data/book.dart';
import 'package:nyue/data/category.dart';
import 'package:nyue/network/api_list.dart';

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

final _defaultSelectedItem = BookCityState("man", "hot", "week", 0);
final _allCategorires = AllCategories.defaultData();

class BookCityState {
  BookCityState(this.gender, this.category, this.rank, this.page);
  String gender;
  String category;
  String rank;
  int page;
  List<BaseBookModel> items = [];

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

class BookCityCubit extends Cubit<BookCityState> {
  BookCityCubit() : super(_defaultSelectedItem);

  void selectGender(String gender) {
    HttpUtil.cancelPreviosCategoryRequest(state.gender, state.category, state.rank, state.page);
    var newState = BookCityState(gender, state.category, state.rank, 1);
    emit(newState);
    request(newState);
  }

  void selectCategory(String category) {
    HttpUtil.cancelPreviosCategoryRequest(state.gender, state.category, state.rank, state.page);
    var newState = BookCityState(state.gender, category, state.rank, 1);
    emit(newState);
    request(newState);
  }

  void selectRank(String rank) {
    HttpUtil.cancelPreviosCategoryRequest(state.gender, state.category, state.rank, state.page);
    var newState = BookCityState(state.gender, state.category, rank, 1);
    emit(newState);
    request(newState);
  }

  void loadMore() => emit(
      BookCityState(state.gender, state.category, state.rank, state.page + 1));
  void refresh() =>
      emit(BookCityState(state.gender, state.category, state.rank, 1));

  void request(BookCityState state) {
    HttpUtil.getCategory(state.gender, state.category, state.rank, state.page).then((value) {
      if (state.page <= 1) {
        state.items = value;
        emit(state);
      } else {
        state.items.addAll(value);
        emit(state);
      }
    }).catchError((e) {
      // TODO: 创建error组件
    });
  }
}

class BookCity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookCityCubit(),
      child: buildContentView(),
    );
  }

  Widget buildContentView() {
    // var bloc = context.bloc<BookCityCubit>();
    // var state = bloc.state;
    return CustomScrollView(
      slivers: <Widget>[
        //头部
        // SliverAppBar(
        //   pinned: true,
        //   flexibleSpace: FlexibleSpaceBar(
        //     title: Text('水平横向滑动'),
        //   ),
        // ),

        SliverList(
            delegate: SliverChildBuilderDelegate((content, section) {
              return buildCategorySection(section);
            }, childCount: _allCategorires.length)),

        //垂直列表
        SliverList(
          delegate: SliverChildBuilderDelegate((content, index) {
            return Card(
              color: Colors.primaries[index % Colors.primaries.length],
              child: Container(
                height: 100,
                alignment: Alignment.center,
                child: Text(index.toString()),
              ),
            );
          }, childCount: 10),
        )
      ],
    );
  }

  Widget buildCategorySection(int section) {
    var sectionData = _allCategorires[section];
    return Container(
      margin: section == 0 ? EdgeInsets.only(top: 10) : section == _allCategorires.length - 1 ? EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
      height: 30,
      padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      child: BlocBuilder<BookCityCubit, BookCityState>(
        buildWhen: (previous, current) => previous.selected[section] != current.selected[section],
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
                var isSelected =
                    itemData.type == state.selected[section];
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
                          borderRadius: BorderRadius.all(
                              Radius.circular(_BookCityUIProperty
                                  .categoryCornerRadius)),
                          color: isSelected
                              ? Colors.green
                              : Color(0x00ffffff)),
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
      )
    );
  }
}
