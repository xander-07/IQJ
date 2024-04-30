import 'package:flutter/material.dart';

class PatronymicField extends StatefulWidget {
  final Function(String) onTextSubmitted;
   const PatronymicField({required this.onTextSubmitted});

  @override
  _PatronymicFieldState createState() => _PatronymicFieldState();
}

class _PatronymicFieldState extends State<PatronymicField> {
  final TextEditingController _textController = TextEditingController();
  Color boxFillColor = const Color(0xFFF6F6F6);
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: _textController,
        keyboardType: TextInputType.emailAddress,
        cursorColor: const Color.fromARGB(255, 239, 172, 0),
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFF2E2E2E),
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: boxFillColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          label: Container(
            child: const Text(
              "Отчество",
              style: TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 24,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE8E8E8),
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE8E8E8),
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFDC0000),
              width: 2,
            ),
          ),
          errorStyle: const TextStyle(
            color: Color(0xFFDC0000),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 239, 172, 0),
              width: 2,
            ),
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.only(right: 5),
            child: Icon(isError ? Icons.warning_amber_outlined : null),
          ),
        ),
        onChanged: (value) {
          boxFillColor = const Color(0xFFF6F6F6);
        },
        validator: (String? value) {
          // TODO сделать подсветку ошибок
          if (value == null || value.isEmpty) {
            boxFillColor = Color(0xFFFFE5E5);
            isError = true;
            return "Введите отчество.";
          }
          isError = false;
          return null;
        },
        onFieldSubmitted: (value) {
          widget.onTextSubmitted(_textController.text);
        },
      ),
    );
  }
}
