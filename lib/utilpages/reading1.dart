import 'package:flutter_tts/flutter_tts.dart';

import 'dart:async';

import 'package:aphasia_bot/utilis/tappableimage.dart';
import 'package:flutter/material.dart';

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
    "cat",
    "bulb",
    "cat",
    "chimpanzee",
    "charger",
  ];
  List<bool> leftvalidations = [
    true,
    true,
    true,
    false,
    false,
    false,
  ];
  List<bool> rightvalidations = [
    false,
    false,
    false,
    true,
    true,
    true,
  ];
  List<String> leftImages = [
    'assets/images/apple.jpg',
    'assets/images/cat.jpg',
    'assets/images/bulb.jpg',
    'assets/images/butterfly.jpg',
    'assets/images/cheetah.jpeg',
    'assets/images/colorpencils.jpg',
  ];
  List<String> rightImages = [
    'assets/images/bag.jpg',
    'assets/images/banana.jpg',
    'assets/images/bus.jpg',
    'assets/images/cat.jpg',
    'assets/images/chimpanzee.jpeg',
    'assets/images/charger.jpeg',
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text(
          'Read and Choose the Picture',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Prompt text
            Text(
              prompt_text[currentPairIndex],
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            // Image row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  child: TappableImageContainer(
                    imagePath: leftImages[currentPairIndex],
                    isCorrect: leftvalidations[currentPairIndex],
                    onCorrectTap: oncorrecttap,
                    oninCorrectTap: () {
                      setState(() => poptext = 'Wrong!');
                    },
                  ),
                ),
                Flexible(
                  child: TappableImageContainer(
                    imagePath: rightImages[currentPairIndex],
                    isCorrect: rightvalidations[currentPairIndex],
                    onCorrectTap: oncorrecttap,
                    oninCorrectTap: () {
                      setState(() => poptext = 'Wrong!');
                    },
                  ),
                ),
              ],
            ),
            // Feedback text
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                poptext,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            // Buttons for skip and stop
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: skipfn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.08, vertical: 16),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: stopfn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.08, vertical: 16),
                  ),
                  child: const Text(
                    'Stop Exercise',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
