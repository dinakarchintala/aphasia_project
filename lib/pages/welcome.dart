// ignore_for_file: prefer_const_constructors
import 'package:aphasia_bot/pages/homedesign.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aphasia_bot/services/translation_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Color(0xFFE3F2FD),
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
      body: Stack(children: [
        // Background Image
        Positioned(
          top:
              MediaQuery.of(context).size.height / 2 - 150, // Center vertically
          right: 20, // 20px from the right edge
          child: Container(
            height: 300, // Circular height
            width: 300, // Circular width
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Makes the image circular
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black26,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/homepage/medi2.jpeg',
                fit: BoxFit
                    .cover, // Ensures the image covers the entire circular area
              ),
            ),
          ),
        ),
        Positioned(
          top: 80,
          left: 220,
          child: FadeTransition(
            opacity: _animation,
            child: FutureBuilder<String>(
              future: translationService.translate('Aphasia Therapy'),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? 'Aphasia Therapy',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      fontSize: 45,
                      color: Color(0xFF263238),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 280,
          left: 220,
          child: FadeTransition(
            opacity: _animation,
            child: FutureBuilder<String>(
              future: translationService
                  .translate("Welcome back! Let's keep the momentum going."),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ??
                      "Welcome back! Let's keep the momentum going.",
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 61, 79, 88),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 350, // Position below "Welcome back!" text
          left: MediaQuery.of(context).size.width / 2 -
              190, // Center horizontally
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Homedesign()),
              );
            },
            backgroundColor: Color(0xFFFFEB3B), // Therapy-related button color
            label: Text(
              "Start Your Session",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF263238), // Text color
              ),
            ),
          ),
        ),
      ]),
      // Position
    );
  }
}
