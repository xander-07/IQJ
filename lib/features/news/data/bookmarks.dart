import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider {
  static const _bookmarkKey = 'bookmarks';

  static Future<List<String>> getBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_bookmarkKey) ?? [];
  }

  static Future<void> toggleBookmark(String newsId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookmarks = await getBookmarks();
    
    if (bookmarks.contains(newsId)) {
      bookmarks.remove(newsId);
    } else {
      bookmarks.add(newsId);
    }

    await prefs.setStringList(_bookmarkKey, bookmarks);
  }
}
