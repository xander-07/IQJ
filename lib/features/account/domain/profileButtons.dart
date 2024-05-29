import 'package:flutter/material.dart';
import 'package:iqj/features/account/domain/editbutton.dart';
import 'package:iqj/features/account/domain/mailbutton.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    Key? key,
    required this.name,
    required this.surname,
    required this.patronymic,
  }) : super(key: key);

  final String name;
  final String surname;
  final String patronymic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        EditButton(
          name: name,
          surname: surname,
          patronymic: patronymic,
        ),
        const SizedBox(width: 16),
        MailButton(),
      ],
    );
  }
}
