import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Toggle state for Sign In / Create Account
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isLogin = true;
              });
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isLogin ? Colors.blue : Colors.grey,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isLogin = false;
              });
            },
            child: Text(
              'Create Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: !isLogin ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isLogin)
            TextField(
              controller: _controllerName,
              decoration: InputDecoration(labelText: 'Name'),
            ),
          TextField(
            controller: _controllerEmail,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _controllerPassword,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (isLogin) {
              // Handle Sign In
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _controllerEmail.text.trim(),
                  password: _controllerPassword.text.trim(),
                );
                Navigator.of(context).pop(); // Close the modal on success
              } on FirebaseAuthException catch (e) {
                _showErrorSnackBar(e.message ?? 'An error occurred');
              }
            } else {
              // Handle Create Account
              try {
                final UserCredential userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _controllerEmail.text.trim(),
                  password: _controllerPassword.text.trim(),
                );

                // Update display name
                await userCredential.user?.updateDisplayName(
                  _controllerName.text.trim(),
                );

                Navigator.of(context).pop(); // Close the modal on success
              } on FirebaseAuthException catch (e) {
                _showErrorSnackBar(e.message ?? 'An error occurred');
              }
            }
          },
          child: Text(isLogin ? 'Sign In' : 'Create Account'),
        ),
      ],
    );
  }
}
