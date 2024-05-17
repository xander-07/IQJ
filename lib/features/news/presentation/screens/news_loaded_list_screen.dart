// import 'dart:js';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:iqj/features/news/domain/news.dart';
// import 'package:iqj/features/news/presentation/bloc/news_bloc.dart';
// import 'package:iqj/features/news/presentation/bloc/news_loaded_bloc.dart';

// class NewsList extends StatefulWidget {
//   const NewsList({Key? key}) : super(key: key);
//   @override
//   State<StatefulWidget> createState() => _NewsListState();
// }
// class _NewsListState extends State<NewsList> {
//   late News news;
//   bool flagOpenTags = false;
//   void openCloseTags() {
//     setState(() {
//       flagOpenTags = !flagOpenTags;
//     });
//   }
//   @override
//   void didChangeDependencies() {
//     final args = ModalRoute.of(context as BuildContext)?.settings.arguments;
//     assert(args != null && args is News, "Check args");
//     news = args as News;
//     setState(() {});
//     super.didChangeDependencies();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 72,
//         scrolledUnderElevation: 0,
//         actions: [
//           Container(
//             padding: const EdgeInsets.only(right: 12),
//             child: Row(
//               children: [
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.bookmarks_outlined),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: const Icon(Icons.more_vert),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       body: Expanded(
//         child: BlocBuilder<NewsLoadBloc, NewsLoadState>(
//           builder: (context, state) {
//             if (state is NewsLoadLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (state is NewsLoadLoaded) {
//               return Container(child: Text('hi'),);
//             } else if (state is NewsLoadListLoadingFail) {
//               return Center(
//                 child: Text(state.except?.toString() ?? "Error"),
//               );
//             }
//             return const Center(child: CircularProgressIndicator());
//           },
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:iqj/features/news/data/news_repository.dart';
import 'package:iqj/features/news/domain/news.dart';
import 'package:intl/intl.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:iqj/features/news/presentation/bloc/news_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:iqj/features/news/data/bookmarks.dart';

abstract class NewsLoadEvent {}

class FetchNews extends NewsLoadEvent {}

class LoadNewsLoadList extends NewsLoadEvent {
  //final String id;
  final Completer? completer;
  LoadNewsLoadList({required this.completer});
  List<Object?> get props => [completer];
}

// States
abstract class NewsLoadState {}

class NewsLoadInitial extends NewsLoadState {}

class NewsLoadLoading extends NewsLoadState {}

class NewsLoadLoaded extends NewsLoadState {
  final News news;
  bool flagOpenTags = false;
  NewsLoadLoaded(this.news, this.flagOpenTags);

  //News get news => null;
}

class NewsLoadError extends NewsLoadState {
  final String errorMessage;
  NewsLoadError(this.errorMessage);
}

class NewsLoadListLoadingFail extends NewsLoadState {
  final Object? except;
  NewsLoadListLoadingFail({required this.except});
  List<Object?> get pros => [except];
}

class NewsLoadBloc extends Bloc<NewsLoadEvent, NewsLoadState> {
  final String id;
  NewsLoadBloc(this.id) : super(NewsLoadInitial()) {
    print("init bloc");
    on<LoadNewsLoadList>((event, emit) async {
      try {
        if (state is! NewsLoadLoaded) {
          print("news load loading now");
          emit(NewsLoadLoading());
        }
        print("Start load news "+id);
        final News news = await getNewsFull(id);
        print("News loaded");
        emit(NewsLoadLoaded(news, false));
      } catch (e) {
        print("error: " + NewsLoadListLoadingFail(except: e).toString());
        emit(NewsLoadListLoadingFail(except: e));
      } finally {
        event.completer?.complete();
      }
    });
  }
}

Future<News> getNewsFull(String id) async {
  final response = await http.get(
    Uri(
      scheme: 'https',
      host: 'mireaiqj.ru',
      port: 8443,
      path: '/news',
      queryParameters: {'id': id},
    ),
  );
  if (response.statusCode == 200) {
    final dynamic decodedData = json.decode(response.body);
    //print(decodedData);
    List<News> newsList = [];
    if (decodedData is List) {
      newsList = List<News>.from(
        decodedData.map(
          (json) => News(
            id: json['id'] as String,
            title: json['header'] as String,
            link: json['link'] as String,
            description: json['content'].toString(),
            thumbnails: json['image_link'] == null
                ? ''
                : json['image_link'][0] as String,
            tags: [],
            publicationTime: DateTime.parse(json['publication_time'] as String),
            bookmarked: false,
          ),
        ),
      );
      print(decodedData);
    } else if (decodedData is Map<String, dynamic>) {
      List<dynamic> dynamicList = decodedData['tags']==null? [] : decodedData['tags'] as List<dynamic>;
      List<String> stringList = dynamicList.map((item) => item.toString()).toList();
      final News news = News(
        id: decodedData['id'].toString(),
        title: decodedData['header'] as String,
        publicationTime:
            DateTime.parse(decodedData['publication_time'] as String),
        thumbnails: decodedData['image_link'] == null
                ? ''
                : decodedData['image_link'][0] as String,
            tags: stringList ,
        link: decodedData['link'] as String,
        description: decodedData['content'] as String,
        bookmarked: false,
      );
      print(newsList);
      newsList.add(news);
    }
    print(newsList[0]);
    return newsList[0];
  } else {
    throw Exception(response.statusCode);
  }
}

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args =
        ModalRoute.of(context)!.settings.arguments! as Map<String, String>;
    final String newsId = args['id']!;
    final String newsLink = args['link']!;

    return BlocProvider(
      create: (context) => NewsLoadBloc(newsId),
      child: _NewsListWidget(newsId: newsId, newsLink: newsLink,),
    );
  }
}

