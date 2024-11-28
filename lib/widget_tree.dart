import 'package:aphasia_bot/pages/welcome.dart';
import 'package:aphasia_bot/services/auth_service.dart';
import 'package:aphasia_bot/pages/auth_modal.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _widgetTreeState();
}

class _widgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WelcomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
