import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/domain/lesson.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:iqj/features/schedule/presentation/widgets/lesson_card.dart';

class Lessons extends StatefulWidget {
  const Lessons({super.key});

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  // TODO: добавить возможность переключения в приложении
  final isCompact = false; // Компактный вид

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const LinearProgressIndicator();
        } else if (state is ScheduleError) {
          return Text(
            "Произошла ошибка: ${state.message}",
          );
        } else if (state is ScheduleLoaded) {
          if (state.selectedDay.weekday == DateTime.sunday) {
            return const Center(
              child: Text('Выходной', style: TextStyle(fontSize: 24)),
            );
          }
          return state.schedule.containsKey(state.selectedDay)
              ? Column(
                  children: List.generate(6, (index) {
                    final lessons = state.schedule[state.selectedDay]!;
                    final lesson = lessons.firstWhere(
                      (lesson) => lesson.order - 1 == index,
                      orElse: () => Lesson(
                        name: '',
                        location: '',
                        teacher: '',
                        groups: [],
                        type: '',
                        order: -1,
                      ),
                    );

                    if (lesson.order != -1) {
                      return LessonCard(lesson, false);
                    } else {
                      return EmptyLessonCard(index);
                    }
                  }),
                )
              : const Center(
                  child: Text('Нет информации', style: TextStyle(fontSize: 24)),
                );
        } else {
          return const Text('Unhandled state');
        }
      },
    );
  }
}
