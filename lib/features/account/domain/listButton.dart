import 'package:flutter/material.dart';

class ListButton extends StatefulWidget {
   const ListButton({super.key});

  @override
  _ListButtonState createState() => _ListButtonState();
}

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
      "Jumpscare",
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

class _ListButtonState extends State<ListButton> {
  Color boxFillColor = const Color(0xFFF6F6F6);
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left:10, right: 10),
        child: TextButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black26,
            minimumSize: const Size.fromHeight(100),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {
            showMenuDialog(context);
          },
          child: const Text(
            "Элемент меню",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
    );
  }
}
