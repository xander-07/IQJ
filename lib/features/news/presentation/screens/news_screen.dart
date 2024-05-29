// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iqj/features/news/admin/admin_button.dart';
import 'package:iqj/features/news/data/bookmarks.dart';
import 'package:iqj/features/news/domain/news.dart';
import 'package:iqj/features/news/presentation/bloc/news_bloc.dart';
import 'package:iqj/features/news/presentation/bloc/search_bloc.dart';
import 'package:iqj/features/news/presentation/bloc/special_news_bloc.dart';
import 'package:iqj/features/news/presentation/screens/announcement.dart';
import 'package:iqj/features/news/presentation/screens/news_loaded_list.dart';
import 'package:iqj/features/news/presentation/screens/news_loaded_list_screen.dart';
import 'package:iqj/features/news/presentation/screens/search/search_date.dart';
import 'package:iqj/features/news/presentation/screens/search/search_tags.dart';

class NewsScreen extends StatefulWidget {
  final String jwt;
  const NewsScreen({super.key, required this.jwt});

  @override
  State<NewsScreen> createState() => _NewsBloc();
}

class _NewsBloc extends State<NewsScreen> {
  //final _newsbloc=NewsBloc(newsRepository)
  //List<News>? _news_list;
  // final newsList = getNews();
  // final _newsbloc=NewsBloc(NewsArticle());
  //final newsList=NewsSmall();
  final _newsbloc = NewsBloc();
  final _specialNewsBloc = SpecialNewsBloc();

  static get title => null;

  @override
  void initState() {
    _newsbloc.add(LoadNewsList(completer: null));
    super.initState();
  }

  bool _isFilter = false;
  void searchfilter() {
    setState(() {
      _isFilter = !_isFilter;
    });
  }

  bool flag_close = true;
  void announce_close() {
    setState(() {
      flag_close = false;
    });
  }

  bool _isBookmarkedView = false;
  bool bookmarked = false;

  Future<List<NewsList>> _getFilteredNews(
      List<NewsList> newsList, String id) async {
    if (_isBookmarkedView) {
      List<String> bookmarkedNewsIds = await BookmarkProvider.getBookmarks();
      return newsList.where((news) => bookmarkedNewsIds.contains(id)).toList();
    } else {
      return newsList;
    }
  }

  Future<bool> checkBookmarked(String id) async {
    List<String> bookmarks = await BookmarkProvider.getBookmarks();

    if (bookmarks.contains(id)) {
      return true;
    }
    return false;
  }

