// ignore_for_file: prefer_const_constructors, sort_child_properties_last, library_private_types_in_public_api, non_constant_identifier_names, curly_braces_in_flow_control_structures, prefer_final_fields

import 'dart:async';

import 'package:aphasia_bot/utilis/helpimage.dart';
import 'package:aphasia_bot/utilis/ttsbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Helppage extends StatefulWidget {
  const Helppage({super.key});

  @override
  _HelppageState createState() => _HelppageState();
}

class _HelppageState extends State<Helppage> {
  FlutterTts flutterTts = FlutterTts();
  String poptext = "Select an Image ...";
  List<String> prompt_text = [
    "Its Emergency",
    "I need Dosa",
    "I need Lunch",
    "I need Medicines",
    "I want to drink Water",
    "I need to go to the Washroom",
    "I want to go for a Walk",
    
  ];
  
  List<String> Images = [
    'assets/images/emergency.png',
    'assets/images/Dosa.png',
    'assets/images/Lunch.png',
    'assets/images/Medicines.png',
    'assets/images/Water.png',
    'assets/images/Washroom.png',
    'assets/images/Walking.png',
    
  ];
  
  int currentPairIndex = 0;
  Timer? _feedbackTimer; // Timer for feedback and delay

  @override
  void dispose() {
    _feedbackTimer?.cancel(); // Cancel timer on widget disposal
    super.dispose();
  }

  
  void stopfn() {
    Navigator.pop(context);
  }

  void ontap() {
    setState(() {
     
      _feedbackTimer = Timer(Duration(seconds: 2), () {
        // 2-second delay
        setState(() {
          poptext = prompt_text[currentPairIndex];
         
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(255, 254, 254, 252),
      appBar: AppBar(
        title: Text(
          'HELP',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color.fromARGB(255, 221, 189, 252),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SpeechFromText(textToSpeak: prompt_text[currentPairIndex]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ImageContainer(
                imagePath: Images[currentPairIndex],
                onTap: ontap,
              ),
              
            ],
          ),
          Container(
            child: Column(
              children: [
              Text(
                poptext=prompt_text[currentPairIndex],
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                
              ),
              ListTile(
                trailing:  IconButton(
                  icon:Icon(Icons.arrow_forward,size: 30),
                  onPressed: (){
                    setState(() {
                      if(currentPairIndex<6)
                      {
                      currentPairIndex++;
                      }
                    });
                  },),
                leading: IconButton(
                  icon:Icon(Icons.arrow_back,size:30),
                  onPressed: (){
                    setState(() {
                      if(currentPairIndex!=0)
                      {
                          currentPairIndex--;
                      }   
                    });
                  },),
              )
            ],
            ),
            
          ),
          
        ],
      ),
    );
  }
}
