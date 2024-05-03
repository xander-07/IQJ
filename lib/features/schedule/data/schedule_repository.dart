import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iqj/features/schedule/domain/day.dart';

// TODO:

Future<List<Day>> fetchSchedule(String criterion, String target) async {
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
    final body = json.decode(response.body) as List<Map<String, dynamic>>;
    List<Day> schedule = [];
    body.map(
      (e) {
        DateTime _date = DateTime(2024, );
      },
    );
    return schedule;
  } else {
    throw Exception(response.statusCode);
  }
}

// TODO:
// MARK: кэширование расписания
void cacheSchedule() {}
