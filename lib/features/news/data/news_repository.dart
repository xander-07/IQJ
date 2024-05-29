import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iqj/features/news/domain/special_news.dart';
import 'package:iqj/features/news/domain/news.dart';

Future<List<News>> getNews() async {
  final response = await http.get(
    //https://92.63.105.190/news?offset=0&count=200
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/news',
      queryParameters: {'offset': '0', 'count': '20'},
      //TODO сделать offset динамически изменяемым, чтоб получать следующие новости при страницы
    ),
  );
  if (response.statusCode == 200) {
    // final List body = (json.decode(response.body)
    //     as Map<String, dynamic>)['products'] as List;
    // return body.map(
    //   (e) {
    //     final json = e as Map<String, dynamic>;
    //     return News(
    //       id: json['id'] as String,
    //       title: json['header'] as String,
    //       publicationTime: DateTime.parse(['publication_time'] as String),
    //       thumbnail: (json['image_link'] as List<String>)[0],
    //       link: json['link'] as String,
    //     );
    //   },
    // ).toList();
    final dynamic decodedData = json.decode(response.body);
    print(decodedData);
    List<News> newsList = [];
    final List<dynamic> jsonList = decodedData as List;
    // final dynamic hi = jsonList[0];
    // print(hi['image_link'][0]);
    newsList = jsonList.map((json) {
      List<dynamic> dynamicList = json['tags']==null? [] : json['tags'] as List<dynamic>;
      List<String> stringList = dynamicList.map((item) => item.toString()).toList();
      return News(
        id: json['id'].toString(),
        title: json['header'] as String,
        publicationTime: DateTime.parse(json['publication_time'] as String),
        tags: stringList, 
        // thumbnails: json['image_link'] as List<String>,
        thumbnails: json['image_link'] == null
        ? "" as String
        : json['image_link'][0] as String,
        description: "", 
        link: json['link'] as String,
        bookmarked: false,
      );
    }).toList();
    return newsList;
  } else {
    throw Exception(response.statusCode);
  }
}

Future<List<News>> getNewsByHeader(String text) async {
  print(text);
  final response = await http.get(
    //https://92.63.105.190/news?offset=0&count=200
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/news_search',
      queryParameters: {'header': text},
      //TODO сделать offset динамически изменяемым, чтоб получать следующие новости при страницы
    ),
  );
  if (response.statusCode == 200) {
    // final List body = (json.decode(response.body)
    //     as Map<String, dynamic>)['products'] as List;
    // return body.map(
    //   (e) {
    //     final json = e as Map<String, dynamic>;
    //     return News(
    //       id: json['id'] as String,
    //       title: json['header'] as String,
    //       publicationTime: DateTime.parse(['publication_time'] as String),
    //       thumbnail: (json['image_link'] as List<String>)[0],
    //       link: json['link'] as String,
    //     );
    //   },
    // ).toList();
    final dynamic decodedData = json.decode(response.body);
    print(decodedData);
    List<News> newsList = [];
    final List<dynamic> jsonList = decodedData as List;
    // final dynamic hi = jsonList[0];
    // print(hi['image_link'][0]);
    newsList = jsonList.map((json) {
      List<dynamic> dynamicList = json['tags']==null? [] : json['tags'] as List<dynamic>;
      List<String> stringList = dynamicList.map((item) => item.toString()).toList();
      return News(
        id: json['id'].toString(),
        title: json['header'] as String,
        publicationTime: DateTime.parse(json['publication_time'] as String),
        tags: stringList, 
        // thumbnails: json['image_link'] as List<String>,
        thumbnails: json['image_link'] == null
        ? "" as String
        : json['image_link'][0] as String,
        description: "", 
        link: json['link'] as String,
        bookmarked: false,
      );
    }).toList();
    return newsList;
  } else {
    throw Exception(response.statusCode);
  }
}

