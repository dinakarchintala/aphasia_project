import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For base64 encoding
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Foodorder extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<Foodorder> {
  // Twilio credentials
  final accountSid = 'ACe3d8789786eae8151ea0cc74f7777579';
  final authToken = 'fc46038c5f76baa46a16c6e0397443db';
  final fromPhone = '+13345106729';
  final toPhone = '+919110307224';

  // Food categories
  final Map<String, List<Map<String, String>>> foodOptions = {
    'Morning': [
      {'image': 'assets/images/Dosa.png', 'name': 'dosa'},
      {'image': 'assets/images/apple.jpg', 'name': 'Toast'},
      {'image': 'assets/images/apple.jpg', 'name': 'Toast'},
      {'image': 'assets/images/apple.jpg', 'name': 'Toast'},
      {'image': 'assets/images/apple.jpg', 'name': 'Toast'},
      {'image': 'assets/images/apple.jpg', 'name': 'Toast'},
      {'image': 'assets/images/apple.jpg', 'name': 'Toast'},
      {'image': 'assets/images/apple.jpg', 'name': 'Toast'},
    ],
    'Afternoon': [
      {'image': 'assets/images/Lunch.png', 'name': 'Rice'},
      {'image': 'assets/images/apple.jpg', 'name': 'apple'},
    ],
    'Evening': [
      {'image': 'assets/images/apple.jpg', 'name': 'apple'},
      {'image': 'assets/images/apple.jpg', 'name': 'apple'},
    ],
  };

  // Function to send a message using Twilio
  void _sendMessage(String foodName) async {
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
        'Body': 'The patient selected $foodName for their meal.',
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

  Widget _buildFoodSection(String timeOfDay, List<Map<String, String>> foods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$timeOfDay Meals:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        // Horizontal ListView for food items
        SizedBox(
          height: 200, // Set a fixed height for horizontal scrolling
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return GestureDetector(
                onTap: () {
                  _sendMessage(food['name']!);
                },
                child: Container(
                  width: 150, // Set a fixed width for each item
                  margin: EdgeInsets.only(right: 10),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              food['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            food['name']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Order for Therapy'),
      ),
      body: SingleChildScrollView(
        // Makes the entire body scrollable
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select a food for the day:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Morning food section
              _buildFoodSection('Morning', foodOptions['Morning']!),
              SizedBox(height: 20),
              // Afternoon food section
              _buildFoodSection('Afternoon', foodOptions['Afternoon']!),
              SizedBox(height: 20),
              // Evening food section
              _buildFoodSection('Evening', foodOptions['Evening']!),
            ],
          ),
        ),
      ),
    );
  }
}
