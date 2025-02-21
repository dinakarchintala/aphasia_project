// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ListeningWeek1 extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/listening.png',
    'assets/images/listening.png',
    'assets/images/listening.png',
  ];

  final List<String> labels = [
    'Listen and Choose the Picture',
    'Listen and Choose the Word',
    'Listen and Type the Alphabet',
  ];

  final List<String> pageroutes = [
    '/Listeningpicture',
    '/Listeningword',
    '/Listeningalphabet',
  ];

  ListeningWeek1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/Home');
            },
          ),
        ],
        title: Text(
          'Listening-Therapy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.white, // Seafoam Green
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFFEB3B), // Seafoam Green
              ),
              child: Center(
                child: Text(
                  'Quick Access',
                  style: TextStyle(
                    color: Color(0xFF263238),
                    fontSize: 42,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.hearing),
              title: Text(
                'Listening',
                style: TextStyle(fontSize: 21),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Listening');
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Writing', style: TextStyle(fontSize: 21)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Writing');
              },
            ),
            ListTile(
              leading: Icon(Icons.mic),
              title: Text('Speaking', style: TextStyle(fontSize: 21)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Speaking');
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Reading', style: TextStyle(fontSize: 21)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Reading');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 100), // Add spacing at the top
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Three items per row
                crossAxisSpacing: 10.0, // Spacing between items horizontally
                mainAxisSpacing: 10.0, // Spacing between items vertically
                childAspectRatio: 1, // Make items square
              ),
              itemCount: imagePaths.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, pageroutes[index]);
                      },
                      child: Image.asset(
                        imagePaths[index],
                        width: 300, // Adjust size as needed
                        height: 300,
                      ),
                    ),
                    SizedBox(height: 10), // Spacing between image and text
                    Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001F3F), // Dark Navy
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
