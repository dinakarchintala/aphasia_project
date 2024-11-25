import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Helppage extends StatefulWidget {
  const Helppage({super.key});

  @override
  _HelppageState createState() => _HelppageState();
}

class _HelppageState extends State<Helppage> {
  FlutterTts flutterTts = FlutterTts();

  List<String> prompt_text = [
    "It's an Emergency",
    "I need Medicines",
    "I have a Headache",
    "I need to go to the Washroom",
    "I need Dosa",
    "I need Lunch",
    "I want to drink Water",
    "I want to go for a Walk",
  ];

  List<String> Images = [
    'assets/images/emergency.png',
    'assets/images/Medicines.png',
    'assets/homepage/headache.jpg',
    'assets/images/Washroom.png',
    'assets/images/Dosa.png',
    'assets/images/Lunch.png',
    'assets/images/Water.png',
    'assets/images/Walking.png',
  ];

  @override
  void dispose() {
    flutterTts.stop(); // Stop TTS when the widget is disposed
    super.dispose();
  }

  List<List<int>> _getChunks(List<dynamic> list, int chunkSize) {
    List<List<int>> chunks = [];
    for (int i = 0; i < list.length; i += chunkSize) {
      int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
      chunks.add(List<int>.generate(end - i, (index) => i + index));
    }
    return chunks;
  }

  void _speakText(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(text);
  }

  // void _sendWhatsAppMessage(String message) async {
  //   const phone = '+919110307224'; // Replace with the actual phone number
  //   final Uri whatsappUrl =
  //       Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

  //   if (await canLaunchUrl(whatsappUrl)) {
  //     await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //           content: Text("Could not open WhatsApp. Please check your setup.")),
  //     );
  //   }
  // }

  Future<void> _sendSmsUsingTwilio(String message) async {
    const accountSid =
        'ACe3d8789786eae8151ea0cc74f77775'; // Replace with your Twilio Account SID79
    const authToken =
        'fc46038c5f76baa46a16c6e0397443db'; // Replace with your Twilio Auth Token
    const fromPhone = '+13345106729'; // Your Twilio phone number
    const toPhone = '+919110307224'; // Recipient's phone number

    final Uri url = Uri.parse(
        'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json');

    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
      },
      body: {
        'From': fromPhone,
        'To': toPhone,
        'Body': message,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Message sent successfully.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to send message. Error: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Group items into chunks of 4
    List<List<int>> chunks = _getChunks(prompt_text, 4);

    return Scaffold(
      backgroundColor: Color(0xFFE3F2FD),
      appBar: AppBar(
        title: Text(
          'HELP',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: PageView.builder(
        itemCount: chunks.length,
        itemBuilder: (context, pageIndex) {
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2,
            ),
            itemCount: chunks[pageIndex].length,
            itemBuilder: (context, index) {
              int itemIndex = chunks[pageIndex][index];
              return Card(
                color: Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _speakText(prompt_text[itemIndex]);
                        _sendSmsUsingTwilio(prompt_text[itemIndex]);
                      },
                      child: Image.asset(
                        Images[itemIndex],
                        height: 200,
                        width: 200,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      prompt_text[itemIndex],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF263238),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
