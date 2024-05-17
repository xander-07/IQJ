import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:iqj/features/auth/data/auth_service.dart';
import 'package:iqj/features/messenger/data/chat_service.dart';
import 'package:iqj/features/messenger/presentation/chat_bubble_selection.dart';
import 'package:iqj/features/messenger/presentation/chat_member_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;

class UserPage extends StatefulWidget {
  const UserPage({super.key});
  @override
  State<StatefulWidget> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  String? user_name = "..."; // Объявление user_name как поле класса
  String? image_url = "";
  String uid = "";

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
    _updateMemberCount(uid);
  }

  ChatService chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // это что за код такой
  bool flag1 = true;
  bool flag2 = false;
  bool flag3 = false;
  bool flag4 = false;

  void change_flag1() {
    setState(() {
      flag1 = true;
      flag2 = false;
      flag3 = false;
      flag4 = false;
    });
  }

  void change_flag2() {
    setState(() {
      flag1 = false;
      flag2 = true;
      flag3 = false;
      flag4 = false;
    });
  }

  void change_flag3() {
    setState(() {
      flag1 = false;
      flag2 = false;
      flag3 = true;
      flag4 = false;
    });
  }

  void change_flag4() {
    setState(() {
      flag1 = false;
      flag2 = false;
      flag3 = false;
      flag4 = true;
    });
  }

  int memberCount = 0;

  Future<void> _updateMemberCount(String groupId) async {
    int count = await chatService.getNumberOfUsersInGroup(groupId);
    setState(() {
      memberCount = count;
    });
  }

  Future<String> getUserRole(String uids) async {
    return await chatService.getUserRoleInGroup(uid, uids);
  }

  @override
  Widget build(BuildContext context) {
    final ChatService _chatService = ChatService();

    // List<String>media = _chatService.getLinksFromChat(
    //       _auth.currentUser!.uid, uid) as List<String>;
    // print(media);

    TextEditingController groupNameChangeController =
        TextEditingController(text: user_name);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // showModalBottomSheet(
              //   backgroundColor: Theme.of(context).colorScheme.background,
              //   context: context,
              //   builder: (BuildContext context) {
              //     print('opening thing');
              //     return StatefulBuilder(
              //       builder: (BuildContext context, StateSetter setState) {
              //         return Container(
              //           height: 200,
              //           margin: const EdgeInsets.all(18),
              //           child: Column(
              //             children: [
              //               Row(
              //                 children: [
              //                   IconButton(
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     },
              //                     icon: Icon(Icons.close),
              //                   ),
              //                   const Padding(
              //                       padding: EdgeInsets.only(right: 12)),
              //                   Text(
              //                     "Настройки чата",
              //                     style: TextStyle(
              //                       color: Theme.of(context)
              //                           .colorScheme
              //                           .onPrimaryContainer,
              //                       fontSize: 25,
              //                     ),
              //                   )
              //                 ],
              //               ),
              //               const Padding(padding: EdgeInsets.only(bottom: 12)),
              //               Row(
              //                 children: [
              //                   _buildThumbnailImage(image_url ?? "", 70),
              //                   Expanded(
              //                     child: Column(
              //                       crossAxisAlignment:
              //                           CrossAxisAlignment.start,
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Text(
              //                           "Название группы",
              //                           style: TextStyle(
              //                             color: Theme.of(context)
              //                                 .colorScheme
              //                                 .onPrimaryContainer,
              //                             fontSize: 14,
              //                           ),
              //                         ),
              //                         Padding(
              //                             padding: EdgeInsets.only(bottom: 6)),
              //                         SizedBox(
              //                           height: 48,
              //                           child: TextField(
              //                             controller: groupNameChangeController,
              //                             maxLines: 1,
              //                             decoration: InputDecoration(
              //                               hintText: "Введите название...",
              //                               hintStyle: const TextStyle(
              //                                 fontFamily: 'Inter',
              //                                 fontWeight: FontWeight.w400,
              //                                 fontSize: 16.0,
              //                               ),
              //                               fillColor: Theme.of(context)
              //                                   .colorScheme
              //                                   .primary
              //                                   .withAlpha(32),
              //                               filled: true,
              //                               border: OutlineInputBorder(
              //                                 borderRadius:
              //                                     BorderRadius.circular(10.0),
              //                                 borderSide: BorderSide(
              //                                   width: 0,
              //                                   style: BorderStyle.none,
              //                                 ),
              //                               ),
              //                               hoverColor: Theme.of(context)
              //                                   .colorScheme
              //                                   .primary
              //                                   .withAlpha(32),
              //                               contentPadding:
              //                                   const EdgeInsets.symmetric(
              //                                 horizontal: 12,
              //                                 vertical: 16,
              //                               ),
              //                               suffixIcon: Container(
              //                                 margin: EdgeInsets.only(right: 6),
              //                                 child: SizedBox(
              //                                   child: IconButton(
              //                                     color: Theme.of(context)
              //                                         .colorScheme
              //                                         .primary,
              //                                     icon: const Icon(
              //                                       Icons.check,
              //                                     ),
              //                                     onPressed: () {
              //                                       // Действие
              //                                       print(
              //                                           'changing group name!');
              //                                       chatService.setGroupName(
              //                                           uid,
              //                                           groupNameChangeController
              //                                               .text);
              //                                       Navigator.of(context).pop();
              //                                     },
              //                                   ),
              //                                 ),
              //                               ),
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //     );
              //   },
              // );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      //color: Theme.of(context).colorScheme.background,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        //color: Theme.of(context).colorScheme.background,
                      ),
                      margin: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          create_button_for_change_state(
                              Icons.attach_file_outlined,
                              "Закрепить в списке чатов",
                              context),
                          create_button_for_change_state(
                              Icons.edit, "Закрепленное сообщение", context),
                          create_button_for_change_state(
                              Icons.refresh, "Очистить историю", context),
                          create_button_for_change_state(
                              Icons.close, "Выйти из чата", context),
                          create_button_for_change_state(Icons.delete,
                              "Выйти из чата и очистить историю", context),
                        ],
                      ),
                    );
                  });
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
            _buildThumbnailImage(image_url ?? "", 117),
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
            SizedBox(height: 10), // Отступ перед кнопками
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Равномерное распределение по оси X
              children: [
                // Column(
                //   children: [
                //     IconButton(
                //       icon: Icon(Icons.person_add),
                //       color: Colors.orange, // Оранжевый цвет
                //       onPressed: () {
                //         Navigator.of(context)
                //             .pushNamed('addtogroup', arguments: {
                //           "groupid": uid,
                //         });
                //       },
                //     ),
                //     Text(
                //       "Добавить",
                //       style: TextStyle(
                //         color: Theme.of(context).colorScheme.primary,
                //         fontSize: 16,
                //         fontWeight: FontWeight.w400,
                //       ),
                //     ), // Текст ниже первой кнопки
                //   ],
                // ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications),
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Оранжевый цвет
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
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Оранжевый цвет
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
                  length: 4,
                  child: TabBar(
                    isScrollable: true,
                    indicatorPadding: EdgeInsets.only(top: 10, bottom: 10),
                    dividerHeight: 0,
                    tabAlignment: TabAlignment.start,
                    onTap: (value) {
                      if (value == 0) change_flag1();
                      if (value == 1) change_flag2();
                      if (value == 2) change_flag3();
                      if (value == 3) change_flag4();
                    },
                    tabs: [
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
            if (flag1)
              FutureBuilder<List<String>>(
                future:
                    _chatService.getLinksFromChat(_auth.currentUser!.uid, uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching links'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No links found'));
                  }

                  final List<String> links = snapshot.data!;
                  final List<Widget> imageWidgets = [];

                  for (var link in links) {
                    if (isFirebaseStorageLink(link)) {
                      imageWidgets.add(_buildSquer(link, 128));
                    }
                  }

                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: imageWidgets,
                  );
                },
              ),
            //flag1? _buildMediaList() : Container(),
            // flag2
            //     ? _File_in_main_chat(
            //         context,
            //         image_url ?? "",
            //         "линейная алгебра и аналитическая геом",
            //         "1,0 MB, 06.05.24 в 12:25")
            //     : Container(),
            if (flag2) Text("Файлов нет."),
            if (flag3)
              Expanded(
                  child: FutureBuilder<List<String>>(
                future:
                    _chatService.getLinksFromChat(_auth.currentUser!.uid, uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching links'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No links found'));
                  }

                  final List<String> links = snapshot.data!;

                  return ListView.builder(
                    itemCount: links.length,
                    itemBuilder: (context, index) {
                      final String link = links[index];
                      if (!isFirebaseStorageLink(link)) {
                        return _Link_for_main_chat(
                          context,
                          link,
                        );
                      }
                    },
                  );
                },
              ))
            else
              Container(),
            if (flag4) Text("Голосовых сообщений нет."),
          ],
        ),
      ),
    );
  }
}

