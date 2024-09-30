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
    "chimpangee"
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
    'assets/images/chimpangee.jpg',
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
       Navigator.pushNamed(context, '/completion', arguments: totalanswer);
      }
    });
  }

  void stopfn() {
    Navigator.pop(context);
  }
int totalanswer=0;
  void oncorrecttap() {
    setState(() {
      poptext = 'Correct!';
      totalanswer++;
      _feedbackTimer = Timer(Duration(seconds: 2), () {
        // 2-second delay
        setState(() {
          poptext = 'Select an Image';
          if (!(currentPairIndex + 1 == leftvalidations.length)) {
            poptext = "Select an Image ...";
            currentPairIndex = currentPairIndex + 1;
          } else {
           Navigator.pushNamed(context, '/completion', arguments: totalanswer);

          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(
          'Listen and Choose the Picture',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFBDFCC9),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SpeechFromText(textToSpeak: prompt_text[currentPairIndex]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TappableImageContainer(
                imagePath: LeftImages[currentPairIndex],
                isCorrect: leftvalidations[currentPairIndex],
                onCorrectTap: oncorrecttap,
                oninCorrectTap: () {
                  setState(() => poptext = 'Wrong!');
                  totalanswer--;
                },
              ),
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
