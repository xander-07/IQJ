import 'dart:async';
import 'dart:html';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/news/data/news_repository.dart';
import 'package:iqj/features/news/domain/news.dart';
import 'package:iqj/features/news/presentation/screens/news_loaded_list_screen.dart';

abstract class NewsLoadEvent {}

class FetchNews extends NewsLoadEvent {}

class LoadNewsLoadList extends NewsLoadEvent{
  final Completer? completer;
  LoadNewsLoadList({required this.completer});

  List<Object?> get props => [completer];
  
}


// States
abstract class NewsLoadState {}

class NewsLoadInitial extends NewsLoadState {}

class NewsLoadLoading extends NewsLoadState {}

class NewsLoadLoaded extends NewsLoadState {
  final News newsList;

  NewsLoadLoaded(this.newsList);
}

class NewsLoadError extends NewsLoadState {
  final String errorMessage;

  NewsLoadError(this.errorMessage);
}

class NewsLoadListLoadingFail extends NewsLoadState{
  final Object? except;

  NewsLoadListLoadingFail({required this.except});
  List<Object?> get pros => [except];
}

class NewsLoadBloc extends Bloc<NewsLoadEvent,NewsLoadState>{
  final String id;

  NewsLoadBloc(this.id): super(NewsLoadInitial()){
    on<LoadNewsLoadList>((event,emit) async{
      try {
        if (state is! NewsLoadLoaded) {
          emit(NewsLoadLoading());
        }
        final News news = await getNewsFull(id);
        //print(newsList);
        emit(NewsLoadLoaded(news));
      } catch (e) {
        emit(NewsLoadListLoadingFail(except: e));
      } finally {
        event.completer?.complete();
      }
    });
  }
  
}