import 'dart:async';

import 'package:aphasia_bot/utilis/voicerec.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart'; // Make sure to import this package

// ... (Your ListeningMicButton widget code from the previous response)

class Familyquiz extends StatefulWidget {
  const Familyquiz({super.key});

  @override
  _FamilyquizState createState() => _FamilyquizState();
}

class _FamilyquizState extends State<Familyquiz> {
  Timer? _feedbackTimer;
  int current_index = 0;
  String feedbackText = 'Speak the word';
  List<String> Images = [
    'assets/images/Sachin.png',
    'assets/images/SPB.png',
    'assets/images/Mamutty.png',
    'assets/images/Father.png',
    'assets/images/Mother.png',
    'assets/images/Son.png',
    'assets/images/Daughter.png',
  ];
  List<String> Answers = [
    "Sachin",
    "Spb",
    "Mamutty",
    "Father",
    "Mother",
    "son",
    "Daughter",
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
