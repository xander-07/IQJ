import 'package:equatable/equatable.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class LoadSchedule extends ScheduleEvent {
  final String criterion;
  final String target;

  const LoadSchedule({
    required this.criterion,
    required this.target,
  });

  @override
  List<Object> get props => [criterion, target];
}

class ChangeSelectedDay extends ScheduleEvent {
  final DateTime selectedDay;

  ChangeSelectedDay({required this.selectedDay}){
      print('selected day $selectedDay');
  }

  @override
  List<Object> get props => [selectedDay];
}
