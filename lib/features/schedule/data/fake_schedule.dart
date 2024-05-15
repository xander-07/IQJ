import 'package:iqj/features/schedule/domain/day.dart';
import 'package:iqj/features/schedule/domain/lesson.dart';

// Массив, служащий заглушкой для расписания.
// Не стесняйтесь изменять по мере надобности.
/*
В список так же можно (и нужно) добавлять и объекты
класса Day, т.к. он - дочерний для класса day
*/

Future<Map<DateTime, List<Lesson>>> getScheduleMap() async {
  final Map<DateTime, List<Lesson>> map = { for (final d in schedule) d.date : d.lessons };
  map.forEach((key, value) {print('$key: $value\n');});
  return map;
  // {
    // DateTime(2024, 5, 9): [
    //   Lesson(
    //     name: "Физика",
    //     type: "Лекция",
    //     location: "A-15 (В-78)",
    //     groups: [
    //       "ЭФБО-01-23",
    //       "ЭФБО-02-23",
    //       "ЭФБО-03-23",
    //       "ЭФБО-04-23",
    //       "ЭФБО-05-23",
    //     ],
    //     teacher: "Сафронов А. А.",
    //   ),
    // ],
  // }; // конвертация в словарь [дата : день]
}

Future<List<Day>> getSchedule() async {
  return schedule;
}

/* пример ответа от апи:
[
  {
    "class_id": 0,
    "class_group_ids": [
      "ЭФБО-01-23"
    ],
    "class_teacher_id": "Сафронов А.А.",
    "class_count": 1,
    "class_weekday": 1,
    "class_week": 1,
    "class_name": "кр. 1 н. Физика",
    "class_type": "ЛК",
    "class_location": "ауд. А-15 (В-78)"
  }
]
*/

// неактуально
final List<Day> schedule = [
  Day(
    DateTime(2024, 5, 1),
    lessons: [
      Lesson(
        name: "Физика",
        type: "Лекция",
        location: "A-15 (В-78)",
        groups: [
          "ЭФБО-01-23",
          "ЭФБО-02-23",
          "ЭФБО-03-23",
          "ЭФБО-04-23",
          "ЭФБО-05-23",
        ],
        teacher: "Сафронов А. А.",
      ),
      Lesson(
        name: 'Физика',
        type: 'Практика',
        location: 'А-107-1 (В-78)',
        groups: [
          'ЭФБО-01-23',
        ],
        teacher: 'Кто-то',
      ),
      Lesson(
        name: 'Еще одна скучная пара',
        type: 'Практика',
        location: 'А-107-1 (В-78)',
        groups: [
          'ЭФБО-01-23',
        ],
        teacher: 'Кто-то',
      ),
    ],
  ),
  Day(
    DateTime(2024, 5, 2),
    lessons: [
      Lesson(
        name: "Физика",
        type: "Лекция",
        location: "A-63 (МП-1)",
        groups: [
          "ЭФБО-01-23",
          "ЭФБО-02-23",
          "ЭФБО-03-23",
          "ЭФБО-04-23",
          "ЭФБО-05-23",
        ],
        teacher: "Я не помню",
      ),
      Lesson(
        name: 'Физика',
        type: 'Практика',
        location: 'А-107-1 (В-78)',
        groups: [
          'ЭФБО-01-23',
        ],
        teacher: 'Кто-то',
      ),
      Lesson(
        name: 'Еще одна скучная пара',
        type: 'Практика',
        location: 'А-107-1 (В-78)',
        groups: [
          'ЭФБО-01-23',
        ],
        teacher: 'Кто-то',
      ),
    ],
  ),
  Day(
    DateTime(2024, 5, 3),
    lessons: [
      Lesson(
        name: "Физика",
        type: "Лекция",
        location: "A-15 (В-78)",
        groups: [
          "ЭФБО-01-23",
          "ЭФБО-02-23",
          "ЭФБО-03-23",
          "ЭФБО-04-23",
          "ЭФБО-05-23",
        ],
        teacher: "Сафронов А. А.",
      ),
      Lesson(
        name: 'Физика',
        type: 'Практика',
        location: 'А-107-1 (В-78)',
        groups: [
          'ЭФБО-01-23',
        ],
        teacher: 'Кто-то',
      ),
      Lesson(
        name: 'Еще одна скучная пара',
        type: 'Практика',
        location: 'А-107-1 (В-78)',
        groups: [
          'ЭФБО-01-23',
        ],
        teacher: 'Кто-то',
      ),
    ],
  ),
  Day(
    DateTime(2024, 5, 30),
    lessons: [
      Lesson(
        name: 'Алгоритмы',
        type: 'Практика',
        location: 'A-220 (В-78)',
        groups: ['ЭФБО-01-23'],
        teacher: 'Яковлев М. С.',
      ),
    ],
  ),
];
