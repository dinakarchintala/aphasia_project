import 'package:aphasia_bot/pages/helppage.dart';
import 'package:aphasia_bot/pages/home.dart';
import 'package:aphasia_bot/pages/funspace.dart';
import 'package:aphasia_bot/pages/callschedule.dart';
import 'package:aphasia_bot/utilpages/Familyquiz.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
import 'package:aphasia_bot/utilpages/meditation.dart';
import 'package:flutter/material.dart';
import 'package:aphasia_bot/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Homedesign extends StatelessWidget {
  const Homedesign({super.key});

  @override
  Widget build(BuildContext context) {
    var translationService = Provider.of<TranslationService>(context);
    final FlutterTts flutterTts = FlutterTts();

    Future<void> _announceAndNavigate() async {
      // Voice announcement
      await flutterTts.setLanguage("en-US");
      await flutterTts.speak("nami needs help.");

      // Delay before navigating
      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Helppage()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.translate),
            onSelected: (String languageCode) {
              translationService.changeLanguage(languageCode);
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
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header for the Home Page
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Home Page",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ),
                  // Grid of options with 2 above and 2 below
                  GridView.builder(
                    shrinkWrap:
                        true, // Makes the grid view not take up all space
                    physics:
                        NeverScrollableScrollPhysics(), // Disables scrolling within the grid
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600
                          ? 3 // Four items in a row for larger screens
                          : 2, // Two items in a row for smaller screens
                      childAspectRatio: MediaQuery.of(context).size.width > 600
                          ? 1.6 // Adjust aspect ratio for larger screens
                          : 0.9, // Default for smaller screens
                      crossAxisSpacing: 10, // Horizontal spacing between items
                      mainAxisSpacing: 10, // Vertical spacing between items
                    ),
                    itemCount: 6, // We have 4 items
                    itemBuilder: (context, index) {
                      // List of images
                      List<String> images = [
                        'assets/images/training_icon.png',
                        'assets/images/medi3.jpeg',
                        'assets/images/help_icon.png',
                        'assets/images/call1.png',
                        'assets/images/food1.jpg',
                        'assets/images/funspace1.png',
                      ];
                      // List of titles
                      List<String> titles = [
                        'Therapy',
                        'Meditation',
                        'Help',
                        'Call Schedule',
                        'Food Order',
                        'FunSpace'
                      ];

                      return GestureDetector(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TherapyHomePage()),
                              );
                              break;
                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Meditation()),
                              );
                              break;
                            case 2:
                              _announceAndNavigate();
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Callschedule()),
                              );
                              break;
                            case 4:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Memoriesvideo()),
                              );
                              break;
                            case 5:
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Funspace()),
                              );
                              break;
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                images[index],
                                height: 150,
                                width: 150,
                                fit: BoxFit
                                    .cover, // Ensures the image fills the circular shape
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              titles[index],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF263238),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                FlutterPhoneDirectCaller.callNumber('+91 9110307224');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Color(0xFFFF0000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'SOS',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
