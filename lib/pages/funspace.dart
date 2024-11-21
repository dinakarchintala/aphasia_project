import 'package:aphasia_bot/utilpages/Familyquiz.dart';
import 'package:flutter/material.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
import 'package:aphasia_bot/utilpages/ReligiousBooksPage.dart';

class Funspace extends StatelessWidget {
  const Funspace({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'FunSpace',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFE3F2FD),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2,
        ),
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              color: Color(0xFFFFFFFF),
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
                  SizedBox(height: 10),
                  Text(
                    titles[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
      ),
    );
  }
}

// Placeholder pages for each section
// class MemoriesPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Memories'),
//         backgroundColor: Colors.white,
//       ),
//       body: Center(child: Text('Welcome to Memories!')),
//     );
//   }
// }

// class FunQuizPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Fun Quiz'),
//         backgroundColor: Colors.white,
//       ),
//       body: Center(child: Text('Welcome to Fun Quiz!')),
//     );
//   }
// }

class StorytellingSessionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Storytelling Session'),
        backgroundColor: Colors.white,
      ),
      body: Center(child: Text('Welcome to Storytelling Session!')),
    );
  }
}

class ArtsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arts'),
        backgroundColor: Colors.white,
      ),
      body: Center(child: Text('Welcome to Arts!')),
    );
  }
}

// class ReligiousBooksPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Religious Books'),
//         backgroundColor: Colors.white,
//       ),
//       body: Center(child: Text('Welcome to Religious Books!')),
//     );
//   }
// }
