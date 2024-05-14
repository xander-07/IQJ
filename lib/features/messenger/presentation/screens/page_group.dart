import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iqj/features/auth/data/auth_service.dart';
import 'package:iqj/features/messenger/data/chat_service.dart';
import 'package:iqj/features/messenger/presentation/screens/chat_bubble_selection.dart';
import 'package:iqj/features/messenger/presentation/screens/chat_member_button.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});
  @override
  State<StatefulWidget> createState() => _GroupPage();
}

class _GroupPage extends State<GroupPage> {
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

  int memberCount = 0;

  Future<void> _updateMemberCount(String groupId) async {
    int count = await chatService.getNumberOfUsersInGroup(groupId);
    setState(() {
      memberCount = count;
    });
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('err');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Extract user IDs from the snapshot data
        List userIds = snapshot.data!.docs.map((doc) => doc['uid']).toList();

        // Call getUsersInGroup function to fetch user data for the group
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: chatService.getUsersInGroup(uid), // Pass the group ID here
          builder: (context, groupSnapshot) {
            if (groupSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (groupSnapshot.hasError) {
              return Text('Error fetching users in group');
            } else {
              // Extract user data from the group snapshot
              List<Map<String, dynamic>> usersData = groupSnapshot.data ?? [];

              // Build UI components for each user
              return Column(
                children: snapshot.data!.docs
                    .where((doc) => userIds.contains(doc['uid']))
                    .map<Widget>((doc) {
                  List<Map<String, dynamic>> usersData =
                      groupSnapshot.data ?? [];

                  Map<String, dynamic> userData = usersData.firstWhere(
                    (userData) => userData['uid'] == doc['uid'],
                    orElse: () => {},
                  );

                  // Build UI component for the current user
                  return _buildUserListItem(doc, userData);
                }).toList(),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildUserListItem(
  DocumentSnapshot document,
  Map<String, dynamic>? userData,
) {
  final Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  return FutureBuilder<bool>(
    future: chatService.isUserInGroup(data['uid'] as String, uid),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(); // Return a placeholder widget while loading
      } else if (snapshot.hasError) {
        return SizedBox(); // Return a placeholder widget on error
      } else {
        bool isMember = snapshot.data ?? false;

        // Check if the user is not a member and display ChatMember widget
        if (isMember) {
          return FutureBuilder<String>(
            future: getUserRole(data['uid'].toString()),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Return a placeholder widget while loading
              } else if (roleSnapshot.hasError) {
                return SizedBox(); // Return a placeholder widget on error
              } else {
                String userRole = roleSnapshot.data ?? 'Unknown'; // Get the user role from the snapshot data
                return ChatMember(
                  imageUrl: data['picture'].toString(),
                  chatTitle: data['email'].toString(),
                  uid: data['uid'].toString(),
                  role: userRole,
                );
              }
            },
          );
        } else {
          return Container(); // Return an empty container if the user is a member
        }
      }
    },
  );
}


  Future<String> getUserRole(String uids) async {
    return await chatService.getUserRoleInGroup(uid, uids);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController groupNameChangeController =
        TextEditingController(text: user_name);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Theme.of(context).colorScheme.background,
                context: context,
                builder: (BuildContext context) {
                  print('opening thing');
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        height: 200,
                        margin: const EdgeInsets.all(18),
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
                                const Padding(
                                    padding: EdgeInsets.only(right: 12)),
                                Text(
                                  "Настройки чата",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontSize: 25,
                                  ),
                                )
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(bottom: 12)),
                            Row(
                              children: [
                                _buildThumbnailImage(image_url ?? "", 70),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Название группы",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimaryContainer,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 6)),
                                      SizedBox(
                                        height: 48,
                                        child: TextField(
                                          controller: groupNameChangeController,
                                          maxLines: 1,
                                          decoration: InputDecoration(
                                            hintText: "Введите название...",
                                            hintStyle: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.0,
                                            ),
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withAlpha(32),
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                width: 0,
                                                style: BorderStyle.none,
                                              ),
                                            ),
                                            hoverColor: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withAlpha(32),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 16,
                                            ),
                                            suffixIcon: Container(
                                              margin: EdgeInsets.only(right: 6),
                                              child: SizedBox(
                                                child: IconButton(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  icon: const Icon(
                                                    Icons.check,
                                                  ),
                                                  onPressed: () {
                                                    // Действие
                                                    print(
                                                        'changing group name!');
                                                    chatService.setGroupName(
                                                        uid,
                                                        groupNameChangeController
                                                            .text);
                                                    Navigator.of(context).pop();
                                                  },
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
                            ),
                          ],
                        ),
                      );
                    },
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
            Text(
              "${memberCount} участников",
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
                        Navigator.of(context)
                            .pushNamed('addtogroup', arguments: {
                          "groupid": uid,
                        });
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
                          onTap: () {
                            change_flag1();
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
                          onTap: () {
                            change_flag2();
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
            _buildUserList(),
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
                    Theme.of(context).colorScheme.tertiaryContainer,
                child: const Text('G'),
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

Widget create_button_for_change_state(
    IconData icon, String text, BuildContext context) {
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
          Icon(icon),
          SizedBox(
            width: 20,
          ),
          Text(
            "Закрепить в списке чатов",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 18,
            ),
          ),
        ],
      ));
}
