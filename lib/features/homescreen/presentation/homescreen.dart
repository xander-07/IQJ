import 'package:flutter/material.dart';
import 'package:iqj/features/homescreen/data/homescreen_pages.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pages[_currentPage].widget),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.background,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        unselectedItemColor: const Color(0xFF828282),
        items: pages,
        currentIndex: _currentPage,
        onTap: (int index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}
