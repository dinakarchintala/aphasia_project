import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// void main() {
//   // Lock orientation to landscape mode for the entire app
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.landscapeRight,
//     DeviceOrientation.landscapeLeft,
//   ]);

//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memories Video',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Memoriesvideo(),
    );
  }
}

class Memoriesvideo extends StatelessWidget {
  const Memoriesvideo({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> sections = [
      {
        "title": "Family",
        "videos": [
          {
            "title": "Family Picnic",
            "url": "https://www.youtube.com/watch?v=yRdsbL4rgcM"
          },
          {
            "title": "Family Reunion",
            "url": "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
          },
        ],
      },
      {
        "title": "Home",
        "videos": [
          {
            "title": "Home Sweet Home",
            "url": "https://www.youtube.com/watch?v=e4oTTuLISaE"
          },
          {
            "title": "Celebrations at Home",
            "url": "https://www.youtube.com/watch?v=L_jWHffIx5E"
          },
        ],
      },
      {
        "title": "Religious Places",
        "videos": [
          {
            "title": "Visit to Temple",
            "url": "https://www.youtube.com/watch?v=C0DPdy98e4c"
          },
          {
            "title": "Pilgrimage Memories",
            "url": "https://www.youtube.com/watch?v=3JWTaaS7LdU"
          },
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Memories"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFE3F2FD),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return Card(
            color: Color(0xFFFFFFFF),
            margin: const EdgeInsets.all(12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(
                sections[index]['title'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCategoryPage(
                      title: sections[index]['title'],
                      videos: sections[index]['videos'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class VideoCategoryPage extends StatelessWidget {
  final String title;
  final List<Map<String, String>> videos;

  const VideoCategoryPage({
    super.key,
    required this.title,
    required this.videos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Card(
            margin: const EdgeInsets.all(12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.play_circle_fill,
                  color: Colors.purple, size: 36),
              title: Text(
                video['title']!,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Directly play video in fullscreen without navigating
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return FullscreenVideoPlayerDialog(
                      videoUrl: video['url']!,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class FullscreenVideoPlayerDialog extends StatelessWidget {
  final String videoUrl;

  const FullscreenVideoPlayerDialog({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          YoutubePlayerWidget(videoUrl: videoUrl),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop(); // Close the fullscreen dialog
              },
            ),
          ),
        ],
      ),
    );
  }
}

class YoutubePlayerWidget extends StatefulWidget {
  final String videoUrl;

  const YoutubePlayerWidget({super.key, required this.videoUrl});

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        controlsVisibleAtStart: true,
        enableCaption: true,
        hideControls: true, // Show controls for fullscreen video
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      onReady: () {
        // Optional: Handle when player is ready
      },
    );
  }
}
