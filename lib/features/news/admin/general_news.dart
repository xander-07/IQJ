import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:iqj/features/news/admin/general_news_add_button.dart';
import 'package:iqj/features/news/presentation/screens/search/body_for_tags/body_tags.dart';

class GeneralNews extends StatefulWidget {
  const GeneralNews({super.key});

  @override
  State<GeneralNews> createState() => _GeneralNews();
}

class _GeneralNews extends State<GeneralNews> {
  TextEditingController datePickerController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  File? imageFile;
  String _header = '';
  String _link = '';
  List<String> _thumbnails = [''];
  List<String> _tags = [''];
  String _publicationTime = '';
  String _text = '';

  selectFile() async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1800,
      maxWidth: 1800,
    );

    if (file != null) {
      setState(() {
        imageFile = File(file.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        datePickerController.text = formatter.format(picked);
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    datePickerController.text = DateFormat('dd.MM.yyyy').format(selectedDate);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Создать',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              'Добавить фото',
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
            width: 450,
            height: 192,
            //color: Color.fromRGBO(44, 45, 47, 1),
            //color: Colors.blue,
            margin:  const EdgeInsets.only(top: 10, left: 12, right: 12),
            decoration: BoxDecoration(
              color:  Theme.of(context).colorScheme.onInverseSurface,
              borderRadius: BorderRadius.circular(12),
              // border: Border.all(
              //   width: 1, 
              //   color: Theme.of(context).brightness == Brightness.light
              //     ? const Color(0xFFF6F6F6)
              //     : const Color(0xFF46463C),
              // ),
            ),
            child: ElevatedButton(
              onPressed: () {
                selectFile();
                setState(
                  () {},
                ); // Todo показаать картинку при выборе из галереи
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).colorScheme.onInverseSurface
                  // Theme.of(context).brightness == Brightness.light
                  // ? Color(0xFFE8E8E8)
                  // : Color(0xFF2C2D2F),
                ),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //icon: SvgPicture.asset('assets/icons/news/bookmark2.svg'),
                  //SvgPicture.asset('assets/icons/news/images_add.svg'), // Иконка или изображение
                  Container(
                        height: 39,
                        width: 39,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/news/add_image.png'),
                          ),
                        ),
                      ),
                  const SizedBox(width: 9), // Расстояние между изображением и текстом
                  Text(
                    'Загрузить изображение',
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF000000).withOpacity(0.6)
                      : const Color(0xFFFFFFFF).withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(top: 9, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                three_but(context),
                three_but(context),
                three_but(context),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
            
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 8),
            child: Text(
              'Заголовок',
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
                hintText: "Напишите заголовок здесь...",
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
                  _header = text;
                });
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 12, right: 12),
            
          ),
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
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //padding: EdgeInsets.only(top: 40),
              width: 380,
              height: 467,
              //color: Color.fromRGBO(44, 45, 47, 1),
              //color: Colors.blue,
              margin: const EdgeInsets.only(top: 10, left: 20, right: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    height: 53,
                    width: 315,
                    padding: const EdgeInsets.only(top: 12),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Теги',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 32,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  BodyTagsWidget(),
                ],
              ),
            ),
          ],
        ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 31),
            child: Text(
              'Дата публикации',
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
            height: 52,
            margin: const EdgeInsets.only(top: 10, left: 16, right: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onInverseSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 12,
                  left: 12,
                  right: 40,
                  child: Container(
                    height: 1,
                    color: const Color(0xFF454648),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: datePickerController,
                          decoration: const InputDecoration(
                            hintText: "дд.мм.гггг",
                            border: InputBorder.none,
                            hintFadeDuration: Duration(milliseconds: 100),
                            hintStyle: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                              height: 1,
                              color: Color.fromRGBO(128, 128, 128, 0.6),
                            ),
                          ),
                          onChanged: (text) {
                            _publicationTime = text;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.date_range,
                        ),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
          ),
          SizedBox(height: 8,),

          general_news_add_button(
            context,
            _header,
            _link,
            _thumbnails,
            _tags,
            _publicationTime,
            _text,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12, top: 12),
          ),
        ],
      ),
    );
  }
}

Widget three_but(BuildContext context) {
  return Container(
    width: 99,
    height: 99,
    //color: Color.fromRGBO(44, 45, 47, 1),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onInverseSurface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(width: 1, color: const Color(0xFF46463C)),
    ),
    child: ElevatedButton(
      onPressed: () {
        // Обработчик нажатия кнопки
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          Theme.of(context).colorScheme.onInverseSurface,
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //icon: SvgPicture.asset('assets/icons/news/bookmark2.svg'),
          // SvgPicture.asset(
          //   'assets/icons/news/plus.svg',
          //   width: 32,
          //   height: 32,
          // ), // Иконка или изображение
          Container(
              height: 39,
              width: 39,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/news/add_image.png'),
                ),
              ),
            ),
          const SizedBox(height:  12,),
          Container(
              height: 16,
              width: 16,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/news/plus.png'),
                ),
              ),
            ),
          const SizedBox(width: 8), // Расстояние между изображением и текстом
          // Text('Загрузить изображение',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Color.fromRGBO(255, 255, 255, 0.6),
          //   ),

          // ),
        ],
      ),
    ),
  );
}
