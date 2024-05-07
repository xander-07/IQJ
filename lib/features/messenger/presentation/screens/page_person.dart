import 'package:flutter/material.dart';

class Page_person extends StatefulWidget {
  const Page_person({super.key});
  @override
  State<StatefulWidget> createState() => _Page_person();
}

class _Page_person extends State<Page_person> {
  String? user_name = "..."; // Объявление user_name как поле класса
  String? image_url = "";
  String uid = "";

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null, "Check args");
    Map<String, dynamic> help = args as Map<String, dynamic>;
    user_name = help["name"] as String?; // Присваивание значения переменной user_name
    image_url = help["url"] as String?;
    uid = help["uid"] as String;

    setState(() {});
    super.didChangeDependencies();
  }

  Widget _buildThumbnailImage(String image_url) {
    try {
      return Container(
        padding: EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 117,
          height: 117,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.network(
              image_url,
              fit: BoxFit.fill,
              height: 200,
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) {
                return CircleAvatar(
                  radius: 6,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  child: const Text('A'),
                );
              },
            ),
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
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Действия для кнопки с логотипом шестеренки (настройки)
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // Действия для кнопки с логотипом трех вертикальных точек
            },
          ),
        ],
      ),
      body: Align(
         alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Элементы начинаются с верхней части экрана
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            _buildThumbnailImage(image_url??""),
            SizedBox(height: 10), // Отступ между картинкой и названием
            Text(user_name ?? "",
            style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontSize: 25,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,),
            Text("4 участника",
            style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),) // Отображение названия user_name
          ],
        ),
      ),
    );
  }
}