import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateWithLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy.MM.dd').format(now);

    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Row(
        children: [
          Text(
            "18 Февраля",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Expanded(
            child: Container(
              height: 1.0,
              margin: EdgeInsets.symmetric(horizontal: 8),
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
