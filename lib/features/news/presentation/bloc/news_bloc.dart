import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/news/data/bookmarks.dart';
import 'package:iqj/features/news/data/fake_news_repository.dart';
import 'package:iqj/features/news/data/news_repository.dart';
import 'package:iqj/features/news/domain/news.dart';

// Events
abstract class NewsEvent {}

class FetchNews extends NewsEvent {}

class LoadNewsList extends NewsEvent {
  final Completer? completer;
  LoadNewsList({required this.completer});

  List<Object?> get props => [completer];
}

class AddNewsEvent extends NewsEvent {
  final News news;

  AddNewsEvent({required this.news});
}

class CheckBookmark extends NewsEvent {
  final News news;
  CheckBookmark({required this.news});
}

// States
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> newsList;

  NewsLoaded(this.newsList);
}

class NewsError extends NewsState {
  final String errorMessage;

  NewsError(this.errorMessage);
}

class NewsListLoadingFail extends NewsState {
  final Object? except;

  NewsListLoadingFail({required this.except});
  List<Object?> get pros => [except];
}

// Bloc
class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    on<LoadNewsList>((event, emit) async {
      try {
        if (state is! NewsLoaded) {
          emit(NewsLoading());
        }
        final List<News> newsList = await getNews();
        emit(NewsLoaded(newsList));
      } catch (e) {
        emit(NewsListLoadingFail(except: e));
      } finally {
        event.completer?.complete();
      }
    });

    // on<AddNewsEvent>((event, emit) async{
    //   try {
    //     if (state is! NewsLoaded) {
    //       emit(NewsLoading());
    //     }
    //     final List<News> newsList = await NewsArticle().getNews();
    //     final updatedNewsList = newsList + [event.news];
    //     //final updatedNewsList = [event.news];
    //     emit(NewsLoaded(updatedNewsList));
    //   } catch (e) {
    //     emit(NewsListLoadingFail(except: e));
    //   }
    // });
    on<AddNewsEvent>((event, emit) {
      try {
        if (state is! NewsLoaded) {
          emit(NewsLoading());
        }
        final NewsLoaded currentState = state as NewsLoaded;
        final List<News> updatedNewsList = List.from(
            currentState.newsList); // Создаем копию текущего списка новостей
        updatedNewsList.add(event.news); // Добавляем новую новость
        emit(
          NewsLoaded(
            updatedNewsList,
          ),
        ); // Отправляем обновленный список новостей
      } catch (e) {
        emit(NewsError("Error while adding news: $e"));
      }
    });
    on<CheckBookmark>((event, emit) async {
      try {
        if (state is NewsLoaded) {
          final NewsLoaded currentState = state as NewsLoaded;
          final List<News> updatedNewsList =
              currentState.newsList.map((newsItem) {
            if (newsItem.id == event.news.id) {
              print('bookmarked news found');
              newsItem.bookmarked = true;
            }
            return newsItem;
          }).toList();
          print('bookmarked news emit');
          emit(NewsLoaded(updatedNewsList));
        }
      } catch (e) {
        emit(NewsError("Error while checking bookmark status: $e"));
      }
    });
  }
}
