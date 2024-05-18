// БЕСПОЛЕЗНО!!! переписать код под использование Map<DateTime, List<Lesson>> вместо List<day>
import 'package:iqj/features/schedule/domain/lesson.dart';

// Дни состоят из пар и имеют свой порядковый номер внутри недели
class Day {
  final DateTime date; // Номер дня внутри недели
  final List<Lesson> lessons;
  //final String date; // дата 'дд.мм.гггг'
  Day(this.date, {required this.lessons});
}

class DayOff extends Day {
  DayOff(super.date, {required super.lessons});
}