Widget _buildThumbnailImage(String image_url, double size) {
  try {
    return Container(
      padding: EdgeInsets.only(right: 12),
      child: SizedBox(
        width: size,
        height: size,
        child: InstaImageViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              image_url,
              fit: BoxFit.fill,
              height: size,
              width: size,
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  } catch (e) {
    return Container();
  }
}

Widget create_button_for_change_state(
    IconData icon, String text, BuildContext context) {
  return ElevatedButton(
    onPressed: () => {},
    style: ButtonStyle(
      padding: const MaterialStatePropertyAll(EdgeInsets.zero),
      surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
      backgroundColor: MaterialStatePropertyAll(
        Colors.transparent,
      ),
      shadowColor: const MaterialStatePropertyAll(Colors.transparent),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    child: Container(
      height: 42,
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Icon(icon),
          SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSquer(String image_url, double size) {
  try {
    return Container(
      padding: EdgeInsets.all(5),
      child: SizedBox(
        width: size,
        height: size,
        child: InstaImageViewer(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              image_url,
              fit: BoxFit.fill,
              height: size,
              width: size,
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                  ),
                  child: Text(
                    'G',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  } catch (e) {
    return Container();
  }
}

Widget _File_in_main_chat(
    BuildContext context, String image_url, String name, String info) {
  return ElevatedButton(
      onPressed: () => {},
      style: ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.zero),
        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
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
          SizedBox(
            width: 20,
          ),
          _buildSquer(image_url, 40),
          SizedBox(
            width: 20,
          ),
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
                  Icon(
                    Icons.download,
                    size: 12,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
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
      ));
}

Widget _Link_for_main_chat(BuildContext context, String link) {
  return FutureBuilder<Map<String, String>>(
    future: fetchTitleDescriptionAndImageUrl(link),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.hasData) {
        var data = snapshot.data!;
        return Container(
          margin: EdgeInsets.only(right: 6, left: 6),
          child: ElevatedButton(
            onPressed: () => {launchUrlString(link)},
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
                _buildSquer(data['imageUrl'] ?? '', 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['title']!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        data['description']!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        link,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Text('No data found');
      }
    },
  );
}

bool isFirebaseStorageLink(String url) {
  final RegExp firebaseStoragePattern =
      RegExp(r'https://firebasestorage\.googleapis\.com/v0/b/.+');
  return firebaseStoragePattern.hasMatch(url);
}

Future<Map<String, String>> fetchTitleDescriptionAndImageUrl(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var document = html_parser.parse(response.body);

    // Extract title
    String title = document.querySelector('title')?.text ?? url;

    // Extract description
    String description = url;
    var metaTags = document.getElementsByTagName('meta');
    for (var meta in metaTags) {
      if (meta.attributes['name'] == 'description') {
        description = meta.attributes['content'] ?? url;
        break;
      }
    }

    // Extract image URL
    String imageUrl = '';
    for (var meta in metaTags) {
      if (meta.attributes['property'] == 'og:image') {
        imageUrl = meta.attributes['content'] ?? '';
        break;
      }
    }

    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  } else {
    throw Exception('Failed to load website');
  }
}
