import 'package:flutter/material.dart';
import 'package:iqj/features/messenger/data/chat_service.dart';

class ChatMember extends StatefulWidget {
  final String imageUrl;
  final String chatTitle;
  final String uid;
  final String role;
  final String groupId;
  ChatMember({
    required this.imageUrl,
    required this.chatTitle,
    required this.uid,
    required this.role,
    required this.groupId,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ChatMember();
}

class _ChatMember extends State<ChatMember> {
  ChatService chatService = ChatService();

  void showDeleteDialog(BuildContext context) {
    final Widget okButton = TextButton(
      style: const ButtonStyle(
        overlayColor: MaterialStatePropertyAll(Color.fromARGB(64, 239, 172, 0)),
      ),
      child: const Text(
        "Да, отчисляем!",
        style: TextStyle(
          color: Color.fromARGB(255, 239, 172, 0),
        ),
      ),
      onPressed: () {
        chatService.removeUserFromGroup(widget.groupId, widget.uid);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    final Widget cancelButton = TextButton(
      style: const ButtonStyle(
        overlayColor: MaterialStatePropertyAll(
          Color.fromARGB(64, 193, 85, 78),
        ),
      ),
      child: const Text(
        "Получить взятку",
        style: TextStyle(
          color: Color.fromARGB(255, 193, 85, 78),
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    final AlertDialog alert = AlertDialog(
      title: const Text(
        "Отчислить?",
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      content: const Text(
          "Вы действительно желаете отчислить этого пользователя из группы?",),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildThumbnailImage() {
    try {
      return SizedBox(
        width: 48,
        height: 48,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Image.network(
            widget.imageUrl,
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
                child: const Text('A'),
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
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          child: ElevatedButton(
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
            onLongPress: () {
              showModalBottomSheet(
                backgroundColor: Theme.of(context).colorScheme.background,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.all(18),
                    //color: Theme.of(context).colorScheme.background,
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12)),
                      //color: Theme.of(context).colorScheme.background,
                    ),
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
                            const Padding(padding: EdgeInsets.only(right: 12)),
                            Text(
                              "Участник ${widget.chatTitle}",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 6)),
                        if (widget.role != "admin") ElevatedButton(
                          onPressed: () {
                            showDeleteDialog(context);
                          },
                          style: ButtonStyle(
                            padding:
                                const MaterialStatePropertyAll(EdgeInsets.zero),
                            surfaceTintColor: const MaterialStatePropertyAll(
                                Colors.transparent),
                            backgroundColor: const MaterialStatePropertyAll(
                              Colors.transparent,
                            ),
                            shadowColor: const MaterialStatePropertyAll(
                                Colors.transparent),
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
                                Icon(Icons.person_off_rounded),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Отчислить из группы",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ) else Container(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              'userpage',
                              arguments: {
                                'name': widget.chatTitle,
                                'url': widget.imageUrl,
                                'uid': widget.uid,
                              },
                            );
                          },
                          style: ButtonStyle(
                            padding:
                                const MaterialStatePropertyAll(EdgeInsets.zero),
                            surfaceTintColor: const MaterialStatePropertyAll(
                                Colors.transparent),
                            backgroundColor: const MaterialStatePropertyAll(
                              Colors.transparent,
                            ),
                            shadowColor: const MaterialStatePropertyAll(
                                Colors.transparent),
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
                                Icon(Icons.account_circle_rounded),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Страница пользователя",
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            onPressed: () {
              Navigator.of(context).pushNamed(
                'userpage',
                arguments: {
                  'name': widget.chatTitle,
                  'url': widget.imageUrl,
                  'uid': widget.uid,
                },
              );
            },
            child: Container(
              margin: const EdgeInsets.only(
                top: 6,
                left: 6,
                right: 6,
                bottom: 6,
              ),
              padding: const EdgeInsets.only(
                left: 3,
                right: 3,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildThumbnailImage(),
                  const Padding(padding: EdgeInsets.only(right: 12)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.chatTitle,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'был недавно',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(right: 12)),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        widget.role == 'admin' ? 'Администратор' : 'Участник',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 102, right: 24),
          child: Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }
}
