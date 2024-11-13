import 'package:aphasia_bot/pages/helppage.dart';
import 'package:aphasia_bot/pages/home.dart';
import 'package:aphasia_bot/utilpages/Familyquiz.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.indigo,
                  Colors.purple,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Home Page",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    padding: EdgeInsets.all(15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: (MediaQuery.of(context).size.height - 50 - 25) / (4 * 240),
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      // List of images
                      List<String> images = [
                        'assets/images/training_icon.png',
                        'assets/images/family_quiz.png',
                        'assets/images/help_icon.png',
                        'assets/images/memories.png'
                      ];

                      // List of specific keys for translation
                      List<String> translationKeys = [
                        'Therapy',
                        'Family Quiz',
                        'Help',
                        'Memories'
                      ];

                      return InkWell(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TherapyHomePage()),
                              );
                              break;
                            case 1:
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Familyquiz()),
                              );
                              break;
                            case 2:
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Helppage()),
                              );
                              break;
                            case 3:
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Memoriesvideo()),
                              );
                              break;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Display the image for the current index
                              Image.asset(
                                images[index],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 10),
                              // Display translated text
                              FutureBuilder<String>(
                                future: translationService.translate(translationKeys[index]),
                                builder: (context, snapshot) {
                                  return Text(
                                    snapshot.data ?? translationKeys[index],
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ],
                          ),
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
               FlutterPhoneDirectCaller.callNumber('+91 9381272709');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'SOS',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
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
