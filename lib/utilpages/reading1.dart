import 'dart:async';

import 'package:aphasia_bot/utilis/tappableimage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ReadAndChoosePage extends StatefulWidget {
  const ReadAndChoosePage({super.key});

  @override
  _ReadAndChoosePageState createState() => _ReadAndChoosePageState();
}

class _ReadAndChoosePageState extends State<ReadAndChoosePage> {
  FlutterTts flutterTts = FlutterTts();
  String poptext = "Select an Image ...";
  List<String> prompt_text = [
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
          'Read and Choose the Picture',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFBDFCC9),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            prompt_text[currentPairIndex],
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TappableImageContainer(
                imagePath: LeftImages[currentPairIndex],
                isCorrect: leftvalidations[currentPairIndex],
                onCorrectTap: oncorrecttap,
                oninCorrectTap: () {
                  setState(() => poptext = 'Wrong!');
                },
              ),
              TappableImageContainer(
                imagePath: RightImages[currentPairIndex],
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
