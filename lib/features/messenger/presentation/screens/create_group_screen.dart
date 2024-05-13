import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iqj/features/messenger/data/chat_service.dart';
import 'package:iqj/features/messenger/presentation/screens/chat_bubble.dart';
import 'package:iqj/features/messenger/presentation/screens/chat_bubble_selection.dart';
import 'package:iqj/features/news/admin/special_news_add_button.dart';
import 'package:intl/intl.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreen();
}

class _CreateGroupScreen extends State<CreateGroupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  TextEditingController SearchPickerController = TextEditingController();
  TextEditingController groupNameController = TextEditingController();
  String groupName = '';
  Map<String, dynamic> userMap = {};

  void updateSelectionState(String uid, bool isSelected) {
    setState(() {
      userMap[uid] = isSelected;
    });
    print(userMap);
  }

  void createGroup() async {
    List<String> users =
        userMap.values.map((value) => value.toString()).toList();

    await _chatService.createGroupChat(users, groupName);
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore
        .collection('users')
        .where("email", isEqualTo: SearchPickerController.text)
        .get()
        .then((value) {
      setState(() {
        try {
          userMap = value.docs[0].data();
        } catch (e) {
          userMap = {};
        }

        print(userMap);
        print(userMap['email']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 50.0, // Задаем ширину
        height: 50.0, // Задаем высоту
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary, // Цвет кнопки
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IconButton(
          onPressed: () {
            createGroup();
            Navigator.of(context).pushNamed(
              'groupchat',
              arguments: {
                'name': groupName,
                'url': 'no.',
                'volume': false,
                'pin': false,
                'uid': _auth.currentUser?.uid
              },
            );
            //Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_forward_rounded),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Theme.of(context).colorScheme.background,
      // Заголовок экрана
      appBar: AppBar(
        title: Text(
          'Создать группу',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12),
            ),
            SizedBox(
              width: 500,
              height: 50,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: groupNameController,
                  decoration: InputDecoration(
                    hintText: "Введите название группы...",
                    hintFadeDuration: const Duration(milliseconds: 100),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      //height: 5,
                      color: Color.fromRGBO(128, 128, 128, 0.6),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      groupName = text;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12),
            ),
            SizedBox(
              width: 500,
              height: 50,
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: SearchPickerController,
                  decoration: InputDecoration(
                    hintText: "Поиск...",
                    hintFadeDuration: const Duration(milliseconds: 100),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      //height: 5,
                      color: Color.fromRGBO(128, 128, 128, 0.6),
                    ),
                    suffixIcon: SizedBox(
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                        ),
                        onPressed: () {
                          onSearch();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 12),
            ),
            _buildUserList(),
          ],
        ),
      ),
    );
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
        return Column(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (_auth.currentUser!.email != data['email']) {
      return ChatBubbleSelection(
        imageUrl: data['picture'].toString(),
        chatTitle: data['email'].toString(),
        uid: data['uid'].toString(),
        selected: true,
      );
    }
    return Container();
  }
}
