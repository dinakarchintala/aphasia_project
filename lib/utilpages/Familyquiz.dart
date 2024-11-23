import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Familyquiz extends StatefulWidget {
  const Familyquiz({super.key});

  @override
  _FamilyquizState createState() => _FamilyquizState();
}

class _FamilyquizState extends State<Familyquiz> {
  Timer? _feedbackTimer;
  int current_index = 0;
  String feedbackText = 'Speak the word';
  List<String> Images = [
    'assets/images/sachin.png',
    'assets/images/SPB.png',
    'assets/images/Mamutty.png',
    'assets/images/Father.png',
    'assets/images/Mother.png',
    'assets/images/Son.png',
    'assets/images/Daughter.png',
  ];
  List<String> Answers = [
    "Sachin",
    "Spb",
    "Mamutty",
    "Father",
    "Mother",
    "Son",
    "Daughter",
  ];

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
        title: const Text('Read the Picture'),
        backgroundColor: const Color(0xFFBDFCC9),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(Images[current_index], height: 250),
            ),
            ListeningMicButton(
              correctAnswer: Answers[current_index],
              onResult: (isCorrect) {
                setState(() {
                  isCorrect ? oncorrecttap() : feedbackText = "Wrong!";
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

class ListeningMicButton extends StatefulWidget {
  final String correctAnswer;
  final void Function(bool isCorrect) onResult;

  const ListeningMicButton({
    Key? key,
    required this.correctAnswer,
    required this.onResult,
  }) : super(key: key);

  @override
  _ListeningMicButtonState createState() => _ListeningMicButtonState();
}

class _ListeningMicButtonState extends State<ListeningMicButton> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _spokenText = "Tap the mic and speak";

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
  }

  void _initSpeechToText() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) => print("Status: $status"),
      onError: (error) => print("Error: ${error.errorMsg}"),
    );

    if (!available) {
      setState(() {
        _spokenText = "Speech recognition unavailable";
      });
    } else {
      print("Speech-to-text initialized successfully");
    }
  }

  void _startListening() async {
    if (!_isListening) {
      setState(() {
        _isListening = true;
        _spokenText = "Listening...";
      });

      print("Starting to listen...");
      await _speechToText.listen(
        onResult: (result) {
          print("Speech result: ${result.recognizedWords}");
          setState(() {
            _spokenText = result.recognizedWords;
          });

          if (!_speechToText.isListening) {
            _processResult(result.recognizedWords);
          }
        },
        localeId: 'en_US', // Specify the language code
      );
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _processResult(String result) {
    String spokenWord = result.trim().toLowerCase();
    String correctWord = widget.correctAnswer.trim().toLowerCase();

    print("Spoken text: $spokenWord");
    print("Correct word: $correctWord");

    if (spokenWord == correctWord) {
      widget.onResult(true);
    } else {
      widget.onResult(false);
    }

    _stopListening();
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            size: 50,
            color: _isListening ? Colors.red : Colors.blue,
          ),
          onPressed: () {
            if (_isListening) {
              _stopListening();
            } else {
              _startListening();
            }
          },
        ),
        const SizedBox(height: 10),
        Text(
          _spokenText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
