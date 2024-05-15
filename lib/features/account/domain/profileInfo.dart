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
      child: Column(
        children: [
          Text(
            "Валентинов\nВалентин\nВалентинович",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                    ?const Color(0xFF000000)
                    : Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 7,),
          Text(
            "valentinov@mirea.ru",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                    ?const Color(0xFF000000)
                    : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
