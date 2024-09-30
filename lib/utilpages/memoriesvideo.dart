import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Memoriesvideo extends StatefulWidget {
  const Memoriesvideo({super.key});

  @override
  State<Memoriesvideo> createState() => _MemoriesvideoState();
}

class _MemoriesvideoState extends State<Memoriesvideo> {
  final videoURL1 = "https://www.youtube.com/watch?v=yRdsbL4rgcM";
  final videoURL2 = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"; // Example second video URL
  late YoutubePlayerController _controller1;
  late YoutubePlayerController _controller2;
  bool _isFullScreen = false;

  @override
  void initState() {
    final videoID1 = YoutubePlayer.convertUrlToId(videoURL1);
    final videoID2 = YoutubePlayer.convertUrlToId(videoURL2);
    _controller1 = YoutubePlayerController(
      initialVideoId: videoID1!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: true,
        enableCaption: true,
      ),
    );
    _controller2 = YoutubePlayerController(
      initialVideoId: videoID2!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        controlsVisibleAtStart: true,
        enableCaption: true,
      ),
    );

    // Listen to changes in fullscreen mode for controller1
    _controller1.addListener(() {
      if (_controller1.value.isFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = _controller1.value.isFullScreen;
        });
      }
    });

    // Listen to changes in fullscreen mode for controller2
    _controller2.addListener(() {
      if (_controller2.value.isFullScreen != _isFullScreen) {
        setState(() {
          _isFullScreen = _controller2.value.isFullScreen;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: const Text("Old Videos"),
            ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            YoutubePlayer(
              controller: _controller1,
              showVideoProgressIndicator: true,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Memories of Childhood - Video 1',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            YoutubePlayer(
              controller: _controller2,
              showVideoProgressIndicator: true,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Memories of Childhood - Video 2',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
