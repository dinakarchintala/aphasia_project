import 'package:flutter/material.dart';

class Speaking extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/speaking.jpeg',
    'assets/images/speaking.jpeg',
    'assets/images/speaking.jpeg',
  ];

  final List<String> labels = [
    'Name the Picture',
    'Name the Word',
    'Name the Letter',
  ];

  final List<String> pageroutes = [
    '/Speakingpicture',
    '/Speakingword',
    '/Speakingalphabet',
  ];

  Speaking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
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
          'Speaking-Therapy',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
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
