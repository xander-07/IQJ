import 'package:flutter/material.dart';

class ServicesBubble extends StatefulWidget {
  final IconData icon;
  final String text;
  const ServicesBubble({
    required this.icon,
    required this.text,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ServicesBubble();
}

class _ServicesBubble extends State<ServicesBubble> {

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

            },
            child: Container(
              height: 48,
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
                  Icon(
                    widget.icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    size: 36,
                  ),
                  const Padding(padding: EdgeInsets.only(right: 24)),
                  Text(
                    widget.text,
                    style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontSize: 20,
                        ),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 12)),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ],
    );
  }
}
