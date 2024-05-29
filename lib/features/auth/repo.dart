import 'dart:convert';
import 'package:http/http.dart' as http;


Future<http.Response> post_uid(
  String uid
) async {
  return http.post(
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/sign-in',
    ),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'uid' : uid,

    }),
  );
}