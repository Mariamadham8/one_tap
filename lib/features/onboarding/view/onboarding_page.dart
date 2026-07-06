import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:one_tap/features/auth/view/login_page.dart';
import 'package:one_tap/features/auth/view/verify_email_page.dart';
import 'package:one_tap/features/home/home_page.dart';

class OnboardingPageModel {
  final String lottiePath;
  final String title;
  final String description;

  OnboardingPageModel({
    required this.lottiePath,
    required this.title,
    required this.description,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      lottiePath: 'assets/lottie/Learn.json',
      title: "Organize Your Study",
      description: "Track your subjects and manage your study easily.",
    ),
    OnboardingPageModel(
      lottiePath: 'assets/lottie/planning.json',
      title: "Plan Your Tasks",
      description: "Break your study into small tasks and stay productive.",
    ),
    OnboardingPageModel(
      lottiePath: 'assets/lottie/Relax.json',
      title: "Stay Focused",
      description:
          "Use Pomodoro sessions to improve focus and build a calm routine.",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _goToLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    if (!user.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              colorScheme.primary.withValues(alpha: 0.14),
              theme.scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.7],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPageContent(context, _pages[index]);
                  },
                ),
              ),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  'S',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Study Mate',
                style: TextStyle(
                  color:
                      theme.textTheme.bodyLarge?.color ?? colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          AnimatedOpacity(
            opacity: _currentPage == _pages.length - 1 ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: TextButton(
              onPressed: _currentPage == _pages.length - 1 ? null : _goToLogin,
              child: Text(
                'Skip',
                style: TextStyle(
                  color:
                      theme.textTheme.bodySmall?.color ??
                      colorScheme.onSurfaceVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent(BuildContext context, OnboardingPageModel page) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompactHeight = constraints.maxHeight < 650;
        final cardSize = isCompactHeight ? 240.0 : 300.0;
        final topSpacing = isCompactHeight ? 28.0 : 60.0;
        final titleSize = isCompactHeight ? 24.0 : 28.0;
        final descriptionSize = isCompactHeight ? 14.0 : 16.0;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCenterCard(context, page.lottiePath, cardSize),
                  SizedBox(height: topSpacing),
                  Text(
                    page.title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w800,
                      color:
                          theme.textTheme.bodyLarge?.color ??
                          colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      page.description,
                      style: TextStyle(
                        fontSize: descriptionSize,
                        height: 1.5,
                        color:
                            theme.textTheme.bodySmall?.color ??
                            colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCenterCard(
    BuildContext context,
    String lottiePath,
    double size,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        // Background top-right circle
        Positioned(
          top: -15,
          right: -10,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Background bottom-left circle
        Positioned(
          bottom: -20,
          left: -15,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Main Card
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(size * 0.13),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.08),
                blurRadius: 40,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(size * 0.13),
              child: Lottie.asset(
                lottiePath,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        // Top right badge
        Positioned(
          top: 30,
          right: -25,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '+12 today',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color:
                        theme.textTheme.bodyLarge?.color ??
                        colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Bottom left badge
        Positioned(
          bottom: 30,
          left: -25,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🔥', style: TextStyle(fontSize: 14)),
                SizedBox(width: 6),
                Text(
                  'Streak 12',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPageIndicator(),
          const SizedBox(height: 20),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (index) {
        bool isActive = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8,
          width: isActive ? 32 : 8,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : theme.dividerColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildButtons() {
    final colorScheme = Theme.of(context).colorScheme;

    if (_currentPage == 0) {
      // Single button for first page
      return ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          minimumSize: const Size(double.infinity, 56),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Next",
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: colorScheme.onPrimary, size: 20),
          ],
        ),
      );
    }

    return Row(
      children: [
        TextButton(
          onPressed: _prevPage,
          style: TextButton.styleFrom(
            backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            minimumSize: const Size(100, 56),
          ),
          child: Text(
            "Back",
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _currentPage == _pages.length - 1
              ? GestureDetector(
                  onTap: _goToLogin,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: colorScheme.primary,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Get Started",
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            color: colorScheme.onPrimary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Next",
                        style: TextStyle(
                          color: colorScheme.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: colorScheme.onPrimary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
