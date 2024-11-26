import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

/// Helper Class to Load and Cache PDFs
class PdfHelper {
  static Map<String, String?> cachedPaths = {};

  /// Preload the PDF from assets
  static Future<String> preloadPdf(String assetPath) async {
    if (cachedPaths[assetPath] != null) return cachedPaths[assetPath]!;

    final ByteData data = await rootBundle.load(assetPath);
    final buffer = data.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(buffer, flush: true);

    cachedPaths[assetPath] = file.path; // Cache the path for future use
    return cachedPaths[assetPath]!;
  }
}

/// Religious Books Selection Page
class ReligiousBooksPage extends StatelessWidget {
  final List<Map<String, String>> books = [
    {'title': 'Bagavad Gita', 'asset': 'assets/books/Bhagavad-Gita.pdf'},
    // {'title': 'Holy Quran', 'asset': 'assets/books/holy-Quran.pdf'},
    // {'title': 'Holy Bible', 'asset': 'assets/books/holy-Bible.pdf'},
  ];

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text('Religious Books'),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Container(
            height: screenHeight * 0.2, // 10% of the screen height
            margin: EdgeInsets.symmetric(
              vertical: screenHeight * 0.06, // 1% vertical margin
              horizontal: screenWidth * 0.3, // 5% horizontal margin
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () async {
                final pdfPath = await PdfHelper.preloadPdf(book['asset']!);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PdfViewerPage(
                      pdfPath: pdfPath,
                      title: book['title']!,
                    ),
                  ),
                );
              },
              child: Text(
                book['title']!,
                style: TextStyle(
                    fontSize: screenWidth * 0.05), // Dynamic font size
              ),
            ),
          );
        },
      ),
    );
  }
}

/// PDF Viewer Page
class PdfViewerPage extends StatelessWidget {
  final String pdfPath;
  final String title;

  const PdfViewerPage({required this.pdfPath, required this.title});

  @override
  Widget build(BuildContext context) {
    // Screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          width: 500,
          height: 600,
          child: PDFView(
            filePath: pdfPath,
            enableSwipe: true,
            swipeHorizontal: false, // Vertical scrolling
            autoSpacing: true,
            pageFling: true,
            onPageError: (page, error) {
              print('Error on page $page: $error');
            },
          ),
        ),
      ),
    );
  }
}
