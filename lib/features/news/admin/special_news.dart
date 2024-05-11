import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iqj/features/news/admin/special_news_add_button.dart';
import 'package:intl/intl.dart';

class SpecialNews extends StatefulWidget {
  const SpecialNews({super.key});

  @override
  State<SpecialNews> createState() => _SpecialNews();
}

class _SpecialNews extends State<SpecialNews> {
  String _text = '';
  String _publishFromTime = '';
  String _publishUntilTime = '';
  String formattedFromDate = '';
  String formattedUntilDate = '';

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
    // Todo: Здесь при выборе даты публикации "с" после сегодняшней ломается выбор даты "по"
    //fromDatePickerController.text =
    //  DateFormat('dd.MM.yyyy').format(selectedFromDate);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // Заголовок экрана
      appBar: AppBar(
        title: Text(
          'Создать',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: ListView(
        children: [
          // Блок предпросмотра новости
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text(
              'Предпросмотр новости',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w700,

              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).brightness == Brightness.light
                ? const Color(0xFFFFECB4)
                : const Color(0xFF594512),
            ),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: SvgPicture.asset(
                                    'assets/icons/schedule/warning.svg',
                                    semanticsLabel: 'warning',
                                    height: 14,
                                    width: 16,
                                    allowDrawingOutsideViewBox: true,
                                    // color: const Color.fromARGB(255, 239, 172, 0),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    _text,
                                    softWrap: true,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      
                                      color: Color.fromARGB(255, 255, 166, 0),
                                    ),
                                  ),
                                ),
                               IconButton(
                                  onPressed: () {
                                    setState(() {});
                                  },
                                  icon: Padding(
                                    padding: const EdgeInsets.only(left: 21.0), 
                                    child:
                                     SvgPicture.asset(
                                      width: 16,
                                      height: 16,
                                      'assets/icons/news/close.svg',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: const Divider(
              thickness: 1,
              color: Color.fromRGBO(209, 209, 209, 0.12),
            ),
          ),
          // Блок редактора новости
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12),
            child: Text(
              'Текст новости',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            //height: 128,
            margin:
                const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onInverseSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                hintText: "Напишите новость здесь...",
                hintFadeDuration: Duration(milliseconds: 100),
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0,
                  height: 1.5,
                  color: Color.fromRGBO(128, 128, 128, 0.6),
                ),
              ),
              onChanged: (text) {
                setState(() {
                  _text = text;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            child: const Divider(
              thickness: 1,
              color: Color.fromRGBO(209, 209, 209, 0.12),
            ),
          ),
          // Блок настройки срока показа новости
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 12),
            child: Text(
              'Срок',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 30,
                alignment: Alignment.bottomLeft,
                margin: const EdgeInsets.only(left: 8, top: 6, right: 8),
                child: Text(
                  "С",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF191919)
                      : const Color(0xFFE8E8E8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 40,
                        left: 10,
                        right: 0,
                        child: Container(
                          height: 1,
                          color: const Color(0xFF2C2D2F),
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: fromDatePickerController,
                              decoration: InputDecoration(
                                hintText: "дд.мм.гггг",
                                hintFadeDuration: const Duration(milliseconds: 100),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,vertical: 10),
                                hintStyle: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.0,
                                  height: 2.5,
                                  color: Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFF191919)
                                    : const Color(0xFFE8E8E8),
                                ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  DateFormat outputFormat =
                                      DateFormat("yyyy-MM-dd'T'00:00:00.000'Z'");
                                  formattedFromDate = outputFormat.format(DateFormat('dd.MM.yyyy').parse(text));
                                  _publishFromTime = text;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0, bottom: 13), 
                            child: IconButton(
                              icon: const Icon(
                                Icons.date_range,
                              ),
                              onPressed: () {
                                _selectFromDate(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
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
                margin: const EdgeInsets.only(left: 8, top: 6, right: 8),
                child: Text(
                  "По",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF191919)
                      : const Color(0xFFE8E8E8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 40, 
                        left: 10,
                        right: 0,
                        child: Container(
                          height: 1,
                          color: const Color(0xFF2C2D2F),
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
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
                                  height: 2.5,
                                  color: Theme.of(context).brightness == Brightness.light
                                    ? const Color(0xFF191919)
                                    : const Color(0xFFE8E8E8),
                                ),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  DateFormat outputFormat =
                                      DateFormat("yyyy-MM-dd'T'00:00:00.000'Z'");
                                  formattedUntilDate = outputFormat.format(DateFormat('dd.MM.yyyy').parse(text));
                                  _publishUntilTime = text;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5.0, bottom: 13), 
                            child: IconButton(
                              icon: const Icon(
                                Icons.date_range,
                              ),
                              onPressed: () {
                                _selectToDate(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Три кнопки быстрой установки срока показа новости
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5, left: 12),
                  height: 35,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(50),
                    borderRadius: BorderRadius.circular(24.0),
                    color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFFB3B3B3)
                      : const Color(0xFF454648),
                  ),
                  child: TextButton(
                    onPressed: () {
                      final DateTime now = DateTime.now();
                      final DateTime to =
                          DateTime(now.year, now.month, now.day + 1);
                      fromDatePickerController.text =
                          DateFormat('dd.MM.yyyy').format(now);
                      toDatePickerController.text =
                          DateFormat('dd.MM.yyyy').format(to);
                    },
                    child: const Text(
                      "1 день",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 35,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(50),
                    borderRadius: BorderRadius.circular(24.0),
                    color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFFB3B3B3)
                      : const Color(0xFF454648),
                  ),
                  child: TextButton(
                    onPressed: () {
                      final DateTime now = DateTime.now();
                      final DateTime to =
                          DateTime(now.year, now.month, now.day + 3);
                      fromDatePickerController.text =
                          DateFormat('dd.MM.yyyy').format(now);
                      toDatePickerController.text =
                          DateFormat('dd.MM.yyyy').format(to);
                    },
                    child: const Text(
                      "3 дня",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:  Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.0),
                    color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFFB3B3B3)
                      : const Color(0xFF454648),
                  ),
                  child: TextButton(
                    onPressed: () {
                      final DateTime now = DateTime.now();
                      final DateTime to =
                          DateTime(now.year, now.month, now.day + 7);
                      fromDatePickerController.text =
                          DateFormat('dd.MM.yyyy').format(now);
                      toDatePickerController.text =
                          DateFormat('dd.MM.yyyy').format(to);
                    },
                    child: const Text(
                      "Неделя",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.only(left: 10, top: 42, bottom: 25),
            child: Text(
              "Эта новость будет показана всем преподавателям.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ),
          special_news_add_button(
            context,
            _text,
            formattedFromDate,
            formattedUntilDate,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12, top: 12),
          ),
        ],
      ),
    );
  }
}
