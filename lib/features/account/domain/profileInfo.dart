import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  Color boxFillColor = const Color(0xFFF6F6F6);

  String name = '';
  String email = '';
  String password = '';

  User? user;

  Future<Map<String, dynamic>?> getUserDataByUid(String uid) async {
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
                name = snapshot.data?['display_name'] as String;
                email = snapshot.data?['email'] as String;
                // password = snapshot.data?['password'] as String;
                return Container(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light
                                ? const Color(0xFF000000)
                                : Colors.white,
                          fontSize: 20,
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
