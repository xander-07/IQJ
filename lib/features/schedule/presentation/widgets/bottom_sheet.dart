import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_state.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  late ScheduleBloc _bloc;

  @override
  Widget build(BuildContext context) {
    // _bloc = BlocProvider.of<ScheduleBloc>(context);
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      builder: (context, state) => ListView(
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
          ListTile(
            tileColor: Colors.black38,
            title: const Text('Компактный вид'),
            trailing: Switch(
              value: _bloc.isCompact,
              onChanged: (value) {},
            ),
            onTap: () => _bloc.changeCompact(),
          ),
        ],
      ),
    );
  }
}
