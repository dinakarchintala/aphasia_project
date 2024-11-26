import 'dart:async';

import 'package:aphasia_bot/utilis/voicerec.dart';
import 'package:flutter/material.dart';
// Make sure to import this package

// ... (Your ListeningMicButton widget code from the previous response)

class Speakingword extends StatefulWidget {
  const Speakingword({super.key});

  @override
  _SpeakingwordState createState() => _SpeakingwordState();
}

class _SpeakingwordState extends State<Speakingword> {
  Timer? _feedbackTimer;
  int current_index = 0;
  String feedbackText = 'Speak the word';
  List<String> Images = [
    "School",
    "Ball",
    "Flower",
    "Dog",
    "Elephant",
    "Fish",
    "Monkey",
    "Cow",
    "Rock",
    "Ocean"
  ];
  List<String> Answers = [
    "School",
    "Ball",
    "Flower",
    "Dog",
    "Elephant",
    "Fish",
    "Monkey",
    "Cow",
    "Rock",
    "Ocean"
  ];

  void skipfn() {
    setState(() {
      if (!(current_index + 1 == Answers.length)) {
        feedbackText = "Speak the word ...";
        current_index = current_index + 1;
      } else {
        Navigator.pushNamed(context, '/completion');
      }
    });
  }

  void stopfn() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel(); // Cancel timer on widget disposal
    super.dispose();
  }

  void oncorrecttap() {
    setState(() {
      feedbackText = 'Correct!';
      _feedbackTimer = Timer(const Duration(seconds: 2), () {
        // 2-second delay
        setState(() {
          feedbackText = 'Speak the word ...';
          if (!(current_index + 1 == Answers.length)) {
            current_index = current_index + 1;
          } else {
            Navigator.pushNamed(context, '/completion');
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Read the Word Aloud'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                Answers[current_index],
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            ListeningMicButton(
              correctAnswer: Answers[current_index],
              onResult: (isCorrect) {
                setState(() {
                  isCorrect
                      ? feedbackText = "correct"
                      : feedbackText = "Wrong !";
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                feedbackText,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    onPressed: () {
                      skipfn();
                    },
                    child: const Text('Skip'),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      stopfn();
                    },
                    child: const Text('Stop'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
