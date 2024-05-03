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
      focusedDay: _selectedDay, // День, на который сделан фокус
      firstDay: DateTime(2023, 1, 1), // Первый день
      lastDay: DateTime(2030, 1, 1), // Последний день
      calendarFormat: _format, // Формат календаря
      onFormatChanged: (CalendarFormat format) {
        setState(() {
          _format = format;
        });
      }, // Изменение формата календаря
      startingDayOfWeek: StartingDayOfWeek.monday, // Первый день недели
      daysOfWeekVisible: true, // Видимость дней недели
      onDaySelected: (DateTime selectDay, DateTime focusDay) {
        setState(() {
          _selectedDay = selectDay;
          _focusedDay = focusDay;
        });
        BlocProvider.of<ScheduleBloc>(context).add(SelectDay(selectDay));
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(_selectedDay, date);
      }, // Проверка, является ли день выбранным
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true, // Выделение сегодняшнего дня
        defaultDecoration: const BoxDecoration(
          shape: BoxShape.circle,
        ), // Декорация дня по умолчанию
        selectedDecoration: const BoxDecoration(
          color: Color(0xaaEF9800),
          shape: BoxShape.circle,
        ), // Декорация выбранного дня
        todayDecoration: const BoxDecoration(
          color: Color(0xFFD1D1D1),
          shape: BoxShape.circle,
        ),
        selectedTextStyle: const TextStyle(
            color: Color(0xFFF8F8F8)), // Стиль текста выбранного дня
        todayTextStyle: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer), // Декорация сегодняшнего дня
        defaultTextStyle: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer), // Стиль текста дня по умолчанию
        weekendTextStyle: TextStyle(
            color: Theme.of(context)
                .colorScheme
                .onPrimaryContainer), // Стиль текста выходного дня
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ), // Декорация выходного дня
      ),
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

class CustomCalendarBuilder extends CalendarBuilders {
  Widget buildDefaultCell({
    required BuildContext context,
    required DateTime date,
    required List<dynamic> events,
    bool isSelected = false,
    bool isToday = false,
    bool isInSelectedRange = false,
    bool isInRange = false,
    bool isInCurrentMonth = true,
  }) {
    final defaultDecoration = BoxDecoration(
      shape: BoxShape.circle,
      color: const Color(0xFFEFAC00).withOpacity(0.56),
    );

    final selectedDecoration = BoxDecoration(
      color: const Color(0xFFEFAC00).withOpacity(0.17),
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFEFAC00).withOpacity(0.17),
          blurRadius: 5,
        ),
      ],
    );

    return Container(
      constraints: const BoxConstraints(
        minWidth: 50,
        minHeight: 50,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Container(
              decoration: selectedDecoration,
            ),
          Container(
            decoration: defaultDecoration,
            child: Center(
              child: Text(
                date.day.toString(),
                style: isSelected
                    ? const TextStyle(color: Color(0xFF191919))
                    : const TextStyle(color: Color(0xFF191919)),
              ),
            ),
          ),
          if (date.weekday == DateTime.saturday)
            Positioned(
              right: 0,
              bottom: 0,
              child: Icon(
                Icons.circle,
                size: 8,
                color: const Color(0xFFEFAC00).withOpacity(0.56),
              ),
            ),
        ],
      ),
    );
  }
}
