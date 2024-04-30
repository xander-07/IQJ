import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
   const ProfilePicture({super.key});

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  Color boxFillColor = const Color(0xFFF6F6F6);
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      //alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: Container(
          padding: EdgeInsets.all(2), // Border width
          decoration: BoxDecoration(color: const Color(0xFFEFAC00), shape: BoxShape.circle),
          child: ClipOval(
            child: SizedBox.fromSize(
              size: Size.fromRadius(72), // Image radius
              child: Image.network('https://gas-kvas.com/grafic/uploads/posts/2023-10/1696557271_gas-kvas-com-p-kartinki-vulkan-9.jpg', fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}
