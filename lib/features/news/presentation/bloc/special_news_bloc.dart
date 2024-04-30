import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/news/data/news_repository.dart';
import 'package:iqj/features/news/domain/special_news.dart';

abstract class SpecialNewsLoadEvent {}

class FetchSpecialNews extends SpecialNewsLoadEvent {}

class LoadSpecialNewsLoadList extends SpecialNewsLoadEvent{
  final Completer? completer;
  LoadSpecialNewsLoadList({required this.completer});

  List<Object?> get props => [completer];
  
}


// States
abstract class SpecialNewsLoadState {}

class SpecialNewsLoadInitial extends SpecialNewsLoadState {}

class SpecialNewsLoadLoading extends SpecialNewsLoadState {}

class SpecialNewsLoadLoaded extends SpecialNewsLoadState {
  final List<SpecialNews> newsList;

  SpecialNewsLoadLoaded(this.newsList);
}

class SpecialNewsLoadError extends SpecialNewsLoadState {
  final String errorMessage;

  SpecialNewsLoadError(this.errorMessage);
}

class SpecialNewsLoadListLoadingFail extends SpecialNewsLoadState{
  final Object? except;

  SpecialNewsLoadListLoadingFail({required this.except});
  List<Object?> get pros => [except];
}

class SpecialNewsBloc extends Bloc<SpecialNewsLoadEvent, SpecialNewsLoadState>{
  SpecialNewsBloc(): super(SpecialNewsLoadInitial()){
    print('special news initial load');
    // Сюда не заходит почему-то
    on<LoadSpecialNewsLoadList>((event,emit) async{
      print('test');
      try {
        if (state is! SpecialNewsLoadLoaded) {
          print('emit special news loading');
          emit(SpecialNewsLoadLoading());
        }
        final List<SpecialNews> news = await getSpecialNews();
        //print(newsList);
        print('emit special news loaded');
        emit(SpecialNewsLoadLoaded(news));
      } catch (e) {
        print('emit special news load failed: $e');
        emit(SpecialNewsLoadListLoadingFail(except: e));
      } finally {
        print('emit special news complete');
        event.completer?.complete();
      }
    });
  }
}
