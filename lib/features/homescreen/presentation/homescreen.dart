import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/homescreen/data/homescreen_pages.dart';
import 'package:flutter/material.dart';
import 'package:iqj/features/account/presentation/screens/account_screen.dart';
import 'package:iqj/features/messenger/presentation/screens/messenger_screen.dart';
import 'package:iqj/features/homescreen/domain/homescreen_page.dart';
import 'package:iqj/features/news/presentation/screens/news_screen.dart';
import 'package:iqj/features/schedule/presentation/schedule_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iqj/features/services/presentation/screens/services_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String jwt = 'hi';
  //List<HomeScreenPage> pages = [];

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    assert(args != null, "Check args");
    jwt = args.toString();

    setState(() {});
    super.didChangeDependencies();
  }

  final pages = <HomeScreenPage>[
  HomeScreenPage(
    label: 'Новости',
    //icon: Icon(Icons.newspaper),

    icon: SvgPicture.asset('assets/icons/navbar/news.svg'),
    activeIcon: SvgPicture.asset(
      'assets/icons/navbar/news.svg',
      colorFilter: const ColorFilter.mode(
        Color.fromARGB(255, 255, 166, 0),
        BlendMode.srcIn,
      ),
    ),
    widget: NewsScreen(jwt: '',)
  ),
  HomeScreenPage(
    label: 'Расписание',
    icon: SvgPicture.asset('assets/icons/navbar/schedule.svg'),
    activeIcon: SvgPicture.asset(
      'assets/icons/navbar/schedule.svg',
      colorFilter: const ColorFilter.mode(
        Color.fromARGB(255, 255, 166, 0),
        BlendMode.srcIn,
      ),
    ),
    widget: const ScheduleScreen(),
  ),
  HomeScreenPage(
    label: 'Чаты',
    icon: SvgPicture.asset('assets/icons/navbar/chat.svg'),
    activeIcon: SvgPicture.asset(
      'assets/icons/navbar/chat.svg',
      colorFilter: const ColorFilter.mode(
        Color.fromARGB(255, 255, 166, 0),
        BlendMode.srcIn,
      ),
    ),
    widget: const MessengerScreen(),
  ),
  HomeScreenPage(
    label: 'ЛК',
    icon: SvgPicture.asset('assets/icons/navbar/account.svg'),
    activeIcon: SvgPicture.asset(
      'assets/icons/navbar/account.svg',
      colorFilter: const ColorFilter.mode(
        Color.fromARGB(255, 255, 166, 0),
        BlendMode.srcIn,
      ),
    ),
    widget: const AccountScreen(),
  ),
  HomeScreenPage(
    label: 'Сервисы',
    icon: SvgPicture.asset('assets/icons/navbar/services.svg'),
    activeIcon: SvgPicture.asset(
      'assets/icons/navbar/services.svg',
      colorFilter: const ColorFilter.mode(
        Color.fromARGB(255, 255, 166, 0),
        BlendMode.srcIn,
      ),
    ),
    widget: const ServicesScreen(),
  ),
];



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
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<HomeScreenPage>('pages', pages));
  }
}
