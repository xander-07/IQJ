import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:iqj/features/auth/presentation/screens/auth_screen.dart";
import "package:iqj/features/homescreen/presentation/homescreen.dart";
import "package:iqj/features/welcome/presentation/welcome.dart";
import "package:shared_preferences/shared_preferences.dart";

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // logged in
          if (snapshot.hasData){
            return const HomeScreen();
          }
          // logged out
          else {
            if (_getFirstLaunch() == true) {
              return const Welcome();
            } else {
              return const AuthScreen();
            }
          }
        },
      )
    );
  }

   Future<bool> _getFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstLaunch') ?? true;
    //return false;
  }
}
