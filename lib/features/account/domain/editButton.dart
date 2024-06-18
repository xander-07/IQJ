import 'package:flutter/material.dart';

void showMenuDialog(BuildContext context) {
  final Widget okButton = TextButton(
    style: const ButtonStyle(
      overlayColor: MaterialStatePropertyAll(Color.fromARGB(64, 239, 172, 0)),
    ),
    child: const Text(
      "Закрыть",
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
      "Не реализовано",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: const Text("Todo"),
    actions: [
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

class EditButton extends StatefulWidget {
  const EditButton({super.key});

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: const EdgeInsets.only(left: 5), 
      child: SizedBox(
        width: 158,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: const Color(0xFFEFAC00),
              padding: const EdgeInsets.symmetric(horizontal: 10,),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35),
              ),
            ),
            onPressed: () {
              showMenuDialog(context);
            },
            child: const SizedBox(
              width: 136,
              child: Text(
                "Редактировать",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
