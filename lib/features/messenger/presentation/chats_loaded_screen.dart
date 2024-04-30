import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iqj/features/messenger/data/chat_service.dart';
//import 'package:flutter_reversed_list/flutter_reversed_list.dart';
import 'package:iqj/features/messenger/presentation/screens/date_for_load_chats.dart';
import 'package:iqj/features/messenger/presentation/screens/struct_of_message.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});
  @override
  State<StatefulWidget> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  Widget _buildThumbnailImage(String image_url) {
    try {
      return Container(
        padding: EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 45,
          height: 45,
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

  String? user_name = "..."; // Объявление user_name как поле класса
  String? image_url = "";
  String uid = "";
  bool vol = false;
  bool pin = false;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null, "Check args");
    Map<String, dynamic> help = args as Map<String, dynamic>;
    user_name =
        help["name"] as String?; // Присваивание значения переменной user_name
    image_url = help["url"] as String?;
    vol = help["volume"] as bool;
    pin = help["pin"] as bool;
    uid = help["uid"] as String;

    setState(() {});
    super.didChangeDependencies();
  }

  final TextEditingController _msgController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_msgController.text.isNotEmpty) {
      await _chatService.sendMessage(
        uid,
        _msgController.text,
      );
      _msgController.clear();
    }
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
        uid,
        _firebaseAuth.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Align(
          alignment: Alignment.bottomCenter,
          child: ListView(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            //reverse: true,
            shrinkWrap: true,
            children: snapshot.data!.docs
                .map((document) => _buildMessageListItem(document))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildMessageListItem(DocumentSnapshot document) {
    final Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    print(data);
    final mainalignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? MainAxisAlignment.start
        : MainAxisAlignment.end;
    final alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      alignment: alignment,
      child: ReceiverMessage(
        message: data['message'].toString(),
        mainAxisAlignment: mainalignment,
        url: '', 
        receiver: data['senderId'] as String,
         compare: _firebaseAuth.currentUser!.uid, 
         time: "${DateFormat('HH:mm').format(DateTime.now())}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              _buildThumbnailImage(image_url ?? ""),
              //const Padding(padding: EdgeInsets.only(right: 12)),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Flexible(
                            child: Text(
                              user_name ?? "",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontSize: 20,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        vol ? Icon(Icons.volume_off) : Container(),
                        pin ? Icon(Icons.push_pin_outlined) : Container(),
                      ],
                    ),
                    Text(
                      "печатает...",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.phone,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    // Действие при нажатии на кнопку с телефоном
                  },
                ),
                PopupMenuButton<String>(
                  onSelected: (String choice) {},
                  itemBuilder: (BuildContext context) {
                    return {'Настройки', 'Статус'}.map((String choice) {
                      return choice == "Настройки"
                          ? PopupMenuItem<String>(
                              value: choice,
                              child: Row(
                                children: [
                                  const Icon(Icons.settings_outlined),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 12),
                                  ),
                                  Text(choice),
                                ],
                              ),
                            )
                          : PopupMenuItem<String>(
                              value: choice,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.tag_faces_sharp,
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
      body: _buildMessageList(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.zero,
        child: TextField(
          scrollPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
          controller: _msgController,
          decoration: InputDecoration(
            filled: true, // Включаем заливку цветом
            fillColor: Theme.of(context).colorScheme.onInverseSurface,
            hintText: "Введите сообщение...",
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight:
                      Radius.circular(12)), // Закругленные углы для поля ввода
            ),
            prefixIcon: IconButton(
              icon: Icon(Icons.insert_emoticon), // Иконка смайлика
              onPressed: () {
                // Действие при нажатии на кнопку смайлика
              },
            ),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file), // Иконка скрепки
                  onPressed: () {
                    // Действие при нажатии на кнопку скрепки
                  },
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Действие при нажатии на кнопку отправки
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
