import 'dart:async';

import 'package:aphasia_bot/utilis/tappableimage.dart';
import 'package:aphasia_bot/utilis/tappabletext.dart';
import 'package:aphasia_bot/utilis/ttsbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListeningAlphabet extends StatefulWidget {
  const ListeningAlphabet({super.key});

  @override
  _ListeningAlphabetState createState() => _ListeningAlphabetState();
}

class _ListeningAlphabetState extends State<ListeningAlphabet> {
  FlutterTts flutterTts = FlutterTts();
  String poptext = "Select an Alphabet ...";
  List<String> prompt_text = ["B", "C", "F", "G", "J", "K", "N", "O", "R", "S"];
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
  List<String> LeftImages = ["B", "D", "F", "H", "J", "L", "N", "P", "R", "T"];
  List<String> RightImages = ["A", "C", "E", "G", "I", "K", "M", "O", "Q", "S"];

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
        poptext = "Select an Alphabet ...";
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
          poptext = 'Select an Aplhabet';
          if (!(currentPairIndex + 1 == leftvalidations.length)) {
            poptext = "Select an Aplhabet ...";
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
          'Listen and Choose the Alphabet',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFBDFCC9),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SpeechFromText(textToSpeak: prompt_text[currentPairIndex]),
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
