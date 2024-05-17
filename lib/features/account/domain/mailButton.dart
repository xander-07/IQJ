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
      //margin: const EdgeInsets.only(left: 5), 
      child: SizedBox(
        width: 158,
        height: 47,
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            style: ElevatedButton.styleFrom(
              alignment: Alignment.center,
              backgroundColor: const Color(0xFFEFAC00),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                "Почта",
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