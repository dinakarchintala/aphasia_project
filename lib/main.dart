// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aphasia_bot/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aphasia_bot/services/translation_service.dart';
import 'package:aphasia_bot/services/auth_service.dart';
import 'package:aphasia_bot/datasets/findpicturesw1.dart'; // Import your week datasets
import 'package:aphasia_bot/datasets/findpicturesw2.dart';
import 'package:aphasia_bot/datasets/findpicturesw3.dart';
import 'package:aphasia_bot/pages/helppage.dart';
import 'package:aphasia_bot/pages/home.dart';
import 'package:aphasia_bot/pages/funspace.dart';
import 'package:aphasia_bot/pages/callschedule.dart';
import 'package:aphasia_bot/pages/homedesign.dart';
import 'package:aphasia_bot/pages/listening.dart';
import 'package:aphasia_bot/pages/reading.dart';
import 'package:aphasia_bot/pages/speaking.dart';
import 'package:aphasia_bot/pages/welcome.dart';
import 'package:aphasia_bot/pages/writing.dart';
import 'package:aphasia_bot/pages/findinpicture.dart';
import 'package:aphasia_bot/utilpages/Familyquiz.dart';
import 'package:aphasia_bot/utilpages/ReligiousBooksPage.dart';
import 'package:aphasia_bot/utilpages/completion.dart';
import 'package:aphasia_bot/utilpages/listening1.dart';
import 'package:aphasia_bot/utilpages/listening2.dart';
import 'package:aphasia_bot/utilpages/listening3.dart';
import 'package:aphasia_bot/utilpages/memoriesvideo.dart';
import 'package:aphasia_bot/utilpages/meditation.dart';
import 'package:aphasia_bot/utilpages/reading1.dart';
import 'package:aphasia_bot/utilpages/reading2.dart';
import 'package:aphasia_bot/utilpages/speaking1.dart';
import 'package:aphasia_bot/utilpages/speaking2.dart';
import 'package:aphasia_bot/utilpages/speaking3.dart';
import 'package:aphasia_bot/utilpages/writing1.dart';
import 'package:aphasia_bot/utilpages/writing2.dart';
import 'package:aphasia_bot/utilpages/writing3.dart';
import 'package:aphasia_bot/utilpages/foodorder.dart';
import 'package:aphasia_bot/utilpages/artspage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TranslationService()),
        Provider<Auth>(create: (_) => Auth()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: auth.authStateChanges,
        builder: (context, snapshot) {
          // Check if user is logged in
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // User is logged in
            return WelcomePage(); // Replace with your main logged-in screen
          } else {
            // User is logged out
            return WelcomePage(); // Replace with your login/signup page
          }
        },
      ),
      routes: {
        '/FindInPictureWeek1':(context) =>FindInPictureWeek1(),
        '/FindInPictureWeek2':(context) =>FindInPictureWeek2(),
        '/FindInPictureWeek3':(context) =>FindInPictureWeek3(),
        '/Welcome': (context) => WelcomePage(),
        '/Home': (context) => TherapyHomePage(),
        '/Helppage': (context) => Helppage(),
        '/Memoriesvideo': (context) => Memoriesvideo(),
        '/Meditation': (context) => Meditation(),
        '/Callschedule': (context) => Callschedule(),
        '/Foodorder': (context) => Foodorder(),
        '/Religiousbookspage': (context) => ReligiousBooksPage(),
        '/Funspace': (context) => Funspace(),
        '/Homedesign': (context) => Homedesign(),
        '/Listening': (context) => Listening(),
        '/Familyquiz': (context) => Familyquiz(),
        '/artspage': (context) => Artspage(),
        '/Writing': (context) => Writing(),
        '/Speaking': (context) => Speaking(),
        '/Reading': (context) => Reading(),
        '/findpicture': (context) => FindInPicture(),
        '/Listeningpicture': (context) => ListeningPicture(),
        '/Listeningword': (context) => Listeningword(),
        '/Listeningalphabet': (context) => ListeningAlphabet(),
        '/Writingpicture': (context) => Writingpicture(),
        '/Writingword': (context) => Writingword(),
        '/Writingalphabet': (context) => Writingalphabet(),
        '/Speakingpicture': (context) => Speakingpicture(),
        '/Speakingword': (context) => Speakingword(),
        '/Speakingalphabet': (context) => Speakingalphabet(),
        '/Readingpicture': (context) => ReadAndChoosePage(),
        '/Readingmatch': (context) => ReadAndMatch(),
        '/completion': (context) => CompletionPage(),
      },
    );
  }
}
