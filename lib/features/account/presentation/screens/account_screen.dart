import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/account/domain/listButton.dart';
import 'package:iqj/features/account/domain/logoffButton.dart';
import 'package:iqj/features/account/domain/profileButtons.dart';
import 'package:iqj/features/account/domain/profileInfo.dart';
import 'package:iqj/features/account/domain/profilePicture.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

void showExitDialog(BuildContext context) {
  final Widget okButton = TextButton(
    style: const ButtonStyle(
      overlayColor: MaterialStatePropertyAll(Color.fromARGB(64, 239, 172, 0)),
    ),
    child: const Text(
      "Выйти",
      style: TextStyle(
        color: Color.fromARGB(255, 239, 172, 0),
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  final Widget cancelButton = TextButton(
    style: const ButtonStyle(
      overlayColor: MaterialStatePropertyAll(Color.fromARGB(64, 239, 172, 0)),
    ),
    child: const Text(
      "Закрыть",
      style: TextStyle(
        color: Color.fromARGB(255, 193, 85, 78),
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  final AlertDialog alert = AlertDialog(
    title: const Text(
      "Выйти?",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    content: const Text("Вы действительно желаете выйти?"),
    actions: [
      cancelButton,
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _AccountScreenState extends State<AccountScreen> {
  bool passwordVisible = false;
  String name = '';
  String surname = '';
  String patronymic = '';

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    getUserData();
  }

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          name = doc['name'] as String;
          surname = doc['surname'] as String;
          patronymic = doc['patronymic'] as String;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Личный кабинет',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 12),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16),
                ProfilePicture(),
                SizedBox(width: 24),
                Expanded(
                  child: ProfileInfo(
                    name: name,
                    surname: surname,
                    patronymic: patronymic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16,width: 30,),
            ProfileButtons(name: name, surname: surname, patronymic: patronymic),
            const SizedBox(height: 11), 
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 300,
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        children: const [
                          ListButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const LogoffButton(),
          ],
        ),
      ),
    );
  }
}
