import 'package:flutter/material.dart';

class Artspage extends StatefulWidget {
  @override
  _ArtGalleryState createState() => _ArtGalleryState();
}

class _ArtGalleryState extends State<Artspage> {
  // Art categories and their corresponding images
  final Map<String, List<String>> artCategories = {
    'Famous Paintings': [
      'assets/arts/famouspaintings.jpg',
      'assets/arts/famouspaintings.jpg',
      'assets/arts/famouspaintings.jpg',
      'assets/arts/famouspaintings.jpg',
      'assets/arts/painting2.jpg',
      'assets/arts/painting3.jpg',
      'assets/arts/painting4.jpg',
    ],
    'Egyptian Culture': [
      'assets/arts/egyptculture.jpeg',
      'assets/arts/egypt2.jpg',
      'assets/arts/egypt3.jpg',
      'assets/arts/egypt4.jpg',
    ],
    'Modern Art': [
      'assets/arts/modernart.jpeg',
      'assets/arts/modern2.jpg',
      'assets/arts/modern3.jpg',
      'assets/arts/modern4.jpg',
    ],
    'Sculptures': [
      'assets/arts/zues.jpeg',
      'assets/arts/cyrus.jpg',
      'assets/arts/hephaestus.jpg',
      'assets/arts/anthena.jpg',
      'assets/arts/alex.jpg',
      'assets/arts/shiva.jpeg',
    ],
  };

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text('Art Gallery'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Explore Art Categories:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Horizontal list for art categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: artCategories.keys.map((category) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = category; // Set selected category
                        });
                      },
                      child: Container(
                        width: 230,
                        height: 400,
                        margin: EdgeInsets.only(right: 40),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                artCategories[category]![0],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  category,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              // Display images of the selected category
              if (selectedCategory != null) ...[
                Text(
                  'Selected Category: $selectedCategory',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: artCategories[selectedCategory]!.map((image) {
                      return Container(
                        width: 220,
                        height: 400,
                        margin: EdgeInsets.only(right: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
