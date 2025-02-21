import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aphasia_bot/services/auth_service.dart';
import 'auth_modal.dart';
import 'homedesign.dart';
import 'package:aphasia_bot/services/translation_service.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<Auth>(context);
    final translationService = Provider.of<TranslationService>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        actions: [
          // Always show the translation button, even when not signed in
          PopupMenuButton<String>(
            icon: const Icon(Icons.translate),
            onSelected: (String languageCode) {
              setState(() {
                translationService.changeLanguage(languageCode);
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'ta', child: Text('Tamil')),
              PopupMenuItem(value: 'hi', child: Text('Hindi')),
              PopupMenuItem(value: 'te', child: Text('Telugu')),
              PopupMenuItem(value: 'ml', child: Text('Malayalam')),
            ],
          ),
        ],
        leading: Builder(
          builder: (context) => authService.isSignedIn
              ? IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          )
              : const SizedBox.shrink(), // Placeholder when not signed in
        ),
      ),
      drawer: authService.isSignedIn
          ? Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                authService.currentUser?.displayName ?? 'Name',
              ),
              accountEmail: Text(
                authService.currentUser?.email ?? '',
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: authService.currentUser?.photoURL != null
                    ? NetworkImage(authService.currentUser!.photoURL!)
                    : null,
                child: authService.currentUser?.photoURL == null
                    ? const Icon(Icons.person)
                    : null,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await authService.signOut();
                setState(() {}); // Force a rebuild after logout
                Navigator.pop(context);
              },
            ),
          ],
        ),
      )
          : null, // Show drawer only when signed in
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 150,
            right: 20,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.black26,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/homepage/medi2.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 220,
            child: FadeTransition(
              opacity: _animation,
              child: FutureBuilder<String>(
                future: translationService.getTranslation("Aphasia Therapy"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading indicator while waiting
                  }
                  if (snapshot.hasError) {
                    return Text(
                        "Error: ${snapshot.error}"); // Handle error case
                  }
                  return Text(
                    snapshot.data ??
                        "Aphasia Therapy", // Display translated text
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        fontSize: 45,
                        color: Color(0xFF263238),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 280,
            left: 220,
            child: FadeTransition(
              opacity: _animation,
              child: FutureBuilder<String>(
                future: translationService.getTranslation(
                    "Welcome back! Let's keep the momentum going."),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading indicator while waiting
                  }
                  if (snapshot.hasError) {
                    return Text(
                        "Error: ${snapshot.error}"); // Handle error case
                  }
                  return Text(
                    snapshot.data ??
                        "Welcome back! Let's keep the momentum going.",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 61, 79, 88),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 350,
            left: MediaQuery.of(context).size.width / 2 - 190,
            child: FloatingActionButton.extended(
              onPressed: () {
                if (authService.isSignedIn) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homedesign()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }
              },
              backgroundColor: const Color(0xFFFFEB3B),
              label: FutureBuilder<String>(
                future: translationService.getTranslation(authService.isSignedIn
                    ? "Start Your Session"
                    : "Sign In to Start"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading indicator while waiting
                  }
                  if (snapshot.hasError) {
                    return Text(
                        "Error: ${snapshot.error}"); // Handle error case
                  }
                  return Text(
                    snapshot.data ??
                        (authService.isSignedIn
                            ? "Start Your Session"
                            : "Sign In to Start"), // Display translated text
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF263238),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}