import 'package:flutter/material.dart';
import 'contact_us/contact_us_view.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  double scrollProgress = 0;

  @override
  void initState() {
    super.initState();

    /// Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    /// Scroll Indicator
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double current = _scrollController.position.pixels;

      setState(() {
        scrollProgress = (current / maxScroll).clamp(0.0, 1.0);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<Map<String, String>> sections = [
    {
      "title": "Introduction",
      "content":
          "One Tap helps students organize subjects, tasks, and daily study progress.",
    },
    {
      "title": "Data Collection",
      "content":
          "We collect basic data like your name, email, subjects, tasks, and activity records.",
    },
    {
      "title": "How We Use Your Data",
      "content":
          "We use your data to sign you in, save your progress, and improve the app. We do not share it without your permission.",
    },
    {
      "title": "Data Protection",
      "content":
          "Your data is protected with secure Firebase services and HTTPS.",
    },
    {
      "title": "Third-Party Services",
      "content": "We use Firebase for login, storage, and sync.",
    },
    {
      "title": "Your Rights and Privacy Controls",
      "content":
          "You can update your profile or request account deletion from the app settings.",
    },
    {
      "title": "Policy Updates",
      "content":
          "We may update this policy and notify you about important changes.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          /// 📜 Scroll Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              /// 📌 Sticky Header
              SliverAppBar(
                pinned: true,
                backgroundColor: theme.appBarTheme.backgroundColor,
                foregroundColor: theme.appBarTheme.foregroundColor,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.appBarTheme.foregroundColor,
                  ),
                ),
              ),

              /// 📄 Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ...List.generate(sections.length, (index) {
                        final section = sections[index];

                        final animation =
                            Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: _controller,
                                curve: Interval(
                                  (index * 0.1),
                                  1.0,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            );

                        return SlideTransition(
                          position: animation,
                          child: FadeTransition(
                            opacity: _controller,
                            child: _section(
                              title: section["title"]!,
                              content: section["content"]!,
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      /// 💬 CTA Text
                      Text(
                        "Questions about privacy? Contact our team.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.textTheme.bodySmall!.color,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🔘 Button
                      SizedBox(
                        height: 55,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ContactUsView(),
                              ),
                            );
                          },
                          child: const Text(
                            "Contact Developers",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// 📊 Scroll Indicator (Top Bar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: scrollProgress,
              backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
              color: colorScheme.primary,
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }

  /// 💎 Section Widget
  Widget _section({required String title, required String content}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: theme.textTheme.bodyLarge!.color,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
