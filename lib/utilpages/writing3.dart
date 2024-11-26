// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:aphasia_bot/utilis/ttsbutton.dart';
import 'package:flutter/material.dart';

class Writingalphabet extends StatefulWidget {
  const Writingalphabet({super.key});

  @override
  _WritingalphabetState createState() => _WritingalphabetState();
}

class _WritingalphabetState extends State<Writingalphabet> {
  final TextEditingController _textController = TextEditingController();
  String feedbackText = "write the letter down...";
  int current_index = 0;

  List<String> Answers = ["B", "C", "F", "G", "J", "K", "N", "O", "R", "S"];

  Timer? _feedbackTimer; // Timer for feedback and delay

  @override
  void dispose() {
    _feedbackTimer?.cancel(); // Cancel timer on widget disposal
    super.dispose();
  }

  void skipfn() {
    setState(() {
      feedbackText = "Write the Alphabet ...";
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
        _feedbackTimer = Timer(Duration(seconds: 2), () {
          setState(() {
            feedbackText = "Write the Alphabet ...";
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
        title: Text(
          'Write the spoken letter',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.all(20.0),
              child: SpeechFromText(textToSpeak: Answers[current_index])),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Enter the answer',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                  icon: Icon(Icons.check),
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
                  child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    stopfn();
                  },
                  child: Text(
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
