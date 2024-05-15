import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_bloc.dart';
import 'package:iqj/features/schedule/presentation/bloc/schedule_event.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _format = CalendarFormat.month; // Формат календаря
  DateTime _selectedDay = DateTime.now(); // Выбранный день
  DateTime _focusedDay = DateTime.now(); // День, на который сделан фокус

  @override
  Widget build(BuildContext context) {
    return content();
  }

  Widget content() {
    return TableCalendar(
      rowHeight: 47, // Высота строки
      focusedDay: _focusedDay, // День, на который сделан фокус
      firstDay: DateTime(2024), // Первый день
      lastDay: DateTime(2030), // Последний день
      calendarFormat: _format, // Формат календаря
      onFormatChanged: (CalendarFormat format) {
        setState(() {
          _format = format;
        });
      }, // Изменение формата календаря
      startingDayOfWeek: StartingDayOfWeek.monday, // Первый день недели
      daysOfWeekVisible: true, // Видимость дней недели
      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        BlocProvider.of<ScheduleBloc>(context).add(ChangeSelectedDay(selectedDay: DateUtils.dateOnly(selectedDay)));
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(_selectedDay, date);
      }, // Проверка, является ли день выбранным
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
        formatButtonVisible: true,
        formatButtonShowsNext: false,
        formatButtonDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(5.0),
        ),
        formatButtonTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Месяц',
        CalendarFormat.twoWeeks: '2 недели',
        CalendarFormat.week: 'Неделя',
      },
    );
  }
}
