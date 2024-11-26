import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ListeningMicButton extends StatefulWidget {
  final String correctAnswer; // Predeclared text to compare with
  final Function(bool)
      onResult; // Callback to notify parent of result (correct/incorrect)

  const ListeningMicButton(
      {super.key, required this.correctAnswer, required this.onResult});

  @override
  _ListeningMicButtonState createState() => _ListeningMicButtonState();
}

class _ListeningMicButtonState extends State<ListeningMicButton> {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _recognizedWords = '';
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  // Initialize speech-to-text
  void _initSpeech() async {
    try {
      bool available = await _speechToText.initialize();
      if (!available) {
        print('Speech recognition not available');
        setState(() {
          _isInitialized = false;
        });
      } else {
        setState(() {
          _isInitialized = true;
        });
        print('Speech recognition initialized');
      }
    } catch (e) {
      print("Error initializing speech recognition: $e");
    }
  }

  // Start listening for speech
  void _startListening() async {
    if (_isInitialized) {
      await _speechToText.listen(
        onResult: (result) => setState(() {
          _recognizedWords = result.recognizedWords;
        }),
      );
      setState(() => _isListening = true);
    } else {
      print('Speech recognition not initialized');
    }
  }

  // Stop listening for speech
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
      _checkResult();
    });
  }

  // Check if the result matches the correct answer
  void _checkResult() {
    print(_recognizedWords);
    bool isCorrect =
        _recognizedWords.toLowerCase() == widget.correctAnswer.toLowerCase();
    widget.onResult(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 80,
      icon: Icon(
        _isListening ? Icons.stop : Icons.mic,
        color: _isListening ? Colors.red : const Color(0xFF3F51B5),
      ),
      onPressed: _isListening
          ? _stopListening
          : () {
              // Ensure _initSpeech is called before starting listening
              if (!_isInitialized) {
                _initSpeech(); // Re-initialize if needed
              }
              _startListening();
            },
    );
  }
}
