import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/account/domain/mailButton.dart';
import 'package:iqj/features/account/domain/profileButtons.dart';
import 'package:iqj/features/account/domain/editbutton.dart';

class ProfileInfo extends StatefulWidget {
  final String name;
  final String surname;
  final String patronymic;

  const ProfileInfo({
    Key? key,
    required this.name,
    required this.surname,
    required this.patronymic,
  }) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  Color boxFillColor = const Color(0xFFF6F6F6);

  String email = '';
  String password = '';

  User? user;

  Future<Map<String, dynamic>?>? getUserDataByUid(String uid) async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (documentSnapshot.exists) {
        final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        return data;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // name = widget.name;
    // surname = widget.surname;
    // patronymic = widget.patronymic;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        user = snapshot.data;
        if (snapshot.hasError) {
          return const Text('Ошибка при получении \n данных пользователя');
        } else if (snapshot.hasData) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: getUserDataByUid(user!.uid), // Получаем данные пользователя по его uid
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Ошибка при получении \n данных пользователя');
              } else if (snapshot.hasData) {
                // name = snapshot.data?['name'] as String;
                // surname = snapshot.data?['surname'] as String;
                // patronymic = snapshot.data?['patronymic'] as String;
                email = snapshot.data?['email'] as String;
                // password = snapshot.data?['password'] as String;
                return Container(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                                ? const Color(0xFF000000)
                                : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.surname,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                                ? const Color(0xFF000000)
                                : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.patronymic,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                                ? const Color(0xFF000000)
                                : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          height: 1,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 7,),
                      Text(
                        email,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                                ? const Color(0xFF000000)
                                : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20, width: 20,),
                      // ProfileButtons(
                      //   name: name,
                      //   surname: surname,
                      //   patronymic: patronymic,
                      // ),
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
