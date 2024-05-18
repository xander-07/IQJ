import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BodyTagsWidget extends StatefulWidget {
  @override
  _BodyTagsWidgetState createState() => _BodyTagsWidgetState();
}

class _BodyTagsWidgetState extends State<BodyTagsWidget> {
  TextEditingController TagPickerController = TextEditingController();
  List<String> addedTags = ["ИПТИП","Опрос"];
  List<String> popularTags = ["ИПТИП","Опрос","Физика", "Философия", "Конкурс"];

  void _addTag() {
    if (TagPickerController.text.isNotEmpty) {
      setState(() {
        addedTags.add(TagPickerController.text);
        TagPickerController.clear();
      });
    }
  }

  void _removeTag(int index) {
    setState(() {
      addedTags.removeAt(index);
    });
  }

  Color getTagColor(int index) {
    return index < 2 ? Theme.of(context).colorScheme.primary : Theme.of(context).brightness == Brightness.light ?Color(0xFFB3B3B3) :Color(0xFF454648);
  }

  Widget getTagSvg(int index) {
    return index < 2
        ? SvgPicture.asset(
            'assets/icons/news/close.svg',
            height: 12,
            width: 12,
            color: const Color(0xFFFFFFFF),
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 12, top: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TagPickerController,
                  maxLines: 1,
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFEFAC00)), // Custom focused border color
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.light
                      ? const Color(0xFF191919)
                      : const Color(0xFFE8E8E8)
                      ), 
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    hintText: "Добавить тег...",
                    hintFadeDuration: const Duration(milliseconds: 100),
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      height: 1.5,
                      color: Color(0xFF838383),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              // Remove GestureDetector from here
              Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/news/plus.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 327,
                child: Divider(
                  thickness: 1,
                  height: 24,
                  color: Color(0xFFE8E8E8),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Добавленные',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 6, right: 6),
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 2.0,
                runSpacing: 2.0,
                children: List.generate(
                  addedTags.length,
                  (index) => IntrinsicWidth(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: TextButton(
                              onPressed: () {
                                TagPickerController.text = addedTags[index];
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      addedTags[index],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:   Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    const SizedBox(height: 2, width: 5,),
                                    GestureDetector(
                                      onTap: () {
                                        _removeTag(index);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/icons/news/close.svg',
                                        height: 12,
                                        width: 12,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ),
              ),
              Container(
                child: Divider(
                  thickness: 1,
                  height: 24,
                  color: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFF191919)
                  : const Color(0xFFE8E8E8)
                  
                ),
              ),
              //const SizedBox(height: 8), 
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'Популярные',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Wrap(
                spacing: 2.0,
                runSpacing: 2.0,
                children: List.generate(
                  popularTags.length,
                  (index) => IntrinsicWidth(
                        child: Container(
                          margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24.0),
                            color: getTagColor(index),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: TextButton(
                              onPressed: () {
                                TagPickerController.text = popularTags[index];
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      popularTags[index],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:   Color(0xFFFFFFFF),
                                      ),
                                    ),
                                    const SizedBox(height: 2, width: 5,),
                                    getTagSvg(index),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                ),
              ),
              Divider(
                thickness: 1,
                height: 24,
                color: Theme.of(context).brightness == Brightness.light
                  ? const Color(0xFF191919)
                  : const Color(0xFFE8E8E8)
              ),
              const SizedBox(height: 6,),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 48,
                  width: 120,
                  child: ElevatedButton(
                    onPressed: _addTag,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(239, 172, 0, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35),
                      ),
                    ),
                    child: const Text(
                      'Добавить',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                      textAlign: TextAlign.center
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
