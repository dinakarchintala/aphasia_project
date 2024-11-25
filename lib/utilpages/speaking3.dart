import 'dart:async';

import 'package:aphasia_bot/utilis/voicerec.dart';
import 'package:flutter/material.dart';
// Make sure to import this package

// ... (Your ListeningMicButton widget code from the previous response)

class Speakingalphabet extends StatefulWidget {
  const Speakingalphabet({super.key});

  @override
  _SpeakingalphabetState createState() => _SpeakingalphabetState();
}

class _SpeakingalphabetState extends State<Speakingalphabet> {
  Timer? _feedbackTimer;
  int current_index = 0;
  String feedbackText = 'Speak the Alphabet';

  List<String> Answers = ["B", "C", "F", "G", "J", "K", "N", "O", "R", "S"];

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
        title: const Text('Read the Word Aloud'),
        backgroundColor: const Color(0xFFBDFCC9),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                Answers[current_index],
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
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