class _NewsListWidget extends StatefulWidget {
  final String newsId;
  final String newsLink;

  _NewsListWidget({required this.newsId, required this.newsLink, Key? key}) : super(key: key);

  @override
  __NewsListWidgetState createState() => __NewsListWidgetState();
}

class __NewsListWidgetState extends State<_NewsListWidget> {
  bool flagOpenTags = true;
  bool bookmarked = false;
  Map dataf = {};
  // late final NewsLoadBloc _newsLoadBloc;

  // void _initializeBloc() async {
  //   _newsLoadBloc = NewsLoadBloc('15');
  //   //await _newsLoadBloc.initialize(); // Предполагается, что у вашего блока есть метод инициализации
  // }

  @override
  Widget build(BuildContext context) {
    final NewsLoadBloc bloc = context.read<NewsLoadBloc>();
    final loadCompleter = Completer();
    bloc.add(
      LoadNewsLoadList(
        completer: loadCompleter,
      ),
    );


    void openCloseTags() {
      setState(() {
        flagOpenTags = !flagOpenTags;
      });
    }

    void bookmarkFlagger() {
      setState(() {
        bookmarked = !bookmarked;
      });
    }

    Future<void> checkBookmarked() async {
      List<String> bookmarks = await BookmarkProvider.getBookmarks();

      if (bookmarks.contains(widget.newsId)) {
        bookmarked = true;
      }
    }

    checkBookmarked();

    Widget _buildThumbnailImage(String image) {
      try {
        return Container(
          margin: const EdgeInsets.only(top: 12),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              image,
              fit: BoxFit.fitWidth,
              height: 256,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Container();
              },
            ),
          ),
        );
      } catch (e) {
        return Container();
      }
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider<NewsLoadBloc>(
          create: (_) => bloc,
        ),
      ],
      child: BlocBuilder<NewsLoadBloc, NewsLoadState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is NewsLoadLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is NewsLoadLoaded) {
            final News news = state.news;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Новость'),
                actions: [
                  Container(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            bookmarkFlagger();
                            BookmarkProvider.toggleBookmark(widget.newsId);
                          },
                          icon: bookmarked
                              ? (Icon(
                                  Icons.bookmark_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                ))
                              : (const Icon(
                                  Icons.bookmark_outline_rounded,
                                )),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (String choice) {
                            handleMenuSelection(
                              choice,
                              context,
                              DateFormat('dd.MM.yyyy hh:mm')
                                  .format(news.publicationTime),
                              widget.newsId, widget.newsLink,
                            );
                          },
                          itemBuilder: (BuildContext context) {
                            return {'Поделиться...', 'Подробнее...'}
                                .map((String choice) {
                              return choice == "Поделиться..."
                                  ? PopupMenuItem<String>(
                                      value: choice,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.share_outlined),
                                          const Padding(
                                            padding: EdgeInsets.only(right: 12),
                                          ),
                                          Text(choice),
                                        ],
                                      ),
                                    )
                                  : PopupMenuItem<String>(
                                      value: choice,
                                      child: Row(
                                        children: [
                                          const Icon(
                                              Icons.info_outline_rounded),
                                          const Padding(
                                            padding: EdgeInsets.only(right: 12),
                                          ),
                                          Text(choice),
                                        ],
                                      ),
                                    );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              body: MultiBlocProvider(
                providers: [
                  BlocProvider<NewsLoadBloc>(
                    create: (_) => bloc,
                  ),
                ],
                child: BlocBuilder<NewsLoadBloc, NewsLoadState>(
                  bloc: bloc,
                  builder: (context, state) {
                    if (state is NewsLoadLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is NewsLoadLoaded) {
                      final News news = state.news;
                      final List<String> tags = news.tags.sublist(1);
                      final NewsTags ntags = NewsTags(tags: tags,);
                      return ListView(
                        children: [
                          Card(
                            elevation: 2,
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 12,
                                        right: 12,
                                      ),
                                      width: double.infinity,
                                      child:
                                          _buildThumbnailImage(news.thumbnails),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 6),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                news.title,
                                                style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  // title,
                                                  // style: textTheme.titleLarge
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              DateFormat('dd.MM.yyyy hh:mm')
                                                  .format(news.publicationTime),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "ID: ${widget.newsId}",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurfaceVariant,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                if (flagOpenTags)
                                                  IconButton(
                                                    onPressed: () {
                                                      openCloseTags();
                                                    },
                                                    icon: //SvgPicture.asset('assets/icons/news/open_tags.svg'),
                                                        const Icon(
                                                      Icons.expand_more_rounded,
                                                    ),
                                                  )
                                                else
                                                  IconButton(
                                                    onPressed: () {
                                                      openCloseTags();
                                                    },
                                                    icon: //SvgPicture.asset('assets/icons/news/open_tags_yel.svg'),
                                                        Icon(
                                                      Icons.expand_less_rounded,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        if (!flagOpenTags) ntags,
                                        Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                                width: 2,
                                              ),
                                              //bottom: BorderSide(color: Color.fromRGBO(202, 196, 208, 1), width: 2),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        //Text(news?.description ?? '...'),  ////////////// РАСКОММЕНТИРОВАТЬ КОГДА АПИ БУДЕТ ГОТОВО
                                        Linkify(
                                          // onOpen: (link) async { FIX ME
                                          //   if (!await launchUrl(Uri.parse(link.url))) {
                                          //     throw Exception('Could not launch ${link.url}');
                                          //   }
                                          // },
                                          text: cleanText(news.description),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontSize: 16,
                                          ),
                                          linkStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 16,
                                            decorationColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (state is NewsLoadListLoadingFail) {
                      return Center(
                        child: Text(state.except?.toString() ?? "Error"),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Новость'),
            ),
            body: const Center(child: Text('Ошибка')),
          );
        },
      ),
    );
  }
}

class NewsTags extends StatelessWidget {
  final List<String>tags;

  const NewsTags({super.key, required this.tags});
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 250),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Wrap(
          spacing: 10, // <-- Добавляем отступ между элементами Wrap
          runSpacing: 10, 
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            tags.length,
            (index) => Container(
              margin: const EdgeInsets.only(right: 5),
              //padding: EdgeInsets.all(10),
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: TextButton(
                onPressed: () {
                  // Переходим к ленте новостей с фильтром по нажатому тегу
                },
                child: Text(
                  tags[index], // берем название тега из массива
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String cleanText(String text) {
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');
  text = text.replaceAll('\t', '');
  return text;
}

void handleMenuSelection(
  String choice,
  BuildContext context,
  String newsDate,
  String newsId,
  String newsLink,
) {
  if (choice == 'Поделиться...') {
    Share.share('Прочитайте эту новость МИРЭА: $newsLink');
  } else if (choice == 'Подробнее...') {
    showDetailsDialog(context, newsDate, newsId);
  }
}

void showDetailsDialog(
  BuildContext context,
  String newsDate,
  String newsId,
) {
  final Widget closeButton = TextButton(
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
      "Детали",
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.surface,
    content: SizedBox(
      height: double.minPositive + 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Дата публикации: $newsDate'),
          Text('ID: $newsId'),
          //Linkify(text: 'Ссылка: $newsLink'),
        ],
      ),
    ),
    actions: [
      closeButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
