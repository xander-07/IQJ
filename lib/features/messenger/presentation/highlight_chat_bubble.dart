import 'package:flutter/material.dart';

class HighlightChatBubble extends StatefulWidget {
  final String imageUrl;
  final String chatTitle;
  final String secondary;
  const HighlightChatBubble({
    required this.imageUrl,
    required this.chatTitle,
    required this.secondary,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _HighlightChatBubble();
}

class _HighlightChatBubble extends State<HighlightChatBubble> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12, left: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.primaryContainer,
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
              'groupchat',
              arguments: {'name': widget.chatTitle,'url':widget.imageUrl,'volume': false,'pin': false, 'uid': ""},
              );
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Текущая пара",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 26,
                        ),
                      ),
                      Text(
                        "до 15:50",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.only(top: 12)),
                  Row(
                    children: [
                      _buildThumbnailImage(),
                      const Padding(padding: EdgeInsets.only(right: 12)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text(
                            widget.secondary,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          right: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 18)),
      ],
    );
  }
}
