import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechFromText extends StatefulWidget {
  final String textToSpeak;
  final IconData icon; // Add an icon property

  const SpeechFromText(
      {super.key, required this.textToSpeak,
      this.icon = Icons.volume_up}); // Default to volume_up icon

  @override
  _SpeechFromTextState createState() => _SpeechFromTextState();
}

class _SpeechFromTextState extends State<SpeechFromText> {
  FlutterTts flutterTts = FlutterTts();
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US"); // Set your preferred language
  }

  void _speakText() async {
    try {
      setState(() => _isSpeaking = true);
      await flutterTts.speak(widget.textToSpeak);
    } catch (e) {
      print('Error speaking text: $e');
      // Handle errors (e.g., show a Snackbar)
    } finally {
      setState(() => _isSpeaking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        size: 100,
        _isSpeaking
            ? Icons.stop
            : widget.icon, // Use the provided icon or default
        color:
            _isSpeaking ? Colors.red : const Color(0xFF3F51B5), // Conditional color
      ),
      onPressed: _speakText,
    );
  }
}
