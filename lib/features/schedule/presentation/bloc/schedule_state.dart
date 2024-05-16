import 'package:equatable/equatable.dart';
import 'package:iqj/features/schedule/domain/lesson.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final Map<DateTime, List<Lesson>> schedule;
  final DateTime selectedDay;

  const ScheduleLoaded({required this.schedule, required this.selectedDay});

  @override
  List<Object> get props => [schedule, selectedDay];
}

class ScheduleError extends ScheduleState {
  final String message;

  const ScheduleError({required this.message});

  @override
  List<Object> get props => [message];
}
