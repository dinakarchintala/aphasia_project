// ignore_for_file: prefer_const_constructors
import 'package:aphasia_bot/pages/homedesign.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aphasia_bot/services/translation_service.dart';

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
    var translationService = Provider.of<TranslationService>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(
          189, 252, 201, 1.0), // Therapy-related background color
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.translate),
            onSelected: (String languageCode) {
              setState(() {
                translationService.changeLanguage(languageCode);
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'ta', child: Text('Tamil')),
              PopupMenuItem(value: 'hi', child: Text('Hindi')),
               PopupMenuItem(value: 'te', child: Text('Telugu')),
               PopupMenuItem(value: 'ml', child: Text('Malayalam')),
            ],
          ),
        ],
      ),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<String>(
                future: translationService.translate('Welcome'),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? 'Welcome',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  );
                },
              ),
              FutureBuilder<String>(
                future: translationService.translate('to'),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? 'to',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  );
                },
              ),
              FutureBuilder<String>(
                future: translationService.translate('Aphasia'),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? 'Aphasia',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  );
                },
              ),
              FutureBuilder<String>(
                future: translationService.translate('Therapy'),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.data ?? 'Therapy',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  );
                },
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
