import 'package:iqj/features/schedule/domain/lesson.dart';

// Дни состоят из пар и имеют свой порядковый номер внутри недели
abstract class Day {
  final DateTime date; // Номер дня внутри недели
  //final String date; // дата 'дд.мм.гггг'
  Day._(this.date); //this.date);
}

// Рабочий день
// В теории, можно добавить массив с типами пар (лекции/практики и т.п.) для удобства использования в календаре
class WorkingDay extends Day {
  final List<Lesson?> lessons; // Список пар в этот день

  WorkingDay(
    super.date, {
    required this.lessons,
    //required String date,
  }) : super._(); //date);
}

// Выходной день
class DayOff extends Day {
  DayOff(super.date) : super._();
}
