import 'package:flutter/material.dart';

class HomeScreenPage extends BottomNavigationBarItem {
  final Widget widget;
  const HomeScreenPage({
    required this.widget,
    required super.icon,
    required super.activeIcon,
    required super.label,
  });
}
