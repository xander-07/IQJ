import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:iqj/features/schedule/presentation/widgets/lesson_card.dart';

class Lessons extends StatefulWidget {
  const Lessons({super.key});

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const LinearProgressIndicator();
        } else if (state is ScheduleError) {
          return Text(
            "Произошла ошибка при загрузке расписания: ${state.message}",
          );
        } else if (state is ScheduleLoaded) {
          // if (state.schedule[state.selectedDay]?.isEmpty ?? true) {
          //   return const Center(
          //     child: Text("Выходной"),
          //   );
          // }
          // return Column(
          //   children: List.generate(
          //     state.schedule[state.selectedDay]!.length,
          //     (index) => LessonCard(
          //       state.schedule[state.selectedDay]![index],
          //       index,
          //       false,
          //     ),
          //   ),
          // );
          return state.schedule.containsKey(state.selectedDay)
              ? Column(
                  children: List.generate(
                    state.schedule[state.selectedDay]!.length,
                    (index) {
                      final lesson = state.schedule[state.selectedDay]![index];
                      return LessonCard(lesson, index, false);
                    },
                  ),
                )
              : const Center(
                  child: Text('Выходной', style: TextStyle(fontSize: 24)),
                );
        } else {
          return const Text('Unhandled state');
        }
      },
    );
  }
}
