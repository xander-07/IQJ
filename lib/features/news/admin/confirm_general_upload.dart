import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/news/data/news_repository.dart';

void uploadDialog(
  BuildContext context,
  String header,
  String link,
  List<String> thumbnails,
  List<String> tags,
  String publicationTime,
  String text,
  String jwt,
) {
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
  final Widget publishButton = TextButton(
    style: const ButtonStyle(
      overlayColor: MaterialStatePropertyAll(Color.fromARGB(64, 239, 172, 0)),
    ),
    child: const Text(
      "Опубликовать",
      style: TextStyle(
        color: Color.fromARGB(255, 239, 172, 0),
      ),
    ),
    onPressed: () {
      postGeneralNews(header, link, thumbnails, tags, publicationTime, text,jwt);
      Navigator.of(context).pop();
    },
  );

  final AlertDialog alert = AlertDialog(
    title: const Text(
      "Внимание",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: const Text(
      "Вы уверены, что желаете опубликовать эту новость?",
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    surfaceTintColor: Colors.white,
    actions: [
      okButton,
      publishButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