  TextEditingController _searchController = TextEditingController();
  bool flag_search = false;
  void change_search_flag() {
    setState(() {
      flag_search = !flag_search;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final newsBloc = BlocProvider.of<NewsBloc>(context);
    // newsBloc.add(FetchNews());
    //final _newslistbloc=NewsBloc(context);
    final newsBloc = NewsBloc();
    GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    GlobalKey<RefreshIndicatorState> _refreshIndicatorKeySpecial =
        GlobalKey<RefreshIndicatorState>();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('News'),
      // ),
      floatingActionButton: Container(
        width: 52.0, // Задаем ширину
        height: 52.0, // Задаем высоту
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary, // Цвет кнопки
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: IconButton(
          onPressed: () {
            admin_button(context,widget.jwt);
          },
          icon: const Icon(Icons.edit),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 72,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: _isFilter
            ? Container(
                width: 500,
                height: 45,
                margin: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onInverseSurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Поиск по заголовку...",
                      hintFadeDuration: const Duration(milliseconds: 100),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      hintStyle: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                        height: 4,
                        color: Color.fromRGBO(128, 128, 128, 0.6),
                      ),
                      suffixIcon: SizedBox(
                        child: IconButton(
                          icon: const Icon(
                            Icons.search,
                          ),
                          onPressed: () {
                            change_search_flag();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Text(
                'Новости',
                style: Theme.of(context).textTheme.titleLarge,
              ),
        centerTitle: false,
        actions: _isFilter
            ? [
                Container(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          //announce_close();
                          searchfilter();
                        },
                        //icon: SvgPicture.asset('assets/icons/news/filter2.svg'),
                        icon: Icon(
                          Icons.tune_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).colorScheme.primary.withAlpha(64),
                        )),
                      ),
                    ],
                  ),
                ),
              ]
            : [
                Container(
                  padding: const EdgeInsets.only(right: 12),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isBookmarkedView = !_isBookmarkedView;
                          });
                        },
                        icon: _isBookmarkedView
                            ? Icon(
                                Icons.bookmarks_rounded,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : const Icon(Icons.bookmarks_outlined),
                        style: _isBookmarkedView
                            ? ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha(64),
                              ))
                            : const ButtonStyle(),
                      ),
                      IconButton(
                        onPressed: () {
                          searchfilter();
                        },
                        icon: //SvgPicture.asset('assets/icons/news/filter2.svg'),
                            _isFilter
                                ? Icon(
                                    Icons.tune_rounded,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : const Icon(Icons.tune_rounded),
                      ),
                    ],
                  ),
                ),
              ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isFilter)
            Container(
              margin: const EdgeInsets.only(
                  top: 12, left: 12, right: 12, bottom: 12),
              padding: const EdgeInsets.only(left: 12, right: 12),
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      //crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(50),
                            borderRadius: BorderRadius.circular(24.0),
                            color: const Color.fromRGBO(239, 172, 0, 1),
                          ),
                          child: TextButton(
                            onPressed: () {
                              searchdata(context);
                            },
                            child: const Text(
                              "По дате:                                  ",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 35,
                          decoration: BoxDecoration(
                            //borderRadius: BorderRadius.circular(50),
                            borderRadius: BorderRadius.circular(24.0),
                            color: const Color.fromRGBO(239, 172, 0, 1),
                          ),
                          child: TextButton(
                            onPressed: () {
                              search_tags(context);
                            },
                            child: const Text(
                              "По тегам:                                ",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (flag_close)
            Container(
              margin: const EdgeInsets.only(left: 14, right: 12),
              child: Text(
                'Важные',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0,
                  height: 1.5,
                ),
              ),
            ),
          BlocBuilder<SpecialNewsBloc, SpecialNewsLoadState>(
            bloc: _specialNewsBloc,
            builder: (context, state) {
              if (state is SpecialNewsLoadLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SpecialNewsLoadLoaded) {
                return ListView.builder(
                  itemCount: state.newsList.length,
                  itemBuilder: (context, index) {
                    final news = state.newsList[index];
                    print('announcement return:');
                    return AnnouncementWidget(
                      id: news.id,
                      text: news.text,
                      creationDate: news.publishFromTime,
                      expiryDate: news.publishUntilTime,
                    );
                  },
                );
              } else if (state is SpecialNewsLoadListLoadingFail) {
                return Center(
                  child: Text(state.except?.toString() ?? "Error"),
                );
              }
              print('announcement fallback');
              return AnnouncementWidget(
                id: '1',
                text: 'С 35 нояктября по 64 апремая в корпусе В-78 будет закрыт главный вход. ',
                creationDate: DateTime.now(),
                expiryDate: DateTime.now(),
              );
            },
          ),
          if (flag_close)
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12),
              child: Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
          Container(
            margin: const EdgeInsets.only(left: 14, right: 12, top: 10),
            child: Text(
              'Общее',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
                fontSize: 24.0,
                height: 1.5,
              ),
            ),
          ),
          flag_search 
          ? SearchNews(_searchController.text)
          :  Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: () async {
                final completer = Completer();
                _newsbloc.add(LoadNewsList(completer: completer));
                return completer.future;
              },
              child: BlocBuilder<NewsBloc, NewsState>(
                bloc: _newsbloc,
                builder: (context, state) {
                  if (state is NewsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is NewsLoaded) {
                    // return ListView.builder(
                    //   itemCount: state.newsList.length,
                    //   itemBuilder: (context, index) {
                    //     final news = state.newsList[index];
                    //     return ListTile(
                    //       title: Text(news.title),
                    //       subtitle: Text(news.description),
                    //     );
                    //   },
                    // );
                    final List<News> filteredNews = state.newsList
                        .where((news) =>
                            _isBookmarkedView ? news.bookmarked : true)
                        .toList();
                    if (filteredNews.isEmpty && _isBookmarkedView) {
                      return Center(
                        child: Text(
                          'Закладок нет.',
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    // return ListView.builder(
                    //   itemCount: state.newsList.length,
                    //   itemBuilder: (context, index) {
                    //     final news = state.newsList[index];
                    //     return FutureBuilder<bool>(
                    //       future: checkBookmarked(state.newsList[index].id),
                    //       builder: (context, snapshot) {
                    //         if (snapshot.connectionState ==
                    //             ConnectionState.waiting) {
                    //           return Container();
                    //         } else {
                    //           final bool ff = snapshot.data!;
                    //           return NewsCard(
                    //             news: news,
                    //             bookmarked: ff,
                    //           );
                    //         }
                    //       },
                    //     );
                    //   },
                    // );

                    // Old
                    //   return ListView.builder(
                    //   itemCount: state.newsList.length,
                    //   itemBuilder: (context, index) {
                    //     final news = state.newsList[index];
                    //     return NewsCard(
                    //       news: news,
                    //       bookmarked: true,
                    //     );
                    //   },
                    // );

                    return ListView.builder(
                      itemCount: state.newsList.length,
                      itemBuilder: (context, index) {
                        final news = state.newsList[index];
                        return NewsCard(
                          news: news,
                          bookmarked: news.bookmarked,
                          onBookmarkToggle: () {
                            if (news.bookmarked) {
                              news.bookmarked = false;
                            } else {
                              news.bookmarked = true;
                            }
                            BlocProvider.of<NewsBloc>(context)
                                .add(CheckBookmark(news: news));
                          },
                        );
                      },
                    );
                  } else if (state is NewsListLoadingFail) {
                    return Center(
                      child: Text(state.except?.toString() ?? "Error"),
                    );
                  } // else {
                  //   return Container();
                  // }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchNews extends StatelessWidget{
  String text;

  SearchNews(this.text,{super.key});
  @override
  Widget build(BuildContext context) {
    

    return BlocProvider(
      create: (context) => SearchBloc(text),
      child: _SearchWidget(text: text,),
    );
  }
}


class _SearchWidget extends StatefulWidget{
  // final String newsId;
  // final String newsLink;
  final  String text;

  _SearchWidget({required this.text, Key? key}) : super(key: key);


  @override
  _SearchState createState() => _SearchState();

}

class _SearchState extends State<_SearchWidget> {
  late final SearchBloc _bloc;
  late final Completer _loadCompleter;

  @override
  void initState() {
    super.initState();
    _bloc = SearchBloc(widget.text);
    _loadCompleter = Completer();
    _bloc.add(SearchNewsLoadList(completer: _loadCompleter));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocProvider<SearchBloc>(
        create: (_) => _bloc,
        child: BlocBuilder<SearchBloc, SearchNewsState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SearchLoaded) {
              print(state.news);
              return ListView.builder(
                        itemCount: state.news.length,
                        itemBuilder: (context, index) {
                          final news = state.news[index];
                          return NewsCard(
                            news: news,
                            bookmarked: news.bookmarked,
                            onBookmarkToggle: () {
                              if (news.bookmarked) {
                                news.bookmarked = false;
                              } else {
                                news.bookmarked = true;
                              }
                              BlocProvider.of<NewsBloc>(context)
                                  .add(CheckBookmark(news: news));
                            },
                          );
                        },
                      );
            } else if (state is SearchFail) {
              return Center(
                          child: Text(state.except?.toString() ?? "Error"),
                        );
            } else {
              
              return Text('aaaaaaaaaaaaaaaa'); 
            }
          },
        ),
      ),
    );
  }
}
