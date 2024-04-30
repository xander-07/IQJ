import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:iqj/features/registration/domain/passwordField.dart';


typedef void OnPasswordChanged(String password);

class RepPasswordField extends StatefulWidget {
  final OnPasswordChanged onPasswordChanged;
  const RepPasswordField({required this.onPasswordChanged, super.key});

  @override
  _RepPasswordFieldState createState() => _RepPasswordFieldState();
}

class _RepPasswordFieldState extends State<RepPasswordField> {
  bool _ishidden = true;
  Color boxFillColor = const Color(0xFFF6F6F6);
  String _password = '';

  void _toggleVisibility() {
    setState(
      () {
        _ishidden = !_ishidden;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: TextFormField(
        obscureText: _ishidden,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: const Color.fromARGB(255, 239, 172, 0),
        style: const TextStyle(
          fontSize: 24,
          color: Color(0xFF2E2E2E),
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: boxFillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          label: Container(
            child: const Text(
              "Повторите пароль",
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
            child: IconButton(
            icon: Icon(_ishidden
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,),
            onPressed: () {
              setState(
                () {
                  _ishidden = !_ishidden;
                },
              );
            },
          ),
        ),
        ),
        onChanged: (value) {
          boxFillColor = const Color(0xFFF6F6F6);
          setState(() {
            _password = value;
            boxFillColor = const Color(0xFFF6F6F6);
          });
          widget.onPasswordChanged(value);
        },
        validator: (value) {
          // TODO сделать подсветку ошибок
          if (value == null) {
            boxFillColor = const Color(0xFFFFE5E5);
            return 'Введите пароль';
          // } else if (value != confirmPass) {
          //   boxFillColor = const Color(0xFFFFE5E5);
          //   return 'Пароли не совпадают.';
          }
          return null;
        },
      ),
    );
  }
}
