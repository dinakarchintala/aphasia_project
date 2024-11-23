import 'package:flutter/material.dart';
import 'dart:async'; // Required for the timer functionality
import 'package:audioplayers/audioplayers.dart'; // Import audioplayers package

class Meditation extends StatefulWidget {
  const Meditation({Key? key}) : super(key: key);

  @override
  _MeditationState createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  final List<String> timerOptions = [
    '00:01:00',
    '00:05:00',
    '00:10:00'
  ]; // List of timer options
  String? selectedTime; // To store the selected timer
  int? remainingSeconds; // Remaining seconds for the countdown
  Timer? countdownTimer; // Timer instance for the countdown
  bool isTimerRunning = false; // To track the timer state
  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance for bell sound

  @override
  void dispose() {
    countdownTimer?.cancel(); // Cancel timer if active
    _audioPlayer.dispose(); // Dispose AudioPlayer
    super.dispose();
  }

  void startTimer() {
    if (remainingSeconds == null || remainingSeconds! <= 0) return;

    // Play the bell sound 2 seconds after the timer starts
    Future.delayed(const Duration(seconds: 2), () {
      if (isTimerRunning) {
        playBellSound();
      }
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds! > 0) {
        setState(() {
          remainingSeconds = remainingSeconds! - 1;
        });
      } else {
        timer.cancel();
        playCompletionSound(); // Play bell sound when the timer runs out
        setState(() {
          isTimerRunning = false;
        });
      }
    });

    setState(() {
      isTimerRunning = true;
    });
  }

  void stopTimer() {
    countdownTimer?.cancel();
    setState(() {
      isTimerRunning = false;
    });
    playCompletionSound(); // Play bell sound when the timer is stopped
  }

  Future<void> playBellSound() async {
    await _audioPlayer.play(AssetSource('meditationpage/bell-a-99888.mp3'));
  }

  Future<void> playCompletionSound() async {
    for (int i = 0; i < 3; i++) {
      await playBellSound(); // Play the bell sound
      await Future.delayed(const Duration(seconds: 1)); // Delay for 1 second between bell sounds
    }
  }

  int parseTimeToSeconds(String time) {
    final parts = time.split(':').map(int.parse).toList();
    return (parts[0] * 3600) + (parts[1] * 60) + parts[2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Meditation'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Welcome to Meditation Page!',
                style: TextStyle(fontSize: 24, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 200,
            left: MediaQuery.of(context).size.width / 2 - 350,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/meditationpage/yoga.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 220,
            right: 80,
            child: const Text(
              'Choose your timer',
              style: TextStyle(fontSize: 24, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 150,
            right: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...timerOptions.map((time) => GestureDetector(
                      onTap: () {
                        if (!isTimerRunning) {
                          setState(() {
                            selectedTime = time;
                            remainingSeconds = parseTimeToSeconds(time);
                          });
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedTime == time
                              ? Colors.blue.shade100
                              : Colors.white,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          time,
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    )),
                const SizedBox(height: 20),
                if (selectedTime != null)
                  Column(
                    children: [
                      Text(
                        'Selected: $selectedTime',
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const SizedBox(height: 10),
                      if (!isTimerRunning)
                        ElevatedButton(
                          onPressed: startTimer,
                          child: const Text('Start Timer'),
                        ),
                      if (isTimerRunning)
                        ElevatedButton(
                          onPressed: stopTimer,
                          child: const Text('Stop Timer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                if (isTimerRunning && remainingSeconds != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      'Remaining: ${Duration(seconds: remainingSeconds!).toString().split('.').first}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
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
