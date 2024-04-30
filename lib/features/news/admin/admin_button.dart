import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iqj/features/news/admin/general_news.dart';
import 'package:iqj/features/news/admin/special_news.dart';
import 'package:iqj/features/news/presentation/bloc/news_bloc.dart';
import 'package:iqj/features/news/presentation/screens/search/body_for_date/body.dart';

// не удаляйте плиз :) нужно потом будет

// void admin_button(BuildContext context,NewsBloc newsBloc) {
//   TextEditingController _titleController = TextEditingController();
//   TextEditingController _contentController = TextEditingController();
//   // final _newsBloc = newsBloc.BlocProvider(
//   //   create: (context) => NewsBloc(),
//   //   child: Container(),
//   // );
//   GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add News'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextField(
//                 controller: _titleController,
//                 decoration: InputDecoration(hintText: 'Title'),
//               ),
//               TextField(
//                 controller: _contentController,
//                 decoration: InputDecoration(hintText: 'Content'),
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Add'),
//               onPressed: () {
//                 // NewsModel news = NewsModel(
//                 //   title: _titleController.text,
//                 //   content: _contentController.text,
//                 // );
//                 // newsBloc.add(AddNews(news));
//                 final NewsSmall news = NewsSmall(
//                   thumbnail: "https://cdn.dummyjson.com/product-images/1/thumbnail.jpg",
//                 title: _titleController.text,
//                 date: "13.12.2005 :)",
//                 description: _contentController.text,
//                 );
//                 //newsbloc.add(AddNewsEvent(news: news));
//                 newsBloc.add(AddNewsEvent(news: news));
//                 Navigator.of(context).pop();
//                 Future.delayed(Duration.zero, () {
//                   _refreshIndicatorKey.currentState?.show();
//                 });
//               },
//             ),
//           ],
//         );
//       },
//     );
// }

Future<void> admin_button(BuildContext context) async {
  final AlertDialog alert = AlertDialog(
    title: Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const Padding(padding: EdgeInsets.only(right: 6)),
        const Flexible(
          child: Text(
            "Создать новость",
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    surfaceTintColor: Colors.white,
    content: two_button_add_news(context),
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return true;
        },
        child: alert,
      );
    },
  );
}

Widget two_button_add_news(BuildContext context) {
  return Container(
    height: 144,
    width: 325,
    decoration: BoxDecoration(
      color: Colors.transparent,
      border: Border(
        top: BorderSide(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
    ),
    child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        SizedBox(
          height: 65,
          width: 277,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
            child: Material(
              color: const Color.fromRGBO(239, 172, 0, 1),
              shape: const StadiumBorder(),
              elevation: 5.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SpecialNews(),
                    ),
                  );
                },
                child: const Center(
                  //padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'Важную',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 65,
          width: 277,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
            child: Material(
              color: const Color.fromRGBO(239, 172, 0, 1),
              shape: const StadiumBorder(),
              elevation: 5.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GeneralNews()),
                  );
                },
                child: const Center(
                  //padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'Общую',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
