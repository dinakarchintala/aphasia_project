import 'package:aphasia_bot/pages/helppage.dart';
import 'package:aphasia_bot/pages/funspace.dart';
import 'package:aphasia_bot/pages/callschedule.dart';
import 'package:aphasia_bot/pages/home.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
import 'package:aphasia_bot/utilpages/meditation.dart';
import 'package:flutter/material.dart';
import 'package:aphasia_bot/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Homedesign extends StatelessWidget {
  const Homedesign({super.key});

  @override
  Widget build(BuildContext context) {
    var translationService = Provider.of<TranslationService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.translate),
            onSelected: (String languageCode) {
              translationService.changeLanguage(languageCode);
            },
            itemBuilder: (context) => const [
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
              child: FutureBuilder<List<String>>(
                // Fetch translations for all titles at once
                future: Future.wait([
                  translationService.getTranslation("Home Page"),
                  translationService.getTranslation("Therapy"),
                  translationService.getTranslation("Meditation"),
                  translationService.getTranslation("Help"),
                  translationService.getTranslation("Call Schedule"),
                  translationService.getTranslation("Food Order"),
                  translationService.getTranslation("FunSpace"),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    // Extract translated texts
                    List<String> translatedTitles = snapshot.data ?? [];
                    String homePageTitle = translatedTitles[0];
                    List<String> titles = translatedTitles.sublist(1);

                    return Column(
                      children: [
                        // Header for the Home Page
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            homePageTitle,
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF263238),
                            ),
                          ),
                        ),
                        // Grid of options
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 3 : 2,
                            childAspectRatio:
                                MediaQuery.of(context).size.width > 600
                                    ? 1.6
                                    : 0.9,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: 6,
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

                            return GestureDetector(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TherapyHomePage()),
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Helppage()),
                                    );
                                    break;
                                  case 3:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Callschedule()),
                                    );
                                    break;
                                  case 4:
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Memoriesvideo()),
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
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    titles[index],
                                    style: const TextStyle(
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
                    );
                  }
                },
              ),
            ),
          ),
          // SOS Button
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                FlutterPhoneDirectCaller.callNumber('+91 9110307224');
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: const Color(0xFFFF0000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
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
