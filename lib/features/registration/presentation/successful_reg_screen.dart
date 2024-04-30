import 'package:flutter/material.dart';

class SuccessReg extends StatefulWidget {
  const SuccessReg({super.key});

  @override
  State<SuccessReg> createState() => _SuccessRegState();
}

class _SuccessRegState extends State<SuccessReg> {

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            // Страница
            Align(
              child: PageView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 240,
                        width: 360,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/welcome/registration_1.png'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Вы успешно \nзарегестрировались!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 33,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context)
                                .colorScheme
                                .onBackground,
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 50,
                      ),
                      Image.asset('assets/images/welcome/registration_2.png'),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Кнопка
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 60,
                    width: 300,
                    child: Stack(
                      children: [
                        //Продолжить
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                                Navigator.pushReplacementNamed(context, '/');
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Align(
                                child: Text(
                                  'Продолжить',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 55),
                ],
              ),
            ),
          ],
        ),
      );
}