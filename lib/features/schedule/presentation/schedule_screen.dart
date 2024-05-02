import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:iqj/features/schedule/presentation/widgets/calendar.dart';
import 'package:iqj/features/schedule/presentation/widgets/lesson_list.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScheduleBloc()..add(LoadSchedule()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          scrolledUnderElevation: 0,
          toolbarHeight: 72,
          title: Text(
            'Расписание',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            IconButton(
              onPressed: () => showModalBottomSheet<void>(
                backgroundColor: Theme.of(context).colorScheme.background,
                context: context,
                builder: (context) => ListView(
                  children: [
                    ElevatedButton(
                      onPressed: () => DoNothingAction(),
                      child: Text(
                        'Тут будут настройки расписания',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.more_vert),
            ),
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
