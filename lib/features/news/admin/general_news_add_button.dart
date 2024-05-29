import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'confirm_general_upload.dart';

Widget general_news_add_button(
  BuildContext context,
  String header,
  String link,
  List<String> thumbnails,
  List<String> tags,
  String publicationTime,
  String text,
  String jwt,
) {
  return Container(
    width: 151,
    height: 54,
    padding: const EdgeInsets.only(left: 90, right: 90),
    margin: const EdgeInsets.only(top: 10),
    child: ElevatedButton(
      onPressed: () {
        uploadDialog(
            context, header, link, thumbnails, tags, publicationTime, text,jwt);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(239, 172, 0, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35),
        ),
      ),
      child: const Text(
        'Добавить',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
