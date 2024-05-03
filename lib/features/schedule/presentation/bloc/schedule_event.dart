// Абстрактный класс для событий, будет расширен по потребности
abstract class ScheduleEvent {
  const ScheduleEvent();
}

class LoadSchedule extends ScheduleEvent {} // Загрузка расписания из базы

class SelectSchedule extends ScheduleEvent {
  final String mode;
  final String target;
  const SelectSchedule(this.mode, this.target);
} // Выбор расписания (конкретного преподавателя, группы или аудитории)

class SelectDay extends ScheduleEvent {
  final DateTime selectedDay;
  const SelectDay(this.selectedDay);
} // Выбор дня для расписания
