import 'package:flutter/material.dart';
import 'package:iqj/features/account/domain/editButton.dart';
import 'package:iqj/features/account/domain/listButton.dart';
import 'package:iqj/features/account/domain/logoffButton.dart';
import 'package:iqj/features/account/domain/mailButton.dart';
import 'package:iqj/features/account/domain/profileInfo.dart';
import 'package:iqj/features/account/domain/profilePicture.dart';
// import 'package:iqj/main.dart';

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
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
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
      // Аватарка пользовтеля, ФИО и почта
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 16,),
                ProfilePicture(),
                SizedBox(width: 24),
                ProfileInfo(),
              ],
            ),
            // Кнопка редактирования и почты
            const Column(
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    EditButton(),
                    MailButton(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 11), // расстояние между кнопками и контейнером "Элемент меню"
            // TODO переделать
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
            // кнопка выхода
            const LogoffButton(),
          ],
        ),
      ),
    );
  }
}
