import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/news/presentation/screens/search/body_for_date/body.dart';

void searchdata(BuildContext context) {
  final Widget okButton = TextButton(
    style: ButtonStyle(
      overlayColor: MaterialStatePropertyAll(
        Theme.of(context).colorScheme.error.withAlpha(32),
      ),
    ),
    child: Text(
      "Отмена",
      style: TextStyle(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  final Widget searchButton = TextButton(
    style: const ButtonStyle(
      overlayColor: MaterialStatePropertyAll(Color.fromARGB(64, 239, 172, 0)),
    ),
    child: const Text(
      "Поиск",
      style: TextStyle(
        color: Color.fromARGB(255, 239, 172, 0),
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  final AlertDialog alert = AlertDialog(
    title: const Text(
      "Дата",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    surfaceTintColor: Colors.white,
    content: Create_body_date(),
    actions: [
      okButton,
      searchButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
