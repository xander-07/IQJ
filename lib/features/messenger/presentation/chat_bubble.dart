import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String imageUrl;
  final String chatTitle;
  final String secondary;
  final String uid;
  final String phone;
  const ChatBubble({
    required this.imageUrl,
    required this.chatTitle,
    required this.secondary,
    required this.uid,
    required this.phone,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ChatBubble();
}

class _ChatBubble extends State<ChatBubble> {
  Widget _buildThumbnailImage() {
    try {
      return SizedBox(
        width: 64,
        height: 64,
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

  bool volume = false;
  bool push_pin = false;

  void volume_off() {
    setState(() {
      volume = !volume;
    });
  }

  void push_pin_get() {
    setState(() {
      push_pin = !push_pin;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final String username = "А. Б. Веселухов";
    String uid = widget.uid;

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
            onPressed: () {
              Navigator.of(context).pushNamed(
                'chatslist',
                arguments: {
                  'name': widget.chatTitle,
                  'url': widget.imageUrl,
                  'volume': volume,
                  'pin': push_pin,
                  'uid': widget.uid,
                  'phone': widget.phone,
                },
              );

              ;
            },
            onLongPress: () => {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.push_pin_outlined),
                          title: Text('Закрепить'),
                          onTap: () {
                            push_pin_get();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.volume_off),
                          title: Text('Без звука'),
                          onTap: () {
                            volume_off();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            },
            child: Container(
              margin: const EdgeInsets.only(
                top: 12,
                left: 12,
                right: 12,
                bottom: 12,
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
                  Expanded(
                    child: Column(
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
                              overflow: TextOverflow.ellipsis,
                            ),
                            volume ? Icon(Icons.volume_off) : Container(),
                            push_pin
                                ? Icon(Icons.push_pin_outlined)
                                : Container(),
                          ],
                        ),
                        Text(
                          widget.secondary,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 12)),
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
