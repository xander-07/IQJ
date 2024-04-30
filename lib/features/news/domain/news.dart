class News {
  final String id;
  final String title;
  // final List<String> thumbnails;
  final String thumbnails;
  //final List<String> tags; ////////////// РАСКОММЕНТИРОВАТЬ КОГДА АПИ БУДЕТ ГОТОВО
  final String tags;
  final DateTime publicationTime;
  final String description;
  final String link;
  late final bool bookmarked;
  News({
    required this.id,
    required this.title,
    required this.thumbnails,
    required this.tags, ////////////// РАСКОММЕНТИРОВАТЬ КОГДА АПИ БУДЕТ ГОТОВО
    required this.publicationTime,
    required this.description,
    required this.link,
    required this.bookmarked,
  });
}