Future<List<SpecialNews>> getSpecialNews() async {
  final response = await http.get(
    //https://92.63.105.190/news?offset=0&count=200
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/ad',
      // queryParameters: {'offset': '0', 'count': ''},
      //TODO сделать offset динамически изменяемым, чтоб получать следующие новости при страницы
    ),
  );
  if (response.statusCode == 200) {
    // final List body = (json.decode(response.body)
    //     as Map<String, dynamic>)['products'] as List;
    // return body.map(
    //   (e) {
    //     final json = e as Map<String, dynamic>;
    //     return News(
    //       id: json['id'] as String,
    //       title: json['header'] as String,
    //       publicationTime: DateTime.parse(['publication_time'] as String),
    //       thumbnail: (json['image_link'] as List<String>)[0],
    //       link: json['link'] as String,
    //     );
    //   },
    // ).toList();
    print('response 200');
    final dynamic decodedData = json.decode(response.body);
    List<SpecialNews> newsList = [];
    final List<dynamic> jsonList = decodedData as List;
    // final dynamic hi = jsonList[0];
    // print(hi['image_link'][0]);
    newsList = jsonList.map((json) {
      return SpecialNews(
        id: json['id'] as String,
        text: json['content'] as String,
        publishFromTime: DateTime.parse(json['creation_date'] as String),
        publishUntilTime: DateTime.parse(json['expiration_date'] as String),
      );
    }).toList();
    print(newsList.length);
    return newsList;
  } else {
    throw Exception(response.statusCode);
  }
}

// {
//   "header": "Котики собачки",
//   "text": "11 марта РТУ МИРЭА посетила официальная делегация Корейской Народно-Демократической Республики.",
//   "link": "",
//   "image_link": [
//     "https://celes.club/uploads/posts/2022-10/1666897679_16-celes-club-p-smeshnoi-kot-krasivo-16.jpg"
//   ],
//   "tags": [
//     "сотрудникам"
//   ],
//   "author_name": "РТУ МИРЭА",
//   "publication_time": "29.04.2024"
// }

Future<http.Response> postGeneralNews(
  String header,
  String link,
  List<String> thumbnails,
  List<String> tags,
  String publicationTime,
  String text,
  String jwtToken,
) {
  return http.post(
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/api/news',
    ),
    headers: {
      'Authorization': 'Bearer $jwtToken',
    },
    body: jsonEncode({
      "header": header,
      "text": text,
      "link": link,
      "image_link": 
        thumbnails,
      "tags": tags,
      "author_name": "РТУ МИРЭА",
      "publication_time": publicationTime
    }),
  );
}

Future<void> postSpecialNews(
  String text,
  String publishFromTime,
  String publishUntilTime,
) async {
  try {
  final response = await http.post(
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/api/ad',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8', 
    },
    body: jsonEncode(<String, dynamic>{
      'content': text,
      'creation_date': publishFromTime,
      'expiration_date': publishUntilTime,
    }),
  );
  if (response.statusCode == 201) { 
        final responseData = jsonDecode(response.body); 
        print('OK, news posted: $responseData');
      } else { 
        throw Exception('Failed to post data, response ${response.statusCode}'); 
      } 
    } catch (e) { 
      print("error: $e");
    } 
}


// Future<News> getNewsFull(String id) async {
//   final response = await http.get(
//     Uri(
//       scheme: 'https',
//       host: 'mireaiqj.ru',
//       port: 8443,
//       path: '/news_id',
//       queryParameters: {'id': id},
//     ),
//   );
//   if (response.statusCode == 200) {
//     final dynamic decodedData = json.decode(response.body);

//     List<News> newsList = [];

//     if (decodedData is List) {
//       newsList = List<News>.from(decodedData.map((json) => News(
//         description: json['content'] as String,
//         id: json['id'] as String,
//         title: json['header'] as String,
//         publicationTime: DateTime.parse(json['publication_time'] as String),
//         tags: json['tags'][0] as String,
//         thumbnails: (json['image_link'] as List<String>).isNotEmpty 
//           ? json['image_link'][0] as String
//           : '',
//         link: json['link'] as String,
//         bookmarked: false,
//       ),),);
//     } else if (decodedData is Map<String, dynamic>) {
//       // Handle case where decodedData is a Map
//       News news = News(
//         id: decodedData['id'] as String,
//         title: decodedData['header'] as String,
//         publicationTime: DateTime.parse(decodedData['publication_time'] as String),
//         tags: decodedData['tags'][0] as String,
//         thumbnails: decodedData['image_link'][0] as String,
//         link: decodedData['link'] as String,
//         description: decodedData['content'] as String,
//         bookmarked: false,
//       );
//       newsList.add(news);
//     }

//     return newsList[0];
//   } else {
//     throw Exception(response.statusCode);
//   }
// }
