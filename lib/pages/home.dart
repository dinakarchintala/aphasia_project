// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TherapyHomePage extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/listening.png',
    'assets/images/writing.jpeg',
    'assets/images/speaking.jpg',
    'assets/images/reading.jpg',
  ];

  final List<String> labels = [
    'Listening',
    'Writing',
    'Speaking',
    'Reading',
  ];

  final List<String> pageroutes = [
    '/Listening',
    '/Writing',
    '/Speaking',
    '/Reading',
  ];

  TherapyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/Welcome');
            },
          ),
        ],
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFFFFEB3B),
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
      body: PageView.builder(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        itemCount: (imagePaths.length / 2).ceil(),
        itemBuilder: (context, pageIndex) {
          final startIndex = pageIndex * 2;
          final itemsOnPage = imagePaths.sublist(
            startIndex,
            (startIndex + 2) > imagePaths.length
                ? imagePaths.length
                : startIndex + 2,
          );

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(itemsOnPage.length, (itemIndex) {
              final actualIndex = startIndex + itemIndex;
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, pageroutes[actualIndex]);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePaths[actualIndex],
                      width: 350, // Adjust size as needed
                      height: 350,
                    ),
                    SizedBox(height: 20),
                    Text(
                      labels[actualIndex],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001F3F), // Dark Navy
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
