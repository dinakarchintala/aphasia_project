import 'dart:async';

import 'package:aphasia_bot/utilis/tappableimage.dart';
import 'package:aphasia_bot/utilis/tappabletext.dart';
import 'package:aphasia_bot/utilis/ttsbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ReadAndMatch extends StatefulWidget {
  const ReadAndMatch({super.key});

  @override
  _ReadAndMatchState createState() => _ReadAndMatchState();
}

class _ReadAndMatchState extends State<ReadAndMatch> {
  FlutterTts flutterTts = FlutterTts();
  String poptext = "Match the lower case with upper case...";

  List<String> centerImages = [
    "b",
    "c",
    "f",
    "g",
    "j",
    "k",
    "n",
    "o",
    "r",
    "s"
  ];
  List<String> LeftImages = ["B", "D", "F", "H", "J", "L", "N", "P", "R", "T"];
  List<String> RightImages = ["A", "C", "E", "G", "I", "K", "M", "O", "Q", "S"];
  List<bool> leftvalidations = [
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false
  ];
  List<bool> rightvalidations = [
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    true,
    false,
    true
  ];

  int currentPairIndex = 0;
  Timer? _feedbackTimer; // Timer for feedback and delay

  @override
  void dispose() {
    _feedbackTimer?.cancel(); // Cancel timer on widget disposal
    super.dispose();
  }

  void skipfn() {
    setState(() {
      if (!(currentPairIndex + 1 == leftvalidations.length)) {
        poptext = "Select an Image ...";
        currentPairIndex = currentPairIndex + 1;
      } else {
        Navigator.pushNamed(context, '/completion');
      }
    });
  }

  void stopfn() {
    Navigator.pop(context);
  }

  void oncorrecttap() {
    setState(() {
      poptext = 'Correct!';
      _feedbackTimer = Timer(const Duration(seconds: 2), () {
        // 2-second delay
        setState(() {
          poptext = 'Select an image';
          if (!(currentPairIndex + 1 == leftvalidations.length)) {
            poptext = "Select an Image ...";
            currentPairIndex = currentPairIndex + 1;
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
        title: const Text(
          'Read and Match the upper case Letter',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFBDFCC9),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            centerImages[currentPairIndex],
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TappableTextContainer(
                textcontent: LeftImages[currentPairIndex],
                isCorrect: leftvalidations[currentPairIndex],
                onCorrectTap: oncorrecttap,
                oninCorrectTap: () {
                  setState(() => poptext = 'Wrong!');
                },
              ),
              TappableTextContainer(
                textcontent: RightImages[currentPairIndex],
                isCorrect: rightvalidations[currentPairIndex],
                onCorrectTap: oncorrecttap,
                oninCorrectTap: () {
                  setState(() => poptext = 'Wrong!');
                },
              ),
            ],
          ),
          Container(
            child: Text(
              poptext,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: skipfn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Example skip button color
                ), // Add skip logic here
                child: Text(
                  'Skip',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 100,
              ),
              ElevatedButton(
                onPressed: stopfn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Example stop button color
                ), // Add stop logic here
                child: Text(
                  'Stop Exercise',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
