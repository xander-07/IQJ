import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iqj/features/welcome/data/welcome_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _controller = PageController();
  bool onFirstPage = true;
  bool onLastPage = false;

  // Запись в память успешного прохождения начальных экранов.
  Future<void> userWelcomed() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('firstLaunch', false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            // Страницы
            Align(
              child: PageView.builder(
                controller: _controller,
                itemCount: welcomePanelList.length,
                onPageChanged: (index) {
                  setState(() {
                    onLastPage = index == welcomePanelList.length - 1;
                    onFirstPage = index == 0;
                  });
                },
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (welcomePanelList[index].imagePosition == 'top')
                        Image.asset(welcomePanelList[index].image!),
                      if (welcomePanelList[index].title != null)
                        Align(
                          alignment: welcomePanelList[index].text == null
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: Text(
                            welcomePanelList[index].title!,
                            textAlign: welcomePanelList[index].text == null
                                ? TextAlign.center
                                : TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context)
                                .colorScheme
                                .onBackground,
                            ),
                          ),
                        ),
                      if (welcomePanelList[index].text != null)
                        Text(
                          welcomePanelList[index].text!,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                          ),
                        ),
                      if (welcomePanelList[index].imagePosition == 'bottom')
                        Image.asset(welcomePanelList[index].image!),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Кнопки и индикатор
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Индикатор
                  if (!onLastPage)
                    SmoothPageIndicator(
                      controller: _controller,
                      count: welcomePanelList.length - 1,
                      effect: JumpingDotEffect(
                        activeDotColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        dotColor: Theme.of(context).colorScheme.surfaceVariant
                      ),
                    ),
                    const SizedBox(height: 32),
                  if (onLastPage)
                    // SizedBox(
                    //   height: 60,
                    //   width: 300,
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: GestureDetector(
                    //       onTap: () {
                    //         userWelcomed();
                    //         Navigator.pushReplacementNamed(context, 'registration');
                    //       },
                    //       child: Container(
                    //         height: 60,
                    //         width: 300,
                    //         decoration: BoxDecoration(
                    //             color: Theme.of(context)
                    //                 .colorScheme
                    //                 .inversePrimary,
                    //             borderRadius:
                    //                 const BorderRadius.all(Radius.circular(30)),
                    //           ),
                    //         child: Align( 
                    //           alignment: Alignment.center, 
                    //           child: Text(
                    //             'Регистрация',
                    //             style: TextStyle(
                    //               fontFamily: 'Inter',
                    //               fontSize: 20,
                    //               fontWeight: FontWeight.w600,
                    //               color: Theme.of(context)
                    //                   .colorScheme
                    //                   .onPrimaryContainer,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 60,
                    width: 300,
                    child: Stack(
                      children: [
                        // Назад
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          alignment: onFirstPage
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              _controller.previousPage(
                                duration: const Duration(milliseconds: 240),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Icon(
                                Icons.chevron_left_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                                size: 42,
                              ),
                            ),
                          ),
                        ),
                        // Далее
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              if (onLastPage) {
                                userWelcomed();
                                Navigator.pushReplacementNamed(context, 'authorise');
                              } else {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 240),
                                  curve: Curves.ease,
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              width: (onFirstPage || onLastPage)
                                  ? 300
                                  : 225, //На первой странице кнопка "дальше" просто перекрывает "назад"
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Align(
                                child: Text(
                                  onLastPage ? 'Вход' : 'Далее',
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
