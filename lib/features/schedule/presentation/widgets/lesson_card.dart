import 'package:flutter/material.dart';
import 'package:iqj/features/schedule/domain/lesson.dart';

// TODO: Доделать, очевидно :/
// TODO: Добавить отображение нескольких групп
// TODO: Исправить переполнение строки названия
// TODO: Исправить размер текста

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final int index;
  const LessonCard(this.lesson, this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MARK: Название пары
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      children: [
                        Text(
                          lesson.name,
                          maxLines: 2,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                            color: _lessonColor[lesson.type] ??
                                const Color(0xFF8E959B),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(lesson.type),
                      ],
                    ),
                  ],
                ),

                // MARK: Время пары
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${index + 1} пара",
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      _lessonTime[index],
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Theme.of(context).colorScheme.outline),
            // MARK: Нижние строки
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(Icons.groups, size: 18),
                const SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    text: 'Группа: ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191919)
                    ),
                    children: [
                      TextSpan(
                        text: lesson.groups[0],
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Icon(
                  Icons.location_pin,
                  size: 18,
                ),
                const SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    text: 'Аудитория: ',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF191919)
                    ),
                    children: [
                      TextSpan(
                        text: lesson.classroom,
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: Для окон
class EmptyLessonCard extends StatelessWidget {
  final int index;
  const EmptyLessonCard(this.index, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onInverseSurface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${index + 1} пара",
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              Text(
                _lessonTime[index],
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Список времени, доступ по индексу пары
// Так действительно проще
final List<String> _lessonTime = [
  '9:00 - 10:30',
  '10:40 - 12:10',
  '12:40 - 14:10',
  '14:20 - 15:50',
  '16:20 - 17:50',
  '18:00 - 19:30',
];

// Цвета, которые используем для пар
final Map<String, Color> _lessonColor = {
  'Лекция': const Color(0xFF7749F8),
  'Практика': const Color(0xFFAC8EFF),
  'Лабораторная': const Color(0xFFEF9800),
  'Зачет': const Color(0xFF87D07F),
  'Консультация': const Color(0xFF0584FE),
  'Экзамен': const Color(0xFFFF7070),
  'Курсовая': const Color(0xFFFF8EFA),
};
