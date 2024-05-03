import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/news/admin/general_news.dart';
import 'package:iqj/features/news/admin/special_news.dart';
import 'package:iqj/features/news/presentation/bloc/news_bloc.dart';
import 'package:iqj/features/news/presentation/screens/search/body_for_date/body.dart';

Future<void> admin_button(BuildContext context) async {
  final AlertDialog alert = AlertDialog(
    title: const Row(
      children: [
        Flexible(
          child: Text(
            "Создать новость",
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    surfaceTintColor: Colors.white,
    content: ConstrainedBox(
      constraints: BoxConstraints(),
      child: two_button_add_news(context),
    ),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}



Widget two_button_add_news(BuildContext context) {
  return Wrap(
    children: [
      Container(
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            top: BorderSide(
              color: Color(0xFF48483D),
            ),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 6), 
            SizedBox(
              height: 65,
              width: 325,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Material(
                  color: const Color.fromRGBO(239, 172, 0, 1),
                  shape: const StadiumBorder(),
                  elevation: 5.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpecialNews(),
                        ),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Важную',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 65,
              width: 325,
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                child: Material(
                  color: const Color.fromRGBO(239, 172, 0, 1),
                  shape: const StadiumBorder(),
                  elevation: 5.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GeneralNews()),
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Общую',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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

