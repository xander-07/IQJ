import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/domain/day.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:iqj/features/schedule/presentation/widgets/lesson_card.dart';

class Lessons extends StatelessWidget {
  const Lessons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) {
        if (state is ScheduleLoading) {
          return const CircularProgressIndicator();
        } else if (state is ScheduleLoadingFailed) {
          return Text("Произошла ошибка при загрузке расписания: ${state.except}");
        } else if (state is ScheduleLoaded) {
          if (state.activeDay is WorkingDay) {
            final WorkingDay activeDay = state.activeDay as WorkingDay;
            return Column(
              children: List.generate(
                activeDay.lessons.length,
                (index) => activeDay.lessons[index] == null
                    ? EmptyLessonCard(index)
                    : LessonCard(activeDay.lessons[index]!, index),
              ),
              // shrinkWrap: true,
              // itemCount: activeDay.lessons.length,
              // itemBuilder: (context, index) => activeDay.lessons[index] == null
              //     ? EmptyLessonCard(index)
              //     : LessonCard(activeDay.lessons[index]!, index),
              // separatorBuilder: (_, __) => const SizedBox(
              //   height: 12,
              // ),
            );
            // } else if (state.activeDay is DayOff) {
            //   return const Center(child: Text('Выходной!'));
          } else {
            return const Center(child: Text('Выходной!'));
          }
        } else {
          return const Text('Unhandled state');
        }
      },
    );
  }
}
