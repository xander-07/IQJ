import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:iqj/features/schedule/presentation/widgets/calendar.dart';
import 'package:iqj/features/schedule/presentation/widgets/lesson_list.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              elevation: 0,
              context: context,
              builder: (context) => _buildBottomSheet(context),
            ),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: BlocProvider<ScheduleBloc>(
        create: (context) => ScheduleBloc()..add(const LoadSchedule(criterion: 'group', target: 'ЭФБО-03-23')),
        child: ListView(
          children: const <Widget>[
            Calendar(),
            Lessons(),
          ],
        ),
      ),
    );
  }
}

// MARK: Панель с настройками
Container _buildBottomSheet(BuildContext context) {
  return Container(
    child: ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Text(
          'Управление расписанием',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      ],
    ),
  );
}
