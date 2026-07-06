import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one_tap/features/auth/view/verify_email_page.dart';
import 'package:one_tap/features/home/home_page.dart';
import 'package:one_tap/features/onboarding/view/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Wait for 1 second to show splash feedback before routing.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final currentUser = FirebaseAuth.instance.currentUser;

    // No active session -> keep existing onboarding/login flow.
    if (currentUser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
      return;
    }

    try {
      await currentUser.reload();
    } catch (_) {
      // If reload fails, fallback to the best known local auth state.
    }

    if (!mounted) return;

    final refreshedUser = FirebaseAuth.instance.currentUser;
    final isEmailVerified = refreshedUser?.emailVerified ?? false;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            isEmailVerified ? const HomePage() : const VerifyEmailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.blueAccent, // Background color for the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Splash.png',
              width: 260,
              height: 260,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 26),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
