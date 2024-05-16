import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    _bloc = BlocProvider.of<ScheduleBloc>(context);
    return content();
  }

  Widget content() {
    return TableCalendar<Lesson>(
      rowHeight: 47, // Высота строки
      focusedDay: _focusedDay, // День, на который сделан фокус
      firstDay: DateTime(2024), // Первый день
      lastDay: DateTime(2030), // Последний день
      calendarFormat: _format, // Формат календаря
      locale: 'ru_RU',
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

      eventLoader: (day) {
        if (_bloc.state is ScheduleLoaded) {
          return (_bloc.state as ScheduleLoaded).schedule[day] ?? [];
        }
        return [];
      },

      // MARK: cтиль календаря
      calendarStyle: CalendarStyle(
        selectedDecoration: const BoxDecoration(
          color: Color(0xAAEF9800),
          shape: BoxShape.circle,
        ), // Декорация выбранного дня
        todayDecoration: const BoxDecoration(
          color: Color(0xFFD1D1D1),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
          color: Color(0xFFF8F8F8),
        ), // Стиль текста выбранного дня
        todayTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ), // Декорация сегодняшнего дня
        defaultTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ), // Стиль текста дня по умолчанию
        weekendTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ), // Стиль текста выходного дня
      ),
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
      // MARK: Билдеры календаря
      calendarBuilders: CalendarBuilders(
        // номер недели
        weekNumberBuilder: (context, weekNumber) {
          final studyWeekNumber = weekNumber -
              _firstStudyWeekStart.difference(DateTime(2024)).inDays ~/ 7;
          return studyWeekNumber > 0
              ? Center(
                  child: Text(
                    '$studyWeekNumber',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withAlpha(140),
                    ),
                  ),
                )
              : const SizedBox();
        },
        // обычный день
        defaultBuilder: (context, day, focusedDay) {
          return null;
        },
        // выбранный день
        selectedBuilder: (context, day, focusedDay) => null,
      ),
    );
  }
}
