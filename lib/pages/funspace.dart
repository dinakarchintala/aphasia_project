import 'package:aphasia_bot/utilpages/Familyquiz.dart';
import 'package:flutter/material.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
import 'package:aphasia_bot/utilpages/ReligiousBooksPage.dart';
import 'package:provider/provider.dart';
import 'package:aphasia_bot/services/translation_service.dart';

class Funspace extends StatelessWidget {
  const Funspace({super.key});

  @override
  Widget build(BuildContext context) {
    var translationService = Provider.of<TranslationService>(context);

    // List of subsections
    List<String> titles = [
      "Memories",
      "Fun Quiz",
      "Storytelling Session",
      "Arts",
      "Reading Religious Books",
    ];

    List<String> images = [
      'assets/images/memories.png',
      'assets/images/family_quiz.png',
      'assets/funspace/storytellingsession.jpeg',
      'assets/funspace/art.jpeg',
      'assets/funspace/religousbooks.png',
    ];

    List<Widget> pages = [
      Memoriesvideo(), // Implement each corresponding page
      Familyquiz(),
      StorytellingSessionPage(),
      ArtsPage(),
      ReligiousBooksPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: translationService.getTranslation('FunSpace'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return Text(
              snapshot.data ?? 'FunSpace',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            );
          },
        ),
        backgroundColor: Colors.white,
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
      backgroundColor: const Color(0xFFE3F2FD),
      body: FutureBuilder<List<String>>(
        future: Future.wait(titles.map((title) => translationService.getTranslation(title))),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> translatedTitles = snapshot.data ?? titles;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two items per row
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2,
              ),
              itemCount: translatedTitles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    color: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => pages[index]),
                            );
                          },
                          child: Image.asset(
                            images[index],
                            height: 180,
                            width: 180,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          translatedTitles[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF263238),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// Placeholder pages for each section
class StorytellingSessionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storytelling Session'),
        backgroundColor: Colors.white,
      ),
      body: const Center(child: Text('Welcome to Storytelling Session!')),
    );
  }
}

class ArtsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arts'),
        backgroundColor: Colors.white,
      ),
      body: const Center(child: Text('Welcome to Arts!')),
    );
  }
}
