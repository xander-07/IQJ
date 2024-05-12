import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/news/admin/general_news.dart';
import 'package:iqj/features/news/admin/special_news.dart';
import 'package:iqj/features/news/presentation/bloc/news_bloc.dart';
import 'package:iqj/features/news/presentation/screens/search/body_for_date/body.dart';

Future<void> admin_button(BuildContext context) async {
  final AlertDialog alert = AlertDialog(
    titlePadding: const EdgeInsets.only(left: 30, top: 24, right: 24),
    title: Column(
      children: [
        const Row(
          children: [
            Flexible(
              child: Text(
                " Создать новость",
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const Divider(
          color: Color(0xFF48483D),
          thickness: 1,
          height: 8,
        ),
        //SizedBox(height: 8),
        two_button_add_news(context), 
      ],
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    surfaceTintColor: Colors.white,
    content: const SizedBox.shrink(),
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
      Padding(
        padding: const EdgeInsets.only(top: 10), 
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            children: [
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
              const SizedBox(
                height: 6,
              )
            ],
          ),
        ),
      ),
    ],
  );
}

