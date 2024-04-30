// Абстрактный класс для событий, будет расширен по потребности
abstract class ScheduleEvent {
  const ScheduleEvent();
}

class LoadSchedule extends ScheduleEvent {} // Загрузка расписания из базы

class SelectSchedule extends ScheduleEvent {} // Выбор расписания (конкретного преподавателя, группы или аудитории)

class SelectDay extends ScheduleEvent{
  DateTime selectedDay;
  SelectDay(this.selectedDay) ;
} // Выбор дня для расписания
