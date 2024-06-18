import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iqj/features/schedule/domain/lesson.dart';

// Время начала отсчета
final DateTime _startDate = DateTime(2024, 2, 5);

Future<Map<DateTime, List<Lesson>>> fetchSchedule(
  String criterion,
  String target,
) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/lessons',
      queryParameters: {'criterion': criterion, 'value': target},
    ),
  );

  if (response.statusCode == 200) {
    final body = json.decode(response.body) as List<dynamic>;
    final Map<DateTime, List<Lesson>> schedule = {};

    for (final element in body) {
      final item = element as Map<String, dynamic>;
      final lesson = Lesson.fromJson(item);
      // Генерируем ключ DateTime для расписания с учётом начального дня
      final weekday = item['class_weekday'] as int;
      final week = item['class_week'] as int;
      DateTime date;
      for (var i = 0; i <= 8; i++) {
        date = _startDate
            .add(Duration(days: (week + 2 * i - 1) * 7 + (weekday - 1))); //ужс
        print(date);
        (schedule[date] ??= []).add(lesson);
      }
    }

    return schedule;
  } else {
    throw Exception('Ошибка запроса, код: ${response.statusCode}');
  }
}
