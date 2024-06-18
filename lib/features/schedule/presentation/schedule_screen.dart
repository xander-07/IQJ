// Увеличивай счетчик каждый раз, когда все ломается:
// 4

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:iqj/features/schedule/presentation/widgets/bottom_sheet.dart';
import 'package:iqj/features/schedule/presentation/widgets/calendar.dart';
import 'package:iqj/features/schedule/presentation/widgets/lesson_list.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool isCompact = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleBloc>(
      create: (context) => ScheduleBloc()
        ..add(const LoadSchedule(criterion: 'group', target: 'ЭФБО-01-23')),
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
                elevation: 0,
                context: context,
                builder: (context) => BlocProvider.value(
                  value: BlocProvider.of<ScheduleBloc>(context),
                  child: Placeholder(),
                  // child: const ScheduleBottomSheet(),
                ),
              ),
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView(
            children: const [
              Calendar(),
              Lessons(),
            ],
          ),
        ),
      ),
    );
  }
}

// MARK: Панель с настройками
// Container _buildBottomSheet(BuildContext context, bool isCompact) {
//   return Container(
//     child: ListView(
//       padding: const EdgeInsets.all(8),
//       children: [
//         Text(
//           'Управление расписанием',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.w700,
//             color: Theme.of(context).colorScheme.onBackground,
//           ),
//         ),
//         ListTile(
//           tileColor: Colors.black38,
//           title: const Text('Компактный вид'),
//           trailing: Switch(
//             value: isCompact,
//             onChanged: (value) {},
//           ),
//           onTap: () => isCompact = !isCompact,
//         ),
//       ],
//     ),
//   );
// }
