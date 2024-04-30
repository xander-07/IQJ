import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Create_body_date extends StatefulWidget {
  const Create_body_date({super.key});

  @override
  State<Create_body_date> createState() => _Create_body_date();
}

class _Create_body_date extends State<Create_body_date> {
  String _text = '';
  String _publishFromTime = '';
  String _publishUntilTime = '';

  TextEditingController fromDatePickerController = TextEditingController();
  TextEditingController toDatePickerController = TextEditingController();
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  Future<void> _selectFromDate(BuildContext context) async {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedFromDate) {
      setState(() {
        fromDatePickerController.text = formatter.format(picked);
        selectedFromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(2015, 8), //selectedFromDate,
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedToDate) {
      setState(() {
        toDatePickerController.text = formatter.format(picked);
        selectedToDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 325,
      height: 130,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 12, top: 6),
                child: Text(
                  "С:",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: fromDatePickerController,
                    decoration: InputDecoration(
                      hintText: "дд.мм.гггг",
                      hintFadeDuration: const Duration(milliseconds: 100),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      suffixIcon: SizedBox(
                        child: IconButton(
                          icon: const Icon(
                            Icons.date_range,
                          ),
                          onPressed: () {
                            _selectFromDate(context);
                          },
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _publishFromTime = text;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 12, top: 6),
                child: Text(
                  "По:",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(top: 10, left: 12, right: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: toDatePickerController,
                    decoration: InputDecoration(
                      hintText: "дд.мм.гггг",
                      hintFadeDuration: const Duration(milliseconds: 100),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      hintStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        height: 1.5,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      suffixIcon: SizedBox(
                        child: IconButton(
                          icon: const Icon(
                            Icons.date_range,
                          ),
                          onPressed: () {
                            _selectToDate(context);
                          },
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _publishUntilTime = text;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
