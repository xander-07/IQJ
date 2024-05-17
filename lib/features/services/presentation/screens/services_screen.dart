import 'package:flutter/material.dart';
import 'package:iqj/features/messenger/presentation/chat_bubble.dart';
import 'package:iqj/features/messenger/presentation/highlight_chat_bubble.dart';
import 'package:iqj/features/services/presentation/screens/about_screen.dart';
import 'package:iqj/features/services/presentation/screens/services_bubble.dart';
import 'package:iqj/features/services/presentation/screens/services_card.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesBloc();
}

class _ServicesBloc extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Сервисы',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  onSelected: (String choice) {
                    handleMenuSelection(choice, context);
                  },
                  itemBuilder: (BuildContext context) {
                    return {'О программе'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 12),
                            ),
                            Text(choice),
                          ],
                        ),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 12),
            child: Text(
              'Популярные',
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
            height: 120,
            padding: const EdgeInsets.only(bottom: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const <Widget>[
                Padding(padding: EdgeInsets.only(left: 12)),
                ServicesCard(
                  imageUrl:
                      'https://10.img.avito.st/image/1/1.wxHAnLa4b_j2Na39yofaKrw-bf5-Pe3wtjht-nA1Z_J2.oa9XxNKNWKY4MueY4dmqMFRnPZbONlWIAlX4_voHvrs',
                  cardTitle: 'Карта корпусов',
                ),
                ServicesCard(
                  imageUrl:
                      'https://90.img.avito.st/image/1/1.XWTtzra48Y3bZzOI269hXpFs84tTb3OFm2rzj11n-Ydb.vfrRZIloP8OnKy0-eRUAzj1XRZJPysq1-N68BcoQ080',
                  cardTitle: 'Форум',
                ),
                ServicesCard(
                  imageUrl:
                      'https://e3.365dm.com/19/09/2048x1152/skynews-drew-scanlon-blinking-white-guy_4786055.jpg',
                  cardTitle: 'Проверяющие нас люди be like:',
                ),
                ServicesCard(
                  imageUrl:
                      'https://content.imageresizer.com/images/memes/Soyjak-Pointing-meme-5c15oj.jpg',
                  cardTitle:
                      'Фронтеры по сервисам когда увидели что уже всё готово',
                ),
                ServicesCard(
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsZr15qrncD--BpM2Ut7YPBxGNlF1EsIj72qYDCJnmgfrwAHK3ldBpWE1WPlX5sgEGdnI&usqp=CAU',
                  cardTitle: 'Гайд к хорошему API',
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              reverse: true,
              children: const [
                ServicesBubble(
                    icon: Icons.settings_outlined, text: 'Настройки'),
                ServicesBubble(icon: Icons.widgets_rounded, text: 'Виджеты'),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
          Center(
            child: Text(
              'IQJ MIREA версия 0.0.1\nсборка 221803-24042024\nИПТИП/КИП (с) 2024 - Все права защищены.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
        ],
      ),
    );
  }

  void handleMenuSelection(
    String choice,
    BuildContext context,
  ) {
    if (choice == 'О программе') {
       Navigator.of(context).pushNamed(
            'about',);
    }
  }
}
