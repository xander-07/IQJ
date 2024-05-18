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
      height: 120,
      width: 120,
      //alignment: Alignment.center,
      child: ClipRRect(
        
        borderRadius: BorderRadius.circular(2.0),
        child: Container(
          padding: EdgeInsets.all(1), // Border width
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1.0, color: Color(0xFFEFAC00)),
          ),
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
