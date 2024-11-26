// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:async';

import 'package:aphasia_bot/utilis/tappabletext.dart';
import 'package:aphasia_bot/utilis/ttsbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Listeningword extends StatefulWidget {
  const Listeningword({super.key});

  @override
  _ListeningwordState createState() => _ListeningwordState();
}

class _ListeningwordState extends State<Listeningword> {
  FlutterTts flutterTts = FlutterTts();
  String poptext = "Select a Word  ...";
  List<String> prompt_text = [
    "Apple",
    "Ball",
    "Cat",
    "Dog",
    "Elephant",
    "Fish",
    "Giraffe",
    "Horse",
    "Rock",
    "Cloud"
  ];
  List<bool> leftvalidations = [
    true,
    true,
    true,
    false,
    false,
    false,
    true,
    true,
    false,
    true
  ];
  List<bool> rightvalidations = [
    false,
    true,
    false,
    true,
    true,
    true,
    false,
    false,
    true,
    false
  ];
  List<String> LeftTexts = [
    "Apple",
    "Car",
    "Cat",
    "House",
    "Sky",
    "Water",
    "Giraffe",
    "Horse",
    "Star",
    "Cloud"
  ];
  List<String> RightTexts = [
    "Pear",
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
        poptext = "Select an Word ...";
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
      _feedbackTimer = Timer(Duration(seconds: 2), () {
        // 2-second delay
        setState(() {
          poptext = 'Select a Word ...';
          if (!(currentPairIndex + 1 == leftvalidations.length)) {
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
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(
          'Listen and Choose the Word',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SpeechFromText(textToSpeak: prompt_text[currentPairIndex]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TappableTextContainer(
                textcontent: LeftTexts[currentPairIndex],
                isCorrect: leftvalidations[currentPairIndex],
                onCorrectTap: oncorrecttap,
                oninCorrectTap: () {
                  setState(() => poptext = 'Wrong!');
                },
              ),
              TappableTextContainer(
                textcontent: RightTexts[currentPairIndex],
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
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: skipfn, // Add skip logic here
                child: Text(
                  'Skip',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Example skip button color
                ),
              ),
              SizedBox(
                width: 100,
              ),
              ElevatedButton(
                onPressed: stopfn, // Add stop logic here
                child: Text(
                  'Stop Exercise',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Example stop button color
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
