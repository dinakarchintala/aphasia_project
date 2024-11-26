import 'dart:async';

import 'package:aphasia_bot/utilis/ttsbutton.dart';
import 'package:flutter/material.dart';

class Writingword extends StatefulWidget {
  const Writingword({super.key});

  @override
  _WritingwordState createState() => _WritingwordState();
}

class _WritingwordState extends State<Writingword> {
  final TextEditingController _textController = TextEditingController();
  String feedbackText = "Name the Word...";
  int current_index = 0;

  List<String> Answers = [
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

  Timer? _feedbackTimer; // Timer for feedback and delay

  @override
  void dispose() {
    _feedbackTimer?.cancel(); // Cancel timer on widget disposal
    super.dispose();
  }

  void skipfn() {
    setState(() {
      feedbackText = "Name the Word ..";
      if (!(current_index + 1 == Answers.length)) {
        current_index = current_index + 1;
      } else {
        Navigator.pushNamed(context, '/completion');
      }
    });
  }

  void stopfn() {
    Navigator.pop(context);
  }

  void _checkAnswer() {
    setState(() {
      if (_textController.text.toLowerCase() ==
          Answers[current_index].toLowerCase()) {
        feedbackText = "Correct!";
        _feedbackTimer = Timer(const Duration(seconds: 2), () {
          setState(() {
            feedbackText = "Name the Word ..";
            if (!(current_index + 1 == Answers.length)) {
              current_index = current_index + 1;
            } else {
              Navigator.pushNamed(context, '/completion');
            }
          });
        });
      } else {
        feedbackText = "Try again!";
      }
    });

    _textController.clear(); // Clear the input field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text(
          'Write the word spoken aloud',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SpeechFromText(textToSpeak: Answers[current_index]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter the answer',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _checkAnswer,
                ),
              ),
            ),
          ),
          Text(
            feedbackText,
            style: TextStyle(
                color: feedbackText == "Correct!" ? Colors.green : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    skipfn();
                  },
                  child: const Text(
                    'Skip',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    stopfn();
                  },
                  child: const Text(
                    'Stop',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
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
