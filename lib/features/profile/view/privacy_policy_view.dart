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
          "One Tap is an educational platform designed to help students organize their studies, manage academic subjects, and track their daily learning progress. The app enables users to add subjects, create daily tasks, and monitor their academic achievements efficiently."
    },
    {
      "title": "Data Collection",
      "content":
          "We collect limited personal data including: email address, full name, the subjects you add, the tasks and to-do items you create, and your daily activity records. This information is collected solely to enhance your experience and provide personalized features tailored to your academic needs."
    },
    {
      "title": "How We Use Your Data",
      "content":
          "Your personal and academic data is used to: verify your identity in the app, save and organize your subjects and tasks, track your daily achievements and calculate your study streak, improve the user experience, and develop new features. We do not share your data with third parties without your explicit consent."
    },
    {
      "title": "Data Protection",
      "content":
          "We protect your data using strong encryption technologies and secure Firebase services. Your password is encrypted and inaccessible to our team. All communications between the app and our servers are secured using HTTPS protocol to prevent unauthorized access."
    },
    {
      "title": "Third-Party Services",
      "content":
          "One Tap relies on Firebase by Google for secure data storage, authentication, and real-time synchronization. Firebase provides industry-leading security standards and complies with global data protection regulations. You can review Google's privacy policy on their official website for more details."
    },
    {
      "title": "Your Rights and Privacy Controls",
      "content":
          "You have the right to request deletion of your account and all associated data at any time through the app settings. You can also update your profile information whenever you wish. We reserve the right to delete inactive data after 6 months in accordance with global privacy policies."
    },
    {
      "title": "Policy Updates",
      "content":
          "We may update this privacy policy periodically to reflect changes in data practices or legal requirements. We will notify you of any significant changes through an in-app notification. Your continued use of the app after updates constitutes your acceptance of the updated policy."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 💙 Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4C9EEB), Color(0xFF67ADF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          /// 📜 Scroll Content
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              /// 📌 Sticky Header
              const SliverAppBar(
                pinned: true,
                backgroundColor: Color(0xFF4C9EEB),
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "Privacy Policy",
                  style: TextStyle(fontWeight: FontWeight.bold),
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

                        final animation = Tween<Offset>(
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
                      const Text(
                        "Have questions about your privacy or account data? Contact us directly through our development team.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1E293B),
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
                            backgroundColor: const Color(0xFF4C9EEB),
                            foregroundColor: Colors.white,
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
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
              backgroundColor: Colors.white24,
              color: Colors.black87,
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }

  /// 💎 Section Widget
  Widget _section({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF75B9F0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4C9EEB),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
