import 'dart:async';

import 'package:flutter/material.dart';

class TappableImageContainer extends StatefulWidget {
  final String imagePath; // Path to your image asset
  final bool isCorrect; // Flag to determine correct/incorrect state
  final VoidCallback onCorrectTap;
  final VoidCallback oninCorrectTap;

  const TappableImageContainer(
      {super.key,
      required this.imagePath,
      this.isCorrect = false,
      required this.onCorrectTap,
      required this.oninCorrectTap});

  @override
  _TappableImageContainerState createState() => _TappableImageContainerState();
}

class _TappableImageContainerState extends State<TappableImageContainer> {
  bool _isTapped = false;
  Timer? _colorTimer; // Add a timer to control color change

  @override
  void dispose() {
    _colorTimer?.cancel(); // Cancel timer on widget disposal
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped; // Toggle tapped state

          if (_isTapped) {
            _colorTimer = Timer(const Duration(seconds: 1), () {
              // 1-second duration
              setState(() {
                _isTapped = false; // Revert to untapped state
              });
            });
          } else {
            _colorTimer?.cancel(); // Cancel timer if tap before duration ends
          }
          if (widget.isCorrect) {
            widget.onCorrectTap(); // Call the callback when correct
          }
          if (!widget.isCorrect) {
            widget.oninCorrectTap();
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(_isTapped ? 10.0 : 10.0),
        decoration: BoxDecoration(
          color: _isTapped
              ? (widget.isCorrect ? Colors.green : Colors.red)
              : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Image.asset(
          widget.imagePath,
          height: 300,
          width: 190,
        ),
      ),
    );
  }
}
