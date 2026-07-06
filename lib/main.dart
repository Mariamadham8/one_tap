import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_tap/firebase_options.dart';
import 'core/models/user_activity_model.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/splash/splash_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await globalUserActivity.init();

  FlutterNativeSplash.remove();

  runApp(const ProviderScope(child: SkillSwapApp()));
}

class SkillSwapApp extends ConsumerWidget {
  const SkillSwapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Study Planner', // updated Title
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}
