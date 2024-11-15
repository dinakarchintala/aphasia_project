// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aphasia_bot/services/translation_service.dart'; // Import your TranslationService class
import 'package:aphasia_bot/pages/helppage.dart';
import 'package:aphasia_bot/pages/home.dart';
import 'package:aphasia_bot/pages/homedesign.dart';
import 'package:aphasia_bot/pages/listening.dart';
import 'package:aphasia_bot/pages/reading.dart';
import 'package:aphasia_bot/pages/speaking.dart';
import 'package:aphasia_bot/pages/welcome.dart';
import 'package:aphasia_bot/pages/writing.dart';
import 'package:aphasia_bot/utilpages/Familyquiz.dart';
import 'package:aphasia_bot/utilpages/completion.dart';
import 'package:aphasia_bot/utilpages/listening1.dart';
import 'package:aphasia_bot/utilpages/listening2.dart';
import 'package:aphasia_bot/utilpages/listening3.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
import 'package:aphasia_bot/utilpages/reading1.dart';
import 'package:aphasia_bot/utilpages/reading2.dart';
import 'package:aphasia_bot/utilpages/speaking1.dart';
import 'package:aphasia_bot/utilpages/speaking2.dart';
import 'package:aphasia_bot/utilpages/speaking3.dart';
import 'package:aphasia_bot/utilpages/writing1.dart';
import 'package:aphasia_bot/utilpages/writing2.dart';
import 'package:aphasia_bot/utilpages/writing3.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranslationService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
      routes: {
        '/Welcome': (context) => WelcomePage(),
        '/Home': (context) => TherapyHomePage(),
        '/Helppage': (context) => Helppage(),
        '/Memoriesvideo': (context) => Memoriesvideo(),
        '/Homedesign': (context) => Homedesign(),
        '/Listening': (context) => Listening(),
        '/Familyquiz': (context) => Familyquiz(),
        '/Writing': (context) => Writing(),
        '/Speaking': (context) => Speaking(),
        '/Reading': (context) => Reading(),
        '/Listeningpicture': (context) => Listeningpicture(),
        '/Listeningword': (context) => Listeningword(),
        '/Listeningalphabet': (context) => ListeningAlphabet(),
        '/Writingpicture': (context) => Writingpicture(),
        '/Writingword': (context) => Writingword(),
        '/Writingalphabet': (context) => Writingalphabet(),
        '/Speakingpicture': (context) => Speakingpicture(),
        '/Speakingword': (context) => Speakingword(),
        '/Spekaingalphabet': (context) => Speakingalphabet(),
        '/Readingpicture': (context) => ReadAndChoosePage(),
        '/Readingmatch': (context) => ReadAndMatch(),
        '/completion': (context) => CompletionPage(),
      },
    );
  }
}
