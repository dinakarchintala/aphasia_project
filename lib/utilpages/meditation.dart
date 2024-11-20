import 'package:flutter/material.dart';
import 'dart:async'; // Required for the timer functionality

class Meditation extends StatefulWidget {
  const Meditation({Key? key}) : super(key: key);

  @override
  _MeditationState createState() => _MeditationState();
}

class _MeditationState extends State<Meditation> {
  final List<String> timerOptions = [
    '00:02:00',
    '00:05:00',
    '00:10:00'
  ]; // List of timer options
  String? selectedTime; // To store the selected timer
  int? remainingSeconds; // Remaining seconds for the countdown
  Timer? countdownTimer; // Timer instance for the countdown
  bool isTimerRunning = false; // To track the timer state

  @override
  void dispose() {
    countdownTimer?.cancel(); // Cancel timer if active
    super.dispose();
  }

  void startTimer() {
    if (remainingSeconds == null || remainingSeconds! <= 0) return;

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds! > 0) {
        setState(() {
          remainingSeconds = remainingSeconds! - 1;
        });
      } else {
        timer.cancel();
        playCompletionSound();
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
  }

  void playCompletionSound() {
    // Integrate a package like `audioplayers` for sound
    // Example:
    // AudioPlayer player = AudioPlayer();
    // await player.play('assets/completion_sound.mp3');
    print('Timer completed! Play sound.');
  }

  int parseTimeToSeconds(String time) {
    final parts = time.split(':').map(int.parse).toList();
    return (parts[0] * 3600) + (parts[1] * 60) + parts[2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text('Meditation'),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment
                .topCenter, // You can change this to any other alignment
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
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
                'assets/meditationpage/medi1.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 220,
            right: 80,
            child: Text(
              'Choose your timer',
              style: TextStyle(fontSize: 24, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 150,
            right: 140, // Positioning the timer options on the right
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
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedTime == time
                              ? Colors.blue.shade100
                              : Colors.white,
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    )),
                SizedBox(height: 20),
                if (selectedTime != null)
                  Column(
                    children: [
                      Text(
                        'Selected: $selectedTime',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      if (!isTimerRunning)
                        ElevatedButton(
                          onPressed: startTimer,
                          child: Text('Start Timer'),
                        ),
                      if (isTimerRunning)
                        ElevatedButton(
                          onPressed: stopTimer,
                          child: Text('Stop Timer'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                    ],
                  ),
                if (isTimerRunning && remainingSeconds != null)
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Remaining: ${Duration(seconds: remainingSeconds!).toString().split('.').first}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
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
