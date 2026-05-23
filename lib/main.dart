import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:one_tap/features/auth/view/login_page.dart';
import 'package:one_tap/firebase_options.dart';
import 'core/models/user_activity_model.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/onboarding/view/onboarding_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await globalUserActivity.init();

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  FlutterNativeSplash.remove();

  runApp(ProviderScope(child: SkillSwapApp(hasSeenOnboarding: hasSeenOnboarding)));
}

class SkillSwapApp extends ConsumerWidget {
  final bool hasSeenOnboarding;

  const SkillSwapApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Study Planner', // updated Title
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      debugShowCheckedModeBanner: false,
      home: hasSeenOnboarding ? const LoginPage() : const OnboardingPage(), // updated Home Screen
    );
  }
}
