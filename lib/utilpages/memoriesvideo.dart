import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Memoriesvideo extends StatelessWidget {
  const Memoriesvideo({super.key});

  Future<void> _addSection(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final TextEditingController sectionController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Create New Section"),
        content: TextField(
          controller: sectionController,
          decoration: const InputDecoration(hintText: "Section Name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final sectionName = sectionController.text.trim();
              if (sectionName.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('sections')
                    .add({'title': sectionName});
              }
              Navigator.of(context).pop();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text("Please log in."));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Memories"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE3F2FD),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addSection(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('sections')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final sections = snapshot.data!.docs;
          return ListView.builder(
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              return Card(
                color: const Color(0xFFFFFFFF),
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  title: Text(
                    section['title'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCategoryPage(
                          sectionId: section.id,
                          title: section['title'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class VideoCategoryPage extends StatelessWidget {
  final String title;
  final String sectionId;

  const VideoCategoryPage({
    super.key,
    required this.title,
    required this.sectionId,
  });

  Future<void> _addVideo(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final TextEditingController videoTitleController = TextEditingController();
    final TextEditingController youtubeLinkController = TextEditingController();
    final picker = ImagePicker();
    File? videoFile;
    String videoType = "YouTube Link"; // Default option

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add New Video"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: videoTitleController,
                    decoration: const InputDecoration(hintText: "Video Title"),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: videoType,
                    items: [
                      "YouTube Link",
                      "Upload Video",
                    ].map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        videoType = value!;
                      });
                    },
                  ),
                  if (videoType == "YouTube Link") ...[
                    TextField(
                      controller: youtubeLinkController,
                      decoration:
                          const InputDecoration(hintText: "YouTube Link"),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () async {
                        final pickedFile =
                            await picker.pickVideo(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          videoFile = File(pickedFile.path);
                        }
                      },
                      child: const Text("Pick Video"),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final videoTitle = videoTitleController.text.trim();
                  if (videoTitle.isNotEmpty) {
                    if (videoType == "YouTube Link") {
                      final youtubeLink = youtubeLinkController.text.trim();
                      if (youtubeLink.isNotEmpty) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('sections')
                            .doc(sectionId)
                            .collection('videos')
                            .add({'title': videoTitle, 'url': youtubeLink});
                      }
                    } else if (videoFile != null) {
                      final storageRef = FirebaseStorage.instance.ref().child(
                          'users/$userId/videos/${videoFile!.path.split('/').last}');
                      final uploadTask = await storageRef.putFile(videoFile!);
                      final videoUrl = await uploadTask.ref.getDownloadURL();
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('sections')
                          .doc(sectionId)
                          .collection('videos')
                          .add({'title': videoTitle, 'url': videoUrl});
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("Add"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text("Please log in."));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE3F2FD),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addVideo(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('sections')
            .doc(sectionId)
            .collection('videos')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final videos = snapshot.data!.docs;
          return ListView.builder(
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              return Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.play_circle_fill,
                      color: Colors.purple, size: 36),
                  title: Text(
                    video['title'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    final videoUrl = video['url'];
                    if (videoUrl.startsWith("https://www.youtube.com")) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullscreenVideoPlayerDialog(videoUrl: videoUrl),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UploadedVideoPlayer(videoUrl: videoUrl),
                        ),
                      );
                    }
                  },
                ),
              );
            },
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
    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Player")),
      body: Center(
        child: Text(
            "YouTube Player: $videoUrl"), // Replace with YouTube Player Widget
      ),
    );
  }
}

class UploadedVideoPlayer extends StatelessWidget {
  final String videoUrl;

  const UploadedVideoPlayer({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Uploaded Video")),
      body: Center(
        child: Text(
            "Uploaded Video: $videoUrl"), // Replace with video player widget
      ),
    );
  }
}
