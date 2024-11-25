import 'dart:async';

import 'package:aphasia_bot/utilis/voicerec.dart';
import 'package:flutter/material.dart';
// Make sure to import this package

// ... (Your ListeningMicButton widget code from the previous response)

class Speakingpicture extends StatefulWidget {
  const Speakingpicture({super.key});

  @override
  _SpeakingpictureState createState() => _SpeakingpictureState();
}

class _SpeakingpictureState extends State<Speakingpicture> {
  Timer? _feedbackTimer;
  int current_index = 0;
  String feedbackText = 'Speak the word';
  List<String> Images = [
    'assets/images/apple.jpg',
    'assets/images/beach.jpg',
    'assets/images/belt.jpg',
    'assets/images/bike.jpg',
    'assets/images/bulb.jpg',
    'assets/images/bus.jpg',
    'assets/images/car.jpg',
    'assets/images/chair.jpg',
    'assets/images/charger.jpg',
    'assets/images/chimpangee.jpg',
  ];
  List<String> Answers = [
    "apple",
    "beach",
    "belt",
    "bike",
    "bulb",
    "bus",
    "car",
    "chair",
    "charger",
    "chimpangee"
  ];

  void skipfn() {
    setState(() {
      if (!(current_index + 1 == Answers.length)) {
        feedbackText = "Select an Image ...";
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
          feedbackText = 'Select an image';
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
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Read the Picture'),
        backgroundColor: const Color(0xFFBDFCC9),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(Images[current_index], height: 250),
            ),
            ListeningMicButton(
              correctAnswer: Answers[current_index],
              onResult: (isCorrect) {
                setState(() {
                  isCorrect ? oncorrecttap() : feedbackText = "Wrong !";
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                feedbackText,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
