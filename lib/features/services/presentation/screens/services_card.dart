import 'package:flutter/material.dart';

class ServicesCard extends StatefulWidget {
  final String imageUrl;
  final String cardTitle;
  const ServicesCard({
    required this.imageUrl,
    required this.cardTitle,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _ServicesCard();
}

class _ServicesCard extends State<ServicesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 180,
      margin: EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              widget.imageUrl,),
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Text(
          widget.cardTitle, // Текст карточки
          style: TextStyle(
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(1),
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
