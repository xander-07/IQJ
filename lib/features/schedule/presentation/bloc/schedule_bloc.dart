import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/data/schedule_repository.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_state.dart';
 // Функция для парсинга расписания

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  bool isCompact = false;

  ScheduleBloc() : super(ScheduleInitial()) {
    on<LoadSchedule>(_onLoadSchedule);
    on<ChangeSelectedDay>(_onChangeSelectedDay);
  }

  Future<void> _onLoadSchedule(LoadSchedule event, Emitter<ScheduleState> emit) async {
    emit(ScheduleLoading());
    try {
      final schedule = await fetchSchedule(event.criterion, event.target);
      emit(ScheduleLoaded(schedule: schedule, selectedDay: DateTime.now()));
    } catch (e) {
      emit(ScheduleError(message: e.toString()));
    }
  }

  void changeCompact(){
    isCompact = !isCompact;
  }

  void _onChangeSelectedDay(ChangeSelectedDay event, Emitter<ScheduleState> emit) {
    if (state is ScheduleLoaded) {
      final currentState = state as ScheduleLoaded;
      emit(ScheduleLoaded(schedule: currentState.schedule, selectedDay: DateUtils.dateOnly(event.selectedDay)));
    }
  }
}
