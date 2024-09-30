import 'package:flutter/material.dart';

class Reading extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/reading.jpg',
    'assets/images/reading.jpg'
  ];

  final List<String> labels = [
    'Read and Choose the Image',
    'Match Capital and Small letters',
  ];

  final List<String> pageroutes = [
    '/Readingpicture',
    '/Readingmatch',
  ];

   Reading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushNamed(context, '/Home');
            },
          ),
        ],
        title: const Text(
          'Reading-Therapy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: const Color(0xFFBDFCC9), // Seafoam Green
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFFBDFCC9), // Seafoam Green
              ),
              child: Text(
                'Quick Access',
                style: TextStyle(
                  color: Colors.green[800],
                  fontSize: 34,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.hearing),
              title: const Text(
                'Listening',
                style: TextStyle(fontSize: 21),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Listening');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Writing', style: TextStyle(fontSize: 21)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Writing');
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Speaking', style: TextStyle(fontSize: 21)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Speaking');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Reading', style: TextStyle(fontSize: 21)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/Reading');
              },
            ),
          ],
        ),
      ),
      body: PageView.builder(
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, pageroutes[index]);
            },
            child: Container(
              color: const Color(0xFFF2F2F2), // Light Gray background
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      imagePaths[index],
                      width: 400, // Adjust size as needed
                      height: 400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      labels[index],
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF001F3F), // Dark Navy
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
