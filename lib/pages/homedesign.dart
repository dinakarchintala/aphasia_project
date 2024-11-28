import 'package:aphasia_bot/pages/findinpicture.dart';
import 'package:aphasia_bot/pages/listening.dart';
import 'package:aphasia_bot/pages/reading.dart';
import 'package:aphasia_bot/pages/speaking.dart';
import 'package:aphasia_bot/pages/writing.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
import 'package:flutter/material.dart';
import 'package:aphasia_bot/pages/helppage.dart';
import 'package:aphasia_bot/pages/funspace.dart';
import 'package:aphasia_bot/pages/callschedule.dart';
import 'package:aphasia_bot/pages/home.dart';
import 'package:aphasia_bot/utilpages/foodorder.dart';
import 'package:aphasia_bot/utilpages/meditation.dart';
import 'package:aphasia_bot/services/translation_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Homedesign extends StatefulWidget {
  const Homedesign({super.key});

  @override
  _HomedesignState createState() => _HomedesignState();
}

class _HomedesignState extends State<Homedesign> {
  bool _isTherapySelected = true; // Track which section is selected

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
          Column(
            children: [
              const SizedBox(height: 20),
              // Toggle buttons for Therapy and Personal Space
              Center(
                child: Container(
                  width: 350,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25), // Circular shape
                    border: Border.all(color: Colors.black),
                  ),
                  child: Row(
                    children: [
                      // Therapy Option
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isTherapySelected = true;
                            });
                          },
                          child: FutureBuilder<String>(
                            future:
                                translationService.getTranslation("Therapy"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading translation'));
                              } else if (snapshot.hasData) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: _isTherapySelected
                                        ? Colors.yellow
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: _isTherapySelected
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: Text('No data available'));
                              }
                            },
                          ),
                        ),
                      ),
                      // Personal Space Option
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isTherapySelected = false;
                            });
                          },
                          child: FutureBuilder<String>(
                            future: translationService
                                .getTranslation("Personal Space"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading translation'));
                              } else if (snapshot.hasData) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: !_isTherapySelected
                                        ? Colors.yellow
                                        : Colors.transparent,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    snapshot.data!,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: !_isTherapySelected
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: Text('No data available'));
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Display the corresponding section based on selection
              Expanded(
                child: _isTherapySelected
                    ? TherapySection()
                    : PersonalSpaceSection(),
              ),
            ],
          ),

          // SOS Button at the bottom right
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
              child: FutureBuilder<String>(
                future: translationService.getTranslation("SOS"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading translation');
                  } else if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Therapy section content
class TherapySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var translationService = Provider.of<TranslationService>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              childAspectRatio:
                  MediaQuery.of(context).size.width > 600 ? 1.6 : 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 5,
            itemBuilder: (context, index) {
              List<String> images = [
                'assets/homepage/aphasia.png',
                'assets/homepage/listeningaphasia.png',
                'assets/homepage/writingaphasia.png',
                'assets/homepage/speakingaphasia.png',
                'assets/homepage/Readingaphasia.png',
              ];
              List<String> titles = [
                "find picture",
                "Listening",
                "Writing",
                "Speaking",
                "Reading",
              ];

              return GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FindInPicture()),
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Listening()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Writing()),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Speaking()),
                      );
                      break;
                    case 4:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Reading()),
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
                    FutureBuilder<String>(
                      future: translationService.getTranslation(titles[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error loading translation');
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                            ),
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text('No data available');
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Personal Space section content
class PersonalSpaceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var translationService = Provider.of<TranslationService>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              childAspectRatio:
                  MediaQuery.of(context).size.width > 600 ? 1.6 : 0.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              List<String> images = [
                'assets/images/medi3.jpeg',
                'assets/images/memories.png',
                'assets/images/call1.png',
                'assets/images/help_icon.png',
                'assets/images/food1.jpg',
                'assets/images/funspace1.png',
              ];
              List<String> titles = [
                "Meditation",
                "Memories",
                "Call Schedule",
                "Help",
                "Select Food",
                "Fun Space",
              ];

              return GestureDetector(
                onTap: () {
                  switch (index) {
                    case 0:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Meditation()),
                      );
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Memoriesvideo()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Callschedule()),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Helppage()),
                      );
                      break;
                    case 4:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Foodorder()),
                      );
                      break;
                    case 5:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Funspace()),
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
                    FutureBuilder<String>(
                      future: translationService.getTranslation(titles[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error loading translation');
                        } else if (snapshot.hasData) {
                          return Text(
                            snapshot.data!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                            ),
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Text('No data available');
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
