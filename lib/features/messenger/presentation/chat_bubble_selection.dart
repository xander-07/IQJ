import 'package:flutter/material.dart';

class ChatBubbleSelection extends StatefulWidget {
  final String imageUrl;
  final String chatTitle;
  final String uid;
  bool selected;
  final Function(String, bool) onSelectionChanged;
  ChatBubbleSelection({
    required this.imageUrl,
    required this.chatTitle,
    required this.uid,
    required this.selected,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ChatBubbleSelection();
}

class _ChatBubbleSelection extends State<ChatBubbleSelection> {
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

  //bool selected = false;
  void setSelected() {
    setState(() {
      widget.selected = !widget.selected;
    });
  }

  void toggleSelection() {
    setState(() {
      widget.onSelectionChanged(widget.uid, !widget.selected);
    });
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
            onPressed: () {
              //setSelected();
              toggleSelection();
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
                          widget.selected
                              ? Container(
                                  padding: EdgeInsets.only(left: 6),
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.check_circle_rounded))
                              : Container(),
                        ],
                      ),
                    ],
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
