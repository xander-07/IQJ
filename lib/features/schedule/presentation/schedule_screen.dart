import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:iqj/features/schedule/presentation/widgets/calendar.dart';
import 'package:iqj/features/schedule/presentation/widgets/lesson_list.dart';

// Всю логику новостей нужно сесть и хорошо обдумать, прежде чем писать этот код

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleBloc()..add(LoadSchedule()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Расписание',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            IconButton(
              onPressed: () => DoNothingAction(),
              icon: const Icon(Icons.more_vert),
            ),
            // SvgPicture.asset(
            //   'assets/schedule/dots.svg',
            //   width: 4.17,
            //   height: 16,
            // ),
          ],
        ),
        body: ListView(
          children: const <Widget>[
            Calendar(),
            Lessons(),
          ],
        ),
      ),
    );
  }
}
