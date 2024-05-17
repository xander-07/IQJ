import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioWidget extends StatefulWidget {
  final File file;

  AudioWidget({required this.file});

  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    playAudio();
  }

   Future<void> playAudio() async {
    await audioPlayer.play(widget.file.path as Source);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox.shrink(),
    );
  }
}




// class WordDocumentWidget extends StatelessWidget {
//   final File file;
//   final BuildContext context;

//   WordDocumentWidget({required this.file, required this.context});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PDFViewerScaffold(
//               appBar: AppBar(
//                 title: Text("Документ"),
//               ),
//               path: file.path,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         child: Center(
//           child: Icon(Icons.picture_as_pdf),
//         ),
//       ),
//     );
//   }
// }

class VideoWidget extends StatefulWidget {
  final File file;

  VideoWidget({required this.file});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.file(widget.file);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
