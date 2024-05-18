import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/news/data/news_repository.dart';
import 'package:iqj/features/news/domain/news.dart';

abstract class SearchEvent {}

class FetchNews extends SearchEvent {}

class SearchNewsLoadList extends SearchEvent {
  //final String id;
  final Completer? completer;
  SearchNewsLoadList({required this.completer});
  List<Object?> get props => [completer];
}

// States
abstract class SearchNewsState {}

class SearchInitial extends SearchNewsState {}

class SearchLoading extends SearchNewsState {}

class SearchLoaded extends SearchNewsState {
  final List<News> news;
  bool flagOpenTags = false;
  SearchLoaded(this.news, this.flagOpenTags);

  //News get news => null;
}

class SearchError extends SearchNewsState {
  final String errorMessage;
  SearchError(this.errorMessage);
}

class SearchFail extends SearchNewsState {
  final Object? except;
  SearchFail({required this.except});
  List<Object?> get pros => [except];
}

class SearchBloc extends Bloc<SearchEvent, SearchNewsState> {
  final String text;
  SearchBloc(this.text) : super(SearchInitial()) {
    print("init bloc");
    on<SearchNewsLoadList>((event, emit) async {
      try {
        if (state is! SearchLoaded) {
          print("news load loading now");
          emit(SearchLoading());
        }
        //print("Start load news "+id);
        final List<News> news = await getNewsByHeader(text);
        print("News loaded");
        emit(SearchLoaded(news, false));
      } catch (e) {
        print("error: " + SearchFail(except: e).toString());
        emit(SearchFail(except: e));
      } finally {
        event.completer?.complete();
      }
    });
  }
}