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
      type: _types[json['class_type'] as String]?? 'Другое',
    );
  }
}

Map<String, String> _types = {
  'ЛК' : 'Лекция',
  'ПР' : 'Практика',
};
