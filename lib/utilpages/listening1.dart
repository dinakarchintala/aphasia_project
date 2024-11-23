// ignore_for_file: prefer_const_constructors, sort_child_properties_last, library_private_types_in_public_api, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_final_fields

import 'dart:async';

import 'package:aphasia_bot/utilis/tappableimage.dart';
import 'package:aphasia_bot/utilis/ttsbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Listeningpicture extends StatefulWidget {
  const Listeningpicture({super.key});

  @override
  _ListeningpictureState createState() => _ListeningpictureState();
}

class _ListeningpictureState extends State<Listeningpicture> {
  FlutterTts flutterTts = FlutterTts();
  String poptext = "Select an Image ...";
  List<String> prompt_text = [
    "apple",
    "beach",
    "belt",
    "books",
    "bottle",
    "butterfly",
    "car",
    "chair",
    "cheetah",
    "chimpanzee"
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
  List<String> LeftImages = [
    'assets/images/apple.jpg',
    'assets/images/beach.jpg',
    'assets/images/belt.jpg',
    'assets/images/bike.jpg',
    'assets/images/bulb.jpg',
    'assets/images/bus.jpg',
    'assets/images/car.jpg',
    'assets/images/chair.jpg',
    'assets/images/charger.jpg',
    'assets/images/chimpanzee.jpg',
  ];
  List<String> RightImages = [
    'assets/images/bag.jpg',
    'assets/images/banana.jpg',
    'assets/images/bed.jpg',
    'assets/images/books.jpg',
    'assets/images/bottle.jpg',
    'assets/images/butterfly.jpg',
    'assets/images/calendar.jpg',
    'assets/images/cat.jpg',
    'assets/images/cheetah.jpg',
    'assets/images/colorpencils.jpg',
  ];

  int currentPairIndex = 0; // Track the current question index
  int totalanswer = 0; // Track the total correct answers
  Timer? _feedbackTimer; // Timer for feedback and delay

  @override
  void dispose() {
    _feedbackTimer?.cancel(); // Cancel timer on widget disposal
    flutterTts.stop(); // Stop TTS if it's still speaking
    super.dispose();
  }

  void skipfn() {
    _feedbackTimer?.cancel();
    setState(() {
      if (currentPairIndex < leftvalidations.length - 1) {
        poptext = "Select an Image ...";
        currentPairIndex++;
      } else {
        navigateToCompletion();
      }
    });
  }

  void stopfn() {
    Navigator.pop(context);
  }

  void oncorrecttap() {
    _feedbackTimer?.cancel(); // Cancel any existing timer
    setState(() {
      poptext = 'Correct!';
      totalanswer++;
      _feedbackTimer = Timer(Duration(seconds: 2), () {
        setState(() {
          if (currentPairIndex < leftvalidations.length - 1) {
            poptext = "Select an Image ...";
            currentPairIndex++;
          } else {
            navigateToCompletion();
          }
        });
      });
    });
  }

  void navigateToCompletion() {
    Navigator.pushNamed(context, '/completion', arguments: totalanswer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(
          'Listen and Choose the Picture',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFBDFCC9),
      ),
      body: Column(
        children: [
          // Text-to-Speech and Prompt Text Section
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpeechFromText(textToSpeak: prompt_text[currentPairIndex]),
                SizedBox(height: 10),
                Text(
                  poptext,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Images Section
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Left Image
                TappableImageContainer(
                  imagePath: LeftImages[currentPairIndex],
                  isCorrect: leftvalidations[currentPairIndex],
                  onCorrectTap: oncorrecttap,
                  oninCorrectTap: () {
                    setState(() => poptext = 'Wrong!');
                    totalanswer--;
                  },
                ),
                // Right Image
                TappableImageContainer(
                  imagePath: RightImages[currentPairIndex],
                  isCorrect: rightvalidations[currentPairIndex],
                  onCorrectTap: oncorrecttap,
                  oninCorrectTap: () {
                    setState(() => poptext = 'Wrong!');
                    totalanswer--;
                  },
                ),
              ],
            ),
          ),

          // Buttons Section
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: skipfn, // Skip button logic
                  child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Skip button color
                  ),
                ),
                SizedBox(width: 50),
                ElevatedButton(
                  onPressed: stopfn, // Stop button logic
                  child: Text(
                    'Stop Exercise',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Stop button color
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
