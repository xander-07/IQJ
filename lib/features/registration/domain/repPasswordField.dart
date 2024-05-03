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
        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          label: Container(
            child: Text(
              "Повторите пароль",
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
          boxFillColor = Theme.of(context).colorScheme.onError;
          setState(() {
            _password = value;
            boxFillColor = Theme.of(context).colorScheme.onError;
          });
          widget.onPasswordChanged(value);
        },
        validator: (value) {
          // TODO сделать подсветку ошибок
          if (value == null) {
            boxFillColor = Theme.of(context).colorScheme.onError;
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
