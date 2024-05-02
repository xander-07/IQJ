import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget create_body_tags(BuildContext context) {
  TextEditingController TagPickerController = TextEditingController();
  List<String> tags = ["ИПТИП","Физика","Наука"];
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: TagPickerController,
          maxLines: 1,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            hintText: "Поиск...",
            hintFadeDuration: const Duration(milliseconds: 100),
            border: InputBorder.none,
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
                  Icons.search,
                ),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 6, right: 6),
        alignment: Alignment.topLeft,
        //padding: const EdgeInsets.only(bottom: 5),
        
  
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
            const Text(
              'Популярные',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.left,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
  
              children: List.generate(
                tags.length,
                (index) => Container(
                  margin: const EdgeInsets.only(top: 6, right: 6, bottom: 12),
                  height: 35,
                  decoration: BoxDecoration(
                    //borderRadius: BorderRadius.circular(50),
                    borderRadius: BorderRadius.circular(24.0),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: TextButton(
                    onPressed: () {
                      TagPickerController.text = tags[index];
                    },
                    child: Text(
                      tags[index],
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

