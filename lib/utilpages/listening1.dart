import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ListeningPicture extends StatefulWidget {
  const ListeningPicture({super.key});

  @override
  _ListeningPictureState createState() => _ListeningPictureState();
}

class _ListeningPictureState extends State<ListeningPicture> {
  final FlutterTts _flutterTts = FlutterTts();
  String poptext = "Select an Image ...";
  List<String> promptText = [
    "apple",
    "cat",
    "bulb",
    "cat",
    "chimpanzee",
    "charger",
  ];
  List<bool> leftValidations = [
    true,
    true,
    true,
    false,
    false,
    false,
  ];
  List<bool> rightValidations = [
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

  int currentPairIndex = 0; // Track the current question index
  int totalCorrectAnswers = 0; // Track the total correct answers
  Timer? _feedbackTimer; // Timer for feedback and delay

  @override
  void initState() {
    super.initState();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5); // Adjust speech rate
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    // Handle errors with TTS
    _flutterTts.setErrorHandler((msg) {
      debugPrint("TTS Error: $msg");
      setState(() {
        poptext = "Error with Text-to-Speech!";
      });
    });
  }

  @override
  void dispose() {
    _feedbackTimer?.cancel(); // Cancel timer on widget disposal
    _flutterTts.stop(); // Stop TTS if it's still speaking
    super.dispose();
  }

  void _skipQuestion() {
    _feedbackTimer?.cancel();
    setState(() {
      if (currentPairIndex < leftValidations.length - 1) {
        poptext = "Select an Image ...";
        currentPairIndex++;
      } else {
        _navigateToCompletion();
      }
    });
  }

  void _stopExercise() {
    _feedbackTimer?.cancel();
    Navigator.pop(context);
  }

  void _onCorrectTap() {
    _feedbackTimer?.cancel(); // Cancel any existing timer
    setState(() {
      poptext = 'Correct!';
      totalCorrectAnswers++;
      _feedbackTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            if (currentPairIndex < leftValidations.length - 1) {
              poptext = "Select an Image ...";
              currentPairIndex++;
            } else {
              _navigateToCompletion();
            }
          });
        }
      });
    });
  }

  void _onWrongTap() {
    _feedbackTimer?.cancel(); // Cancel any existing timer
    setState(() {
      poptext = 'Wrong!';
      totalCorrectAnswers =
          (totalCorrectAnswers > 0) ? totalCorrectAnswers - 1 : 0;
    });
  }

  void _navigateToCompletion() {
    Navigator.pushNamed(context, '/completion', arguments: totalCorrectAnswers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text(
          'Listen and Choose the Picture',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFBDFCC9),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text-to-Speech and Prompt Text Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await _flutterTts.speak(promptText[currentPairIndex]);
                        } catch (e) {
                          debugPrint("TTS Error: $e");
                        }
                      },
                      child: const Icon(Icons.volume_up),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      poptext,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              // Images Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Left Image
                    GestureDetector(
                      onTap: () {
                        if (leftValidations[currentPairIndex]) {
                          _onCorrectTap();
                        } else {
                          _onWrongTap();
                        }
                      },
                      child: Image.asset(
                        leftImages[currentPairIndex],
                        width: 250, // Increased size
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Right Image
                    GestureDetector(
                      onTap: () {
                        if (rightValidations[currentPairIndex]) {
                          _onCorrectTap();
                        } else {
                          _onWrongTap();
                        }
                      },
                      child: Image.asset(
                        rightImages[currentPairIndex],
                        width: 250, // Increased size
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              // Buttons Section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _skipQuestion,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 50),
                    ElevatedButton(
                      onPressed: _stopExercise,
                      child: const Text(
                        'Stop Exercise',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
