import 'package:flutter/material.dart';
import 'package:iqj/features/messenger/presentation/chat_bubble.dart';
import 'package:iqj/features/messenger/presentation/highlight_chat_bubble.dart';
import 'package:iqj/features/services/presentation/screens/services_bubble.dart';
import 'package:iqj/features/services/presentation/screens/services_card.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutBloc();
}

class _AboutBloc extends State<AboutScreen> {
  Widget _buildThumbnailImage() {
    try {
      return SizedBox(
        width: 196,
        height: 196,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.network(
            'https://i.imgur.com/wMZAY5D.png',
            fit: BoxFit.fill,
            height: 256,
            errorBuilder: (
              BuildContext context,
              Object exception,
              StackTrace? stackTrace,
            ) {
              return CircleAvatar(
                radius: 6,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: const Text('IQJ',
                style: TextStyle(
                  fontSize: 48,
                ),),
              );
            },
          ),
        ),
      );
    } catch (e) {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'О программе',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: false,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 12, right: 12),
        child: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildThumbnailImage(),
              const Padding(padding: EdgeInsets.only(bottom: 12)),
              Text(
                'IQJ MIREA',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Разработано с любовью студентами кафедры индустриального программирования ИПТИП для преподавателей <3',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Text(
                'Разработчики',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 32,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Тимлиды',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Row(
                    children: [
                      Text('Александр Павличенко - тимлид тимлидов'),
                    ],
                  ),
                  Text('Лапутин Станислав - дизайн'),
                  Text('Постников Даниил - бекенд API'),
                  Text('Чуев Даниил - бекенд DB'),
                  Text('Погосов Вячеслав - тестирование и QA'),
                  const Padding(padding: EdgeInsets.only(bottom: 12)),
                  Text(
                    'Фронтенд',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Text('Александр Павличенко - тимлид'),
                  Text('Лапутин Станислав'),
                  Text('Дмитрив Денис :)'),
                  Text('Баранова Софья'),
                  Text('Кушаева Варвара'),
                  Text('Хмара Екатерина'),
                  Text('Богданов Максим'),
                  const Padding(padding: EdgeInsets.only(bottom: 12)),
                  Text(
                    'Бекенд',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Text('Постников Даниил - тимлид API'),
                  Text('Павленко Тимофей - API'),
                  Text('Дмитрив Денис - API'),
                  Text('Муртазин Руслан - API'),
                  Text('Ермолина Софья - API'),
                  Text('Чуев Даниил - тимлид DB'),
                  Text('Романов Максим - DB'),
                  Text('Игаев Даниил - DB'),
                  Text('Бондаренко Фёдор - DB'),
                  Text('Петрова Ксения - DB'),
                  const Padding(padding: EdgeInsets.only(bottom: 12)),
                  Text(
                    'Тестировщики и QA',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Text('Погосов Вячеслав - тимлид тестировщиков и QA'),
                  const Padding(padding: EdgeInsets.only(bottom: 12)),
                  Text(
                    'Дизайн приложения',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Text('Лапутин Станислав'),
                  Text('Александр Павличенко'),
                  const Padding(padding: EdgeInsets.only(bottom: 52)),
                  Text(
                    'Подробная информация',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Text(
                      'IQJ MIREA версия 0.0.1\nсборка 221803-24042024\nИПТИП/КИП (с) 2024 - Все права защищены.'),
                ],
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.only(bottom: 12)),
        ],
      ),
      ),
    );
  }
}
