import 'package:flutter/material.dart';
import 'package:iqj/features/welcome/presentation/welcome.dart'; 

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
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, 'welcome'); 
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

class LogoffButton extends StatefulWidget {
  const LogoffButton({super.key});

  @override
  _LogoffButtonState createState() => _LogoffButtonState();
}



class _LogoffButtonState extends State<LogoffButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 45.0),
      child: Container(
        height: 60,
        width: 189,
        child: TextButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC1554E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
            ),
          ),
          onPressed: () {
            showExitDialog(context);
          },
          child: const Text(
            "Выйти",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
