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

  TextEditingController ChangeController = TextEditingController();

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null, "Check args");
    Map<String, dynamic> help = args as Map<String, dynamic>;
    user_name =
        help["name"] as String?; // Присваивание значения переменной user_name
    image_url = help["url"] as String?;
    uid = help["uid"] as String;

    setState(() {});
    super.didChangeDependencies();
  }

  Widget _buildThumbnailImage(String image_url,double size) {
    try {
      return Container(
        padding: EdgeInsets.only(right: 12),
        child: SizedBox(
          width: size,
          height: size,
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
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    color: Theme.of(context).colorScheme.background,
                    height: 160,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.close),
                            ),
                            Text(
                              "Настройки чата",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontSize: 25,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            _buildThumbnailImage(image_url ?? "", 70),
                            Column(
                              children: [
                                Text(
                                  "Название чата",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontSize: 14,
                                  ),
                                ),
                                // TextField(
                                //   controller: ChangeController,
                                //   decoration: InputDecoration(
                                //     hintText: user_name ?? "Заметки",
                                //     hintStyle: TextStyle(
                                //       fontFamily: 'Inter',
                                //       fontWeight: FontWeight.w400,
                                //       fontSize: 16.0,
                                //       height: 5,
                                //     ),
                                //     border: InputBorder.none,
                                //     contentPadding: const EdgeInsets.symmetric(
                                //       horizontal: 12,
                                //       vertical: 16,
                                //     ),
                                //     suffixIcon: SizedBox(
                                //       child: IconButton(
                                //         icon: const Icon(
                                //           Icons.search,
                                //         ),
                                //         onPressed: () {
                                //           // Действие при нажатии кнопки поиска
                                //         },
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
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
          mainAxisAlignment: MainAxisAlignment
              .start, // Элементы начинаются с верхней части экрана
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildThumbnailImage(image_url ?? "",117),
            SizedBox(height: 10), // Отступ между картинкой и названием
            Text(
              user_name ?? "",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontSize: 25,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "4 участника",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 10), // Отступ перед кнопками
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Равномерное распределение по оси X
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.person_add),
                      color: Colors.orange, // Оранжевый цвет
                      onPressed: () {
                        // Действия для кнопки с логотипом человечка с плюсом
                      },
                    ),
                    Text(
                      "Добавить",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ), // Текст ниже первой кнопки
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications),
                      color: Colors.orange, // Оранжевый цвет
                      onPressed: () {
                        // Действия для кнопки с логотипом колокольчика
                      },
                    ),
                    Text(
                      "Уведомления",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ), // Текст ниже второй кнопки
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.search),
                      color: Colors.orange, // Оранжевый цвет
                      onPressed: () {
                        // Действия для кнопки с логотипом лупы
                      },
                    ),
                    Text(
                      "  Поиск",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ), // Текст ниже третьей кнопки
                  ],
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              height: 2.0,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            //SizedBox(height: 15),
            Container(
              alignment: Alignment.center,
              child: DefaultTabController(
                  length: 5,
                  child: TabBar(
                    isScrollable: true,
                    indicatorPadding: EdgeInsets.only(top: 10, bottom: 10),
                    dividerHeight: 0,
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Участники",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 10,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Медиа",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 10,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Файлы",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 10,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Ссылки",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 10,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            "Голосовые",
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 10,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
