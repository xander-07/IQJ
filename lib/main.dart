import 'package:flutter/material.dart';
import 'package:iqj/features/account/presentation/screens/account_screen.dart';
import 'package:iqj/features/auth/data/auth_gate.dart';
import 'package:iqj/features/auth/data/auth_service.dart';
import 'package:iqj/features/auth/presentation/screens/auth_screen.dart';
import 'package:iqj/features/homescreen/presentation/homescreen.dart';
import 'package:iqj/features/messenger/presentation/screens/chats_loaded_screen.dart';
import 'package:iqj/features/messenger/presentation/screens/group_chat_screen.dart';
import 'package:iqj/features/messenger/presentation/screens/create_group_screen.dart';
import 'package:iqj/features/messenger/presentation/screens/messenger_screen.dart';
import 'package:iqj/features/messenger/presentation/screens/page_group.dart';
import 'package:iqj/features/messenger/presentation/screens/user_page.dart';
import 'package:iqj/features/messenger/presentation/screens/users_add_selection.dart';
import 'package:iqj/features/news/presentation/screens/news_loaded_list_screen.dart';
import 'package:iqj/features/schedule/presentation/schedule_screen.dart';
import 'package:iqj/features/services/presentation/screens/about_screen.dart';
import 'package:iqj/features/services/presentation/screens/services_screen.dart';
import 'package:iqj/features/welcome/presentation/welcome.dart';
import 'package:iqj/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iqj/features/registration/presentation/reg_screen.dart';
import 'package:iqj/features/registration/presentation/successful_reg_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const App(), 
    ),
  );

  // Код для работы пуш-уведомлений для чата (android)
  // ВАЖНО: Может выдавать ошибки при сборке на Windows.
  // Их можно пропустить, приложение будет работать корректно.
  // На Windows не будет пуш-уведомлений.
//   final messaging = FirebaseMessaging.instance;
//   final settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//   String? token = await messaging.getToken();
//   //print("RegToken HERERERERRERE: " + token!);
//   final _messageStreamController = BehaviorSubject<RemoteMessage>();
//    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//    _messageStreamController.sink.add(message);
//  });

}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//  await Firebase.initializeApp();
// }


class App extends StatefulWidget {
  const App({super.key});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late bool firstLaunch = true;

  @override
  void initState() {
    _loadPreferences();
    super.initState();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(
      () {
        firstLaunch = prefs.getBool('firstLaunch') ?? true;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final NewsRepository _newsRepository = NewsRepository();

    return MaterialApp(
      title: 'IQJ',
      theme: lightTheme,
      darkTheme: darkTheme,
      initialRoute: firstLaunch ? 'welcome' : '/',
      routes: {
        '/': (context) => const HomeScreen(),
        'welcome': (context) => const Welcome(),
        'authorise': (context) => const AuthScreen(),
        'newslist': (context) => const NewsList(),
        'account': (context) => const AccountScreen(),
        'registration': (context) => const RegScreen(),
        'successreg': (context) => const SuccessReg(),
        'messenger': (context) =>
            const MessengerScreen(), // главная страница сообщений
        'chatslist': (context) => const ChatsList(), // это страница диолга
        'groupchat': (context) => const ChatsGroupList(), // это страница диолга
        'grouppage': (context) => const GroupPage(), // это страница с профилем(переход из чатов)
        'userpage' : (context) => const UserPage(),
        'addtogroup':(context) => const AddToGroupScreen(),  // добавление людей в группу
        'services': (context) => const ServicesScreen(),
        'about': (context) => const AboutScreen(),
        'schedule': (context) => const ScheduleScreen(),
        'creategroup' :(context) => const CreateGroupScreen(),
      },
      onUnknownRoute: (settings) {},
    );
  }
}
