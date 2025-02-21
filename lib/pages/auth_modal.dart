import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Toggle state for Sign In / Create Account
  bool isDoctor = false; // Toggle state for Doctor / Care Taker
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerAge = TextEditingController();
  final TextEditingController _controllerPatientSeverity = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Sign In' : 'Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isLogin)
              Column(
                children: [
                  Text(
                    'Select Role',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: Text('Doctor'),
                        selected: isDoctor,
                        onSelected: (selected) {
                          setState(() {
                            isDoctor = selected;
                          });
                        },
                      ),
                      SizedBox(width: 20),
                      ChoiceChip(
                        label: Text('Care Taker'),
                        selected: !isDoctor,
                        onSelected: (selected) {
                          setState(() {
                            isDoctor = !selected;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            if (!isLogin)
              TextField(
                controller: _controllerName,
                decoration: InputDecoration(labelText: 'Name'),
              ),
            if (!isLogin)
              TextField(
                controller: _controllerAge,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
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
            if (!isLogin && isDoctor)
              TextField(
                controller: _controllerPatientSeverity,
                decoration: InputDecoration(labelText: 'Patient Severity (1-10)'),
                keyboardType: TextInputType.number,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (isLogin) {
                  // Handle Sign In
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _controllerEmail.text.trim(),
                      password: _controllerPassword.text.trim(),
                    );
                    Navigator.of(context).pop(); // Go back to the previous page
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

                    // Save additional details (age, role, patient severity) to Firestore or Realtime Database
                    // Example: Save to Firestore
                    // await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
                    //   'name': _controllerName.text.trim(),
                    //   'age': int.parse(_controllerAge.text.trim()),
                    //   'role': isDoctor ? 'Doctor' : 'Care Taker',
                    //   'patientSeverity': isDoctor ? int.parse(_controllerPatientSeverity.text.trim()) : null,
                    // });

                    Navigator.of(context).pop(); // Go back to the previous page
                  } on FirebaseAuthException catch (e) {
                    _showErrorSnackBar(e.message ?? 'An error occurred');
                  }
                }
              },
              child: Text(isLogin ? 'Sign In' : 'Create Account'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isLogin = !isLogin; // Toggle between Sign In and Create Account
                });
              },
              child: Text(isLogin
                  ? 'Create an account'
                  : 'Already have an account? Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}