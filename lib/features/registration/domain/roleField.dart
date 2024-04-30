import 'package:flutter/material.dart';

class RoleField extends StatefulWidget {
   const RoleField({super.key});

  @override
  _RoleFieldState createState() => _RoleFieldState();
}

class _RoleFieldState extends State<RoleField> {
  Color boxFillColor = const Color(0xFFF6F6F6);
  bool isError = false;
  String selectedValue = 'Роль';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F6),
        border: Border.all(color: Color(0xFFE8E8E8), width: 2,),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonFormField(
      
      value: selectedValue,
      items: <String>['Роль', 'Студент', 'Преподаватель', 'Модератор']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 24,
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });
        decoration: InputDecoration(
          filled: true,
          fillColor: boxFillColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFE8E8E8),
              width: 2,
            ),
          ),       
          
          
          
        );
      },
      ),
    );
  }
}
