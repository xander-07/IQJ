import 'package:flutter/material.dart';


typedef void OnEmailChanged(String email);

class EmailField extends StatefulWidget {
  final OnEmailChanged onEmailChanged;
  final TextEditingController controllerEmail;
   const EmailField({required this.onEmailChanged, required this.controllerEmail, super.key});

  @override
  _EmailFieldState createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  Color boxFillColor = const Color(0xFFF6F6F6);
  bool isError = false;
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: widget.controllerEmail,
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
              "Почта",
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
          setState(() {
            _email = value;
            boxFillColor = const Color(0xFFF6F6F6);
          });
          widget.onEmailChanged(value);
        },
        validator: (String? value) {
          // RegExp regEx = RegExp("^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"); // Regex [anything]@[anything].[anything]
          final RegExp regEx = RegExp(r'^[a-zA-Z0-9~`!@#$%^&*()-_=+[\]{}|;:\"<,>.?\/]+@mirea\.ru$'); // Regex [anything]@mirea.ru
          // TODO сделать подсветку ошибок
          if (value == null || value.isEmpty) {
            boxFillColor = Color(0xFFFFE5E5);
            isError = true;
            return "Введите адрес почты.";
          } else if (!regEx.hasMatch(value)) {
            boxFillColor = Color(0xFFFFE5E5);
            isError = true;
            return "Некорректный адрес почты.";
          }
          isError = false;
          return null;
        },
        // onFieldSubmitted: (value) {
        //   widget.onTextSubmitted(_textController.text);
        // },
      ),
    );
  }
}
