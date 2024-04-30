/*
Базовая единица расписания - пара
(по английски class, но во избижание путаницы назовем lesson),
из пар будет складываться день
*/
class Lesson {
  final String name; // Название предмета
  final String type; // Тип пары (лекция/семинар/лабораторная/...)
  final String classroom; // Аудитория проведения
  final List<String> groups; // Группы, для которых проводится пара
  final String professor; // Преподаватель, который ведет пару

  Lesson({
    required this.name,
    required this.type,
    required this.classroom,
    required this.groups,
    required this.professor,
  });
}
