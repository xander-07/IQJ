import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iqj/features/messenger/domain/user.dart';

Future<List<User>> getUsers() async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/api/firebase/list_user',
    ),
  );
  if (response.statusCode == 200) {
    final dynamic decodedData = json.decode(response.body);
    print(decodedData);
    List<User> userList = [];
    final List<dynamic> jsonList = decodedData as List;
    userList = jsonList.map((json) {
      return User(
        uid: json['uid'].toString(),
        email: json['email'].toString(),
        passwordHash: json['password_hash'].toString(),
        passwordSalt: json['password_salt'].toString(),
        displayName: json['display_name'].toString(),
        phoneNumber: json['phone_bumber'].toString(),
        lastSignInTime: DateTime.parse(json['last_sign_in_time'] as String),
        creationTime: DateTime.parse(json['creation_time'] as String),
      );
    }).toList();
    return userList;
  } else {
    throw Exception(response.statusCode);
  }
}