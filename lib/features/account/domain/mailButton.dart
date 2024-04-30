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
      
    },
  );

  final AlertDialog alert = AlertDialog(
    title: const Text(
      "Тут должно быть что-то про почту",
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

class MailButton extends StatefulWidget {
  const MailButton({super.key});

  @override
  _MailButtonState createState() => _MailButtonState();
}



class _MailButtonState extends State<MailButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
        child: TextButton(
          style: ElevatedButton.styleFrom(
            //alignment: Alignment.center,
            backgroundColor: const Color.fromARGB(255, 239, 172, 0),
            padding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          onPressed: () {
            showMenuDialog(context);
          },
          child: const Text(
            "Почта",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 21,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
    );
  }

}