import 'package:aphasia_bot/pages/helppage.dart';
import 'package:aphasia_bot/pages/home.dart';
import 'package:aphasia_bot/utilpages/Familyquiz.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
import 'package:flutter/material.dart';

class Homedesign extends StatelessWidget {
  const Homedesign({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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

                  // List of specific names for each container
                  List<String> names = [
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
                            height: 100, // Adjust height as needed
                            width: 100,  // Adjust width as needed
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          // Display the specific name for each container
                          Text(
                            names[index],
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }
}

// Define the new pages
class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page One')),
      body: Center(child: Text('This is Page One')),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Two')),
      body: Center(child: Text('This is Page Two')),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Three')),
      body: Center(child: Text('This is Page Three')),
    );
  }
}

class PageFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Four')),
      body: Center(child: Text('This is Page Four')),
    );
  }
}
