import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> sendData(String email, String password) async{
  final userUpdateUrl = Uri.parse('https://mireaiqj.ru:8443/sign-up');
  final body = json.encode({'email': "test2", 'password': password});

  final response = await http.post(userUpdateUrl, headers: {'Content-Type': 'application/json'}, body: body);

  if (response.statusCode == 200) {
    print("VSE OKEY");
  } else {
    print('Failed to send data: ${response.statusCode}');
    return null;
  }
 }