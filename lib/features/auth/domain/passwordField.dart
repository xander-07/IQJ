import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controllerPassword;
  const PasswordField({super.key, required this.controllerPassword,});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _ishidden = true;
  Color boxFillColor = const Color(0xFFF6F6F6);

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
        controller: widget.controllerPassword,
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          label: Container(
            child: Text(
              "Пароль",
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
              icon: Icon(
                _ishidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
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
        },
        validator: (value) {
          // TODO сделать подсветку ошибок
          if (value == null) {
            boxFillColor = Theme.of(context).colorScheme.onError;
            return 'Введите пароль';
          } else if (value.length < 3) {
            boxFillColor = Theme.of(context).colorScheme.onError;
            return 'Пароль должен содержать минимум 3 символа.';
          }
          return null;
        },
      ),
    );
  }
}
