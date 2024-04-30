import 'package:flutter/material.dart';
import 'package:iqj/features/auth/domain/emailField.dart';
import 'package:iqj/features/registration/data/registration_data.dart';
import 'package:iqj/features/registration/domain/surnameField.dart';
import 'package:iqj/features/registration/domain/nameField.dart';
import 'package:iqj/features/registration/domain/patronymicField.dart';
import 'package:iqj/features/registration/domain/roleField.dart';
import 'package:iqj/features/registration/domain/passwordField.dart';
import 'package:iqj/features/registration/domain/repPasswordField.dart';
import 'package:iqj/main.dart';

// String globalSurname = '';
// String globalName = '';
// String globalPatronymic = '';



class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

//добавить сравнение паролей, обработку ошибок
//изменить поле роль

class _LoginScreenState extends State<RegScreen> {
  String password = '';
  String repassword = '';
  String email = '';
  bool globalchekpass = true;

  void _handlePasswordChanged(String pass) {
      password = pass;
  }
  void _handlerePasswordChanged(String repass) {
      repassword = repass;
  }
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

    return  Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),
                const Text(
                  "Регистрация",
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),
                EmailField(onEmailChanged: _handlerEmailChanged, controllerEmail: _controllerEmail,),
                const SizedBox(height: 20),
                //SurnameField(onTextSubmitted: saveSurname),
                //const SizedBox(height: 20),
                //NameField(onTextSubmitted: saveName),
                //const SizedBox(height: 20),
                //PatronymicField(onTextSubmitted: savePatronymic),
                //const SizedBox(height: 20),
                //RoleField(),
                //const SizedBox(height: 20),
                PasswordField(onPasswordChanged: _handlePasswordChanged),
                const SizedBox(height: 20),
                RepPasswordField(onPasswordChanged: _handlerePasswordChanged),
                // const SizedBox(height: 20),
                const SizedBox(height: 180),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: ElevatedButton.styleFrom(
                        //alignment: Alignment.center,
                        backgroundColor: const Color(0xFFEFAC00),
                        fixedSize: const Size(285, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      onPressed: () {
                        // if (_formKey.currentState?.validate() ?? false) {
                          print("TYT VIVODIT SLOVA");
                          print(email);
                          print(password);
                          print(repassword);
                          if (password == repassword){
                            sendData(email, password);
                            Navigator.pushReplacementNamed(context, 'successreg');
                          }
                          if (password != repassword){
                            globalchekpass = false;
                          }
                          print(globalchekpass);
                      },
                      child: const Text(
                        "Регистрация",
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
              // if (globalchekpass == false) {
              //     SizedBox(height: 20),
              //     Text('Пароли не совпадают'),
              // }
              ],
            ),
          ),
        ),
      );
  }
}
