import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/data/fake_schedule.dart'; // Заглушка!!!
import 'package:iqj/features/schedule/domain/day.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  DateTime currentTime = DateTime.now();
  late List<Day> scheduleList;

  ScheduleBloc() : super(ScheduleInitial()) {
    // MARK: Загрузка расписания
    on<LoadSchedule>((_, emit) async {
      try {
        if (state is! ScheduleLoading) {
          emit(ScheduleLoading());
        }
        scheduleList = await getSchedule();
        final today =
            DateTime(currentTime.year, currentTime.month, currentTime.day);
        emit(
          ScheduleLoaded(
            activeDay: scheduleList.firstWhere(
              (day) => day.date == today,
              orElse: () => DayOff(today),
            ),
          ),
        );
      } catch (e) {
        emit(ScheduleLoadingFailed(except: e));
      }
    });
    // MARK: выбор расписания
    on<SelectSchedule>((event, emit) {
      if (state is! ScheduleLoaded) add(LoadSchedule());
    });
    // MARK: выбор дня
    on<SelectDay>(
      (event, emit) async {
        try {
          emit(
            ScheduleLoaded(
              activeDay: scheduleList.firstWhere(
                (day) =>
                    day.date ==
                    DateTime(
                      event.selectedDay.year,
                      event.selectedDay.month,
                      event.selectedDay.day,
                    ),
                orElse: () => DayOff(event.selectedDay),
              ),
            ),
          );
        } catch (e) {
          emit(ScheduleLoadingFailed(except: e));
        }
      },
    );
  }
}
