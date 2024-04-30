// Абстрактный класс для состояний, будет расширен по потребности
import 'package:iqj/features/schedule/domain/day.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoadingFailed extends ScheduleState {
  final Object except;
  ScheduleLoadingFailed({required this.except});
}

class ScheduleLoaded extends ScheduleState {
  final Day activeDay; // выбранный в данный момент день

  ScheduleLoaded({required this.activeDay});
}
