import 'package:flutter/material.dart';

class EditButton extends StatefulWidget {
  final String name;
  final String surname;
  final String patronymic;

  const EditButton({super.key, required this.name, required this.surname, required this.patronymic});

  @override
  _EditButtonState createState() => _EditButtonState();
}

class _EditButtonState extends State<EditButton> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _patronymicController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _surnameController = TextEditingController(text: widget.surname);
    _patronymicController = TextEditingController(text: widget.patronymic);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _patronymicController.dispose();
    super.dispose();
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
        updateUserDataInFirebase();
        Navigator.of(context).pop();
      },
    );

    final AlertDialog alert = AlertDialog(
      title: const Text(
        "Редактировать ФИО",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "Имя"),
          ),
          TextField(
            controller: _surnameController,
            decoration: const InputDecoration(hintText: "Фамилия"),
          ),
          TextField(
            controller: _patronymicController,
            decoration: const InputDecoration(hintText: "Отчество"),
          ),
        ],
      ),
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

  void updateUserDataInFirebase() {
    // TODO
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
