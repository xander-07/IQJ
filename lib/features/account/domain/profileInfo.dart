import 'package:flutter/material.dart';

class ProfileInfo extends StatefulWidget {
   const ProfileInfo({super.key});

  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  Color boxFillColor = const Color(0xFFF6F6F6);
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      child: const Column(
        children: [
          Text(
            "Валентинов\nВалентин\nВалентинович",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 7,),
          Text(
            "valentinov@mirea.ru",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
