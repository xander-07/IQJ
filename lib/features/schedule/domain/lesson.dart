import 'dart:ui';

class Lesson {
  final String name;
  final String location;
  final String teacher;
  final List<String> groups;
  final int order;
  final String type;

  Lesson({
    required this.name,
    required this.location,
    required this.teacher,
    required this.groups,
    required this.order,
    required this.type,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      name: json['class_name'] as String,
      location: json['class_location'] as String,
      teacher: json['class_teacher_name'] as String,
      groups: json['class_group_ids'] as List<String>? ?? [''],
      order: json['class_count'] as int,
      type: _types[json['class_type'] as String] ?? 'Другое',
    );
  }

  Color getColor() {
    return _lessonColor[type] ?? const Color(0xFF8E959B);
  }
}

final Map<String, String> _types = {
  'ЛК': 'Лекция',
  'ПР': 'Практика',
  'ПР\n\nПР': 'Практика',
  'ЛАБ': 'Лабораторная',
  'ЛАБ\n\nЛАБ': 'Лабораторная',
};

final Map<String, Color> _lessonColor = {
  'Лекция': const Color(0xFF7749F8),
  'Практика': const Color(0xFFAC8EFF),
  'Лабораторная': const Color(0xFFEF9800),
  'Зачет': const Color(0xFF87D07F),
  'Консультация': const Color(0xFF0584FE),
  'Экзамен': const Color(0xFFFF7070),
  'Курсовая': const Color(0xFFFF8EFA),
};
