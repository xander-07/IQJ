import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:iqj/features/schedule/domain/lesson.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_state.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final _firstStudyWeekStart = DateTime(2024, 2, 5);
  CalendarFormat _format = CalendarFormat.month; // Формат календаря
  DateTime _selectedDay = DateTime.now(); // Выбранный день
  DateTime _focusedDay = DateTime.now(); // День, на который сделан фокус
  late ScheduleBloc _bloc;
  List<Lesson> _selectedLessons(DateTime day) {
    final state = _bloc.state;
    if (state is ScheduleLoaded) {
      return state.schedule[day] ?? [];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ScheduleBloc>(context);
    return BlocBuilder<ScheduleBloc, ScheduleState>(builder: content);
  }

  Widget content(BuildContext context, ScheduleState state) {
    return TableCalendar<Lesson>(
      rowHeight: 68, // Высота строки
      focusedDay: _focusedDay, // День, на который сделан фокус
      firstDay: DateTime(2024), // Первый день
      lastDay: DateTime(2030), // Последний день
      locale: 'ru_RU',
      daysOfWeekVisible: false, // Спрятать стандартный ряд дней недели
      calendarFormat: _format, // Формат календаря
      onFormatChanged: (CalendarFormat format) {
        setState(() {
          _format = format;
        });
      }, // Изменение формата календаря
      startingDayOfWeek: StartingDayOfWeek.monday, // Первый день недели
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        _bloc.add(
          ChangeSelectedDay(selectedDay: DateUtils.dateOnly(selectedDay)),
        );
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(_selectedDay, date);
      }, // Проверка, является ли день выбранным

      // MARK: стиль заголовка календаря
      headerStyle: HeaderStyle(
        formatButtonShowsNext: false,
        formatButtonDecoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.onBackground),
          borderRadius: BorderRadius.circular(20),
        ),
        formatButtonTextStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        titleTextStyle:
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Месяц',
        CalendarFormat.twoWeeks: '2 недели',
        CalendarFormat.week: 'Неделя',
      },
      weekNumbersVisible: true,

      calendarBuilders: CalendarBuilders(
        weekNumberBuilder: _weekNumberBuilder,
        defaultBuilder: _defaultBuilder,
        selectedBuilder: _selectedBuilder,
        todayBuilder: _todayBuilder,
        outsideBuilder: _defaultBuilder,
      ),
    );
  }

  // MARK: билдеры
  // номер недели
  Widget? _weekNumberBuilder(BuildContext context, int weekNumber) {
    final studyWeekNumber = weekNumber -
        _firstStudyWeekStart.difference(DateTime(2024)).inDays ~/ 7;
    return studyWeekNumber > 0
        ? Center(
            child: Text(
              '$studyWeekNumber',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withAlpha(studyWeekNumber.isEven ? 216 : 140),
              ),
            ),
          )
        : const SizedBox();
  }

  // сегодняшний день
  Widget? _todayBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) =>
      Stack(
        alignment: Alignment.center,
        children: [
          if (day.day == 1 ||
              day.add(const Duration(days: 1)).day ==
                  1)
            Container(
              height: 68,
              width: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF545448).withAlpha(day.day == 1 ? 255 : 0),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          Container(
            height: 66,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
              child: Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFF454648),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('EE', 'ru_RU').format(day),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (_bloc.state is ScheduleLoaded)
                    Wrap(
                      children: List.generate(
                        _selectedLessons(day).length,
                        (index) => Container(
                          height: 2,
                          width: 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedLessons(day)[index].getColor(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );
  // выбранный день
  Widget? _selectedBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) =>
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 70,
            width: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF545448).withAlpha(day.day == 1 ? 255 : 0),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            height: 66,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
              child: Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC48F05),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('EE', 'ru_RU').format(day),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (_bloc.state is ScheduleLoaded)
                    Wrap(
                      children: List.generate(
                        _selectedLessons(day).length,
                        (index) => Container(
                          height: 2,
                          width: 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedLessons(day)[index].getColor(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );

  //остальные дни
  Widget? _defaultBuilder(
    BuildContext context,
    DateTime day,
    DateTime focusedDay,
  ) =>
      Stack(
        alignment: Alignment.center,
        children: [
          if (day.day == 1 ||
              day.add(const Duration(days: 1)).day ==
                  1)
            Container(
              height: 70,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF545448).withAlpha(day.day == 1 ? 255 : 0),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          Container(
            height: 66,
            width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
              child: Column(
                children: [
                  Container(
                    height: 32,
                    width: 32,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('EE', 'ru_RU').format(day),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (_bloc.state is ScheduleLoaded)
                    Wrap(
                      children: List.generate(
                        _selectedLessons(day).length,
                        (index) => Container(
                          height: 2,
                          width: 2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _selectedLessons(day)[index].getColor(),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      );

  // Загрузчик событий дня
}
