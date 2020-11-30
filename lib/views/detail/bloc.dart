import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class ChapterReaderBloc extends Cubit<ChapterReaderState> {
  ChapterReaderBloc(ChapterReaderState state) : super(state);
}

class ChapterReaderSettingBloc extends Cubit<ChapterReaderSettingState> {
  ChapterReaderSettingBloc(ChapterReaderSettingState state) : super(state) {}
}
