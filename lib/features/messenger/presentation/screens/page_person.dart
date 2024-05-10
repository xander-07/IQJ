import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  bool flag1 = true;
  bool flag2 = false;
  bool flag3 = false;
  bool flag4 = false;
  bool flag5 = false;

  void change_flag1() {
    setState(() {
      flag1 = true;
      flag2 = false;
      flag3 = false;
      flag4 = false;
      flag5 = false;
    });
  }

  void change_flag2() {
    setState(() {
      flag1 = false;
      flag2 = true;
      flag3 = false;
      flag4 = false;
      flag5 = false;
    });
  }

  void change_flag3() {
    setState(() {
      flag1 = false;
      flag2 = false;
      flag3 = true;
      flag4 = false;
      flag5 = false;
    });
  }

  void change_flag4() {
    setState(() {
      flag1 = false;
      flag2 = false;
      flag3 = false;
      flag4 = true;
      flag5 = false;
    });
  }

  void change_flag5() {
    setState(() {
      flag1 = false;
      flag2 = false;
      flag3 = false;
      flag4 = false;
      flag5 = true;
    });
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
                    // decoration: BoxDecoration( 
                    //   borderRadius: BorderRadius.only(topLeft:Radius.circular(12),topRight: Radius.circular(12)),
                    // ),
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
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    color: Theme.of(context).colorScheme.background,
                    height: 260,
                    // decoration: BoxDecoration( 
                    //   borderRadius: BorderRadius.only(topLeft:Radius.circular(12),topRight: Radius.circular(12)),
                    // ),
                    child: Column( 
                      children: [ 
                        create_button_for_change_state(Icons.attach_file_outlined, "Закрепить в списке чатов", context),
                        create_button_for_change_state(Icons.edit, "Закрепленное сообщение", context),
                        create_button_for_change_state(Icons.refresh, "Очистить историю", context),
                        create_button_for_change_state(Icons.close, "Выйти из чата", context),
                        create_button_for_change_state(Icons.delete, "Выйти из чата и очистить историю", context),
                      ],
                    ),
                    
                  );
                }
              );
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
                        child: GestureDetector(
                          onTap: () => {
                            change_flag1(),
                          },
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
                      ),
                      Tab(
                        child: GestureDetector(
                          onTap: () => {
                            change_flag2(),
                          },
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
                      ),
                      Tab(
                        child: GestureDetector(
                          onTap: () => {
                            change_flag3(),
                          },
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
                      ),
                      Tab(
                        child: GestureDetector(
                          onTap: () => {
                            change_flag4(),
                          },
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
                      ),
                      Tab(
                        child: GestureDetector(
                          onTap: () => {
                            change_flag5(),
                          },
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
                      ),
                    ],
                  )),
            ),
            if (flag1) participants(context,"Александр Павлеченко", "был сегодня в 16:00", "Администратор", image_url??""),
            if (flag1) participants(context,"Александр Павлеченко", "был сегодня в 16:00", "Администратор", image_url??""),
            if (flag1) participants(context,"Александр Павлеченко", "был сегодня в 16:00", "Администратор", image_url??""),
            Wrap(
              children: [
                flag2? _buildSquer(image_url??"",105) : Container(),
                flag2? _buildSquer(image_url??"",105) : Container(),
                flag2? _buildSquer(image_url??"",105) : Container(),
                flag2? _buildSquer(image_url??"",105) : Container(),
                flag2? _buildSquer(image_url??"",105) : Container(),
                flag2? _buildSquer(image_url??"",105) : Container(),
            ],
            ),
            flag3? _File_in_main_chat(context, image_url??"","линейная алгебра и аналитическая геом","1,0 MB, 06.05.24 в 12:25"):Container(),
            flag3? _File_in_main_chat(context, image_url??"","линейная алгебра и аналитическая геом","1,0 MB, 06.05.24 в 12:25"):Container(),
            flag3? _File_in_main_chat(context, image_url??"","линейная алгебра и аналитическая геом","1,0 MB, 06.05.24 в 12:25"):Container(),
            flag3? _File_in_main_chat(context, image_url??"","линейная алгебра и аналитическая геом","1,0 MB, 06.05.24 в 12:25"):Container(),
            flag3? _File_in_main_chat(context, image_url??"","линейная алгебра и аналитическая геом","1,0 MB, 06.05.24 в 12:25"):Container(),
          ],
        ),
      ),
    );
  }
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



Widget create_button_for_change_state(IconData icon,String text, BuildContext context){
  return ElevatedButton(
                          onPressed: () =>{

                          }, 
                          style: ButtonStyle(
                            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                            surfaceTintColor:
                                const MaterialStatePropertyAll(Colors.transparent),
                            backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.background,
                            ),
                            shadowColor: const MaterialStatePropertyAll(Colors.transparent),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 20,),
                              Icon(icon),
                              SizedBox(width: 20,),
                              Text( 
                                "Закрепить в списке чатов",
                                style: TextStyle(
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                        fontSize: 18,
                                      ),
                              ),
                            ],
                          )
                        );
}

Widget participants(BuildContext context,String name, String time,String role,String image_url){
  return ElevatedButton(
                          onPressed: () =>{

                          }, 
                          style: ButtonStyle(
                            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                            surfaceTintColor:
                                const MaterialStatePropertyAll(Colors.transparent),
                            backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.background,
                            ),
                            shadowColor: const MaterialStatePropertyAll(Colors.transparent),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 20,),
                              _buildThumbnailImage(image_url, 33),
                              SizedBox(width: 20,),
                              Column(
                                children: [
                                  Text( 
                                    name,
                                    style: TextStyle(
                                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                                            fontSize: 10,
                                          ),
                                  ),
                                  Text( 
                                    time,
                                    style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSecondary,
                                            fontSize: 10,
                                          ),
                                  ),
                                  
                                ],
                              ),
                              Expanded(
                                child: Text( 
                                  role,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          )
                        );
}

Widget _buildSquer(String image_url, double size) {
  try {
    return Container(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: size,
        height: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12), // Используем радиус 12 для получения квадратных углов
          child: Image.network(
            image_url,
            fit: BoxFit.fill,
            errorBuilder: (
              BuildContext context,
              Object exception,
              StackTrace? stackTrace,
            ) {
              return Container(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer, // Вместо CircleAvatar используем обычный контейнер с цветом фона
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

Widget _File_in_main_chat(BuildContext context, String image_url,String name,String info){
  return ElevatedButton(
                          onPressed: () =>{

                          }, 
                          style: ButtonStyle(
                            padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                            surfaceTintColor:
                                const MaterialStatePropertyAll(Colors.transparent),
                            backgroundColor: MaterialStatePropertyAll(
                              Theme.of(context).colorScheme.background,
                            ),
                            shadowColor: const MaterialStatePropertyAll(Colors.transparent),
                            shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 20,),
                              _buildSquer(image_url, 40),
                              SizedBox(width: 20,),
                              Column(
                                children: [
                                  Text( 
                                    name,
                                    style: TextStyle(
                                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                fontSize: 12,
                                              ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.download,size: 12, color: Theme.of(context).colorScheme.onSecondary,),
                                      SizedBox(width: 10,),
                                      Text(
                                    info,
                                    style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSecondary,
                                            fontSize: 10,
                                          ),
                                  )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                        );
}