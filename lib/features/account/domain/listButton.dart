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
    return Column(
      children: [
        // Первый контейнер
        Container(
          height: 77,
          width: 323,
          margin: const EdgeInsets.only(left:10, right: 10),
          child: TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFE8E8E8)
                  : const Color(0xFF2C2D2F),
              minimumSize: const Size.fromHeight(100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              showMenuDialog(context);
            },
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF594512),
                  ),
                ),
                const SizedBox(width: 13),
                const Text(
                  "Журнал успеваемости",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 11,),
        Container(
          height: 77,
          width: 323,
          margin: const EdgeInsets.only(left:10, right: 10),
          child: TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFE8E8E8)
                  : const Color(0xFF2C2D2F),
              minimumSize: const Size.fromHeight(100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              showMenuDialog(context);
            },
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF594512),
                  ),
                ),
                const SizedBox(width: 13),
                const Text(
                  "Объявления",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 11,),
        Container(
          height: 77,
          width: 323,
          margin: const EdgeInsets.only(left:10, right: 10),
          child: TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFFE8E8E8)
                  : const Color(0xFF2C2D2F),
              minimumSize: const Size.fromHeight(100),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              showMenuDialog(context);
            },
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF594512),
                  ),
                ),
                const SizedBox(width: 13),
                const Text(
                  "Что-то ещё",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ), 
      ],
    );
  }
}
