// ignore_for_file: prefer_const_constructors

import 'package:aphasia_bot/pages/homedesign.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Animation duration
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(
          189, 252, 201, 1.0), // Therapy-related background color
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50)),
              ),
              Text(
                'to',
                style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50)),
              ),
              Text(
                'Aphasia',
                style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50)),
              ),
              Text(
                'Therapy',
                style: TextStyle(
                    fontSize: 62,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50)),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Homedesign()),
          );
        },
        backgroundColor: Color(0xFF4CAF50), // Therapy-related button color
        child: Icon(Icons.arrow_forward),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Position
    );
  }
}
