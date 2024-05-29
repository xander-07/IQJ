import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iqj/features/auth/data/auth_service.dart';
import 'package:iqj/features/auth/domain/emailField.dart';
import 'package:iqj/features/auth/domain/passwordField.dart';
import 'package:iqj/features/auth/repo.dart';
import 'package:iqj/features/homescreen/presentation/homescreen.dart';
import 'package:iqj/main.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

void showChpwdDialog(BuildContext context) {
  final Widget okButton = TextButton(
    style: const ButtonStyle(
      overlayColor: MaterialStatePropertyAll(Color.fromARGB(64, 239, 172, 0)),
    ),
    child: const Text(
      "Закрыть",
      style: TextStyle(
        color: Color.fromARGB(255, 239, 172, 0),
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  final AlertDialog alert = AlertDialog(
    title: const Text(
      "Смена пароля",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    content: const Text("Todo"),
    actions: [
      okButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class _LoginScreenState extends State<AuthScreen> {
  String email = '';

  void _handlerEmailChanged(String emailadress) {
    email = emailadress;
  }

  bool passwordVisible = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    //const Color boxFillColor =  Color(0xFFF6F6F6);
    final GlobalKey<FormState> _formKey = GlobalKey();

    //final FocusNode _focusNodePassword = FocusNode();
    final TextEditingController _controllerEmail = TextEditingController();
    final TextEditingController _controllerPassword = TextEditingController();

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 72),
              const Text(
                "Вход",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Введите почту в домене @mirea.ru",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),
              EmailField(
                onEmailChanged: _handlerEmailChanged,
                controllerEmail: _controllerEmail,
              ),
              const SizedBox(height: 20),
              PasswordField(
                controllerPassword: _controllerPassword,
              ),
              const SizedBox(height: 20),
              Container(
                child: Transform.translate(
                  offset: const Offset(-10, 0),
                  child: TextButton(
                    style: const ButtonStyle(
                      overlayColor: MaterialStatePropertyAll(
                          Color.fromARGB(64, 239, 172, 0)),
                      //overlayColor: MaterialStatePropertyAll(Colors.transparent),
                    ),
                    child: const Text(
                      "Забыли пароль?",
                      style: TextStyle(
                        color: Color.fromARGB(255, 239, 172, 0),
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      showChpwdDialog(context);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: ElevatedButton.styleFrom(
                      //alignment: Alignment.center,
                      backgroundColor: const Color(0xFFEFAC00),
                      fixedSize: const Size(160, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        try {
                          await authService.signInWithEmailandPassword(
                            _controllerEmail.text,
                            _controllerPassword.text,
                          );


                          // Получаем UID после успешного входа
                          final user = authService.getCurrentUser(); 
                          final uid = user?.uid; // Используйте ? для безопасности, если getCurrentUser() может вернуть null
                          String jwt = 'hello';

                          if (uid != null) {
                            // Используйте UID
                            try{
                              final response = await post_uid(uid);
                              if (response.statusCode == 200) {
                                final data = jsonDecode(response.body); 
                                jwt = data.toString();
                                print(jwt);
                              }
                            }catch(e){
                              print("Ошитбка");
                            }
                            
                          }

                          Navigator.of(context).pushNamed(
                            '/',
                            arguments: jwt,
                          );


                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return const HomeScreen();
                          //     },
                          //   ),
                          // );
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('Ошибка входа!')));
                        }
                      }
                    },
                    child: const Text(
                      "Войти",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
