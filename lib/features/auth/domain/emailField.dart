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
        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          label: Container(
            child: Text(
              "Почта",
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontSize: 24,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
              width: 2,
            ),
          ),
          errorStyle: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
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
            boxFillColor = Theme.of(context).colorScheme.onError;
          });
          widget.onEmailChanged(value);
        },
        validator: (String? value) {
          // RegExp regEx = RegExp("^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"); // Regex [anything]@[anything].[anything]
          final RegExp regEx = RegExp(r'^[a-zA-Z0-9~`!@#$%^&*()-_=+[\]{}|;:\"<,>.?\/]+@mirea\.ru$'); // Regex [anything]@mirea.ru
          // TODO сделать подсветку ошибок
          if (value == null || value.isEmpty) {
            boxFillColor = Theme.of(context).colorScheme.onError;
            isError = true;
            return "Введите адрес почты.";
          } else if (!regEx.hasMatch(value)) {
            boxFillColor = Theme.of(context).colorScheme.onError;
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
