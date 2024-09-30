import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart'; // Add confetti package

class CompletionPage extends StatefulWidget {
  const CompletionPage({super.key});

  @override
  _CompletionPageState createState() => _CompletionPageState();
}

class _CompletionPageState extends State<CompletionPage> {
  late ConfettiController _controllerCenter; // Confetti controller
  late int totalScore; // To store the total score

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenter.play();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the score passed from the previous page
    totalScore = ModalRoute.of(context)!.settings.arguments as int;
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // Light Gray background
      body: Stack(
        children: [
          // Confetti animation
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.1,
              numberOfParticles: 20,
              gravity: 0.1,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 120,
                  color: Color(0xFFBDFCC9), // Seafoam Green
                ),
                const SizedBox(height: 20),
                const Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF001F3F), // Dark Navy
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You have completed all the exercises! Your score is: $totalScore',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFF36454F), // Charcoal Grey
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBDFCC9),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/Home'); // Navigate home
                      },
                      child: const Text('Home'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
