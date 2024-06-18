import 'package:flutter/material.dart';
import 'package:iqj/features/schedule/domain/lesson.dart';

// TODO: Добавить отображение нескольких групп
// TODO: Исправить переполнение строки названия

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final bool isCompact;
  const LessonCard(this.lesson, this.isCompact, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.onInverseSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 11, right: 11, bottom: 11,),
        child: Column(
          children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    lesson.name,
                    maxLines: 2,
                    style: TextStyle(
                      color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                    ),
                  ),
                  titleAlignment: ListTileTitleAlignment.top,
                  subtitle: Row(
                    children: [
                      Container(
                        height: 7,
                        width: 7,
                        decoration: BoxDecoration(
                          color: lesson.getColor(),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(lesson.type),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${lesson.order} пара",
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _lessonTime[lesson.order - 1],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  titleTextStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ] +
              // MARK: Компактная часть
              (isCompact
                  ? []
                  : [
                      Divider(
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withAlpha(144),
                      ),
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                              ),
                              children: [
                                TextSpan(
                                  text: lesson.groups[0],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface,
                              ),
                              children: [
                                TextSpan(
                                  text: lesson.location,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
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
      surfaceTintColor: Colors.transparent,
      borderOnForeground: false,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        child: Stack(
          children: [
            Text(
              '${index + 1} пара',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color:
                    Theme.of(context).colorScheme.onBackground.withAlpha(176),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _lessonTime[index],
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onBackground.withAlpha(140),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Список времени, доступ по индексу пары
final List<String> _lessonTime = [
  '9:00 - 10:30',
  '10:40 - 12:10',
  '12:40 - 14:10',
  '14:20 - 15:50',
  '16:20 - 17:50',
  '18:00 - 19:30',
];
