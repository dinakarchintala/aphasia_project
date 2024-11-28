import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class FindInPicture extends StatefulWidget {
  const FindInPicture({super.key});

  @override
  _FindInPictureState createState() => _FindInPictureState();
}

class _FindInPictureState extends State<FindInPicture> {
  final FlutterTts _flutterTts = FlutterTts();

  int _currentQuestionIndex = 0; // Track the current question
  bool _isAnswered = false; // Track if the current question has been answered
  String? _selectedOption; // Track the selected option

  final List<Map<String, dynamic>> _questions = [
    {
      'imageWithQuestionMark': 'assets/therapyimages/cooking.png',
      'imageWithoutQuestionMark': 'assets/therapyimages/Cook.png',
      'options': ['Cooking', 'Banking', 'Shopping'],
      'correctAnswer': 'Cooking',
    },
    {
      'imageWithQuestionMark': 'assets/therapyimages/Bank.png',
      'imageWithoutQuestionMark': 'assets/therapyimages/Banking.png',
      'options': ['Rob', 'Bank', 'Watching'],
      'correctAnswer': 'Bank',
    },
    {
      'imageWithQuestionMark': 'assets/therapyimages/Shoppingq.png',
      'imageWithoutQuestionMark': 'assets/therapyimages/shopping.png',
      'options': ['shopping', 'eating', 'house'],
      'correctAnswer': 'shopping',
    },
    {
      'imageWithQuestionMark': 'assets/therapyimages/groceryshopq.png',
      'imageWithoutQuestionMark': 'assets/therapyimages/groceryshop.png',
      'options': ['restaurant', 'Bank', 'groceryshop'],
      'correctAnswer': 'groceryshop',
    },
    {
      'imageWithQuestionMark': "assets/therapyimages/Brain.png",
      'imageWithoutQuestionMark': '',
      'options': ['Brain', 'Heart', 'Eating'],
      'correctAnswer': 'Brain',
    },
  ];

  // Restart the quiz
  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _isAnswered = false;
      _selectedOption = null;
    });
  }

  // Speak the selected option
  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  // Handle option selection
  void _selectOption(String selectedOption) async {
    if (_isAnswered)
      return; // Prevent multiple selections for the same question

    await _speak(selectedOption);

    final currentQuestion = _questions[_currentQuestionIndex];

    setState(() {
      _isAnswered = true;
      _selectedOption = selectedOption;
    });

    if (selectedOption == currentQuestion['correctAnswer']) {
      // Correct answer: Show images side-by-side, then move to the next question
      Timer(const Duration(seconds: 2), () {
        setState(() {
          if (_currentQuestionIndex < _questions.length) {
            _currentQuestionIndex++;
            _isAnswered = false;
            _selectedOption = null;
          } else {
            // End of the quiz
            _isAnswered = false;
            _selectedOption = null;
          }
        });
      });
    } else {
      // Incorrect answer: Show "Try Again" feedback, then allow retry
      Timer(const Duration(seconds: 2), () {
        setState(() {
          _isAnswered = false; // Allow user to select again
          _selectedOption = null; // Clear the selection
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the quiz is complete
    if (_currentQuestionIndex >= _questions.length) {
      return Scaffold(
        backgroundColor: const Color(0xFFE3F2FD),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎉 Great Job! 🎉',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _restartQuiz,
                child: const Text('Restart'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous page
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    // Current question data
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Find in Picture"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display images
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (currentQuestion['imageWithQuestionMark'] != null)
                  Image.asset(
                    !_isAnswered
                        ? currentQuestion['imageWithQuestionMark']
                        : currentQuestion['imageWithQuestionMark'],
                    height: 200,
                    width: 200,
                  ),
                const SizedBox(width: 10),
                _isAnswered
                    ? (currentQuestion['imageWithoutQuestionMark'] != null &&
                            currentQuestion['imageWithoutQuestionMark'] != '')
                        ? Image.asset(
                            currentQuestion['imageWithoutQuestionMark']!,
                            height: 200,
                            width: 200,
                          )
                        : SizedBox()
                    : SizedBox(),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Feedback text
          if (_isAnswered)
            Text(
              _selectedOption == currentQuestion['correctAnswer']
                  ? 'Correct!'
                  : 'Try Again',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _selectedOption == currentQuestion['correctAnswer']
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          const SizedBox(height: 20),

          // Display options in a horizontal scrollable row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: currentQuestion['options'].map<Widget>((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_isAnswered || _selectedOption != option) {
                        _selectOption(option);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      backgroundColor: _selectedOption == option &&
                              _isAnswered &&
                              option == currentQuestion['correctAnswer']
                          ? Colors.green
                          : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
