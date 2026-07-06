import 'package:flutter/material.dart';
import 'flip_card.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<Map<String, dynamic>> team = [
    {
      "name": "Ahmed Elkhamisy",
      "role": "Flutter Developer",
      "email": "ahmedelkhamisy40@gmail.com",
      "image": "assets/team/1.jpg",
      "github": "https://github.com/A7medElKhamisy",
      "linkedin": "https://www.linkedin.com/in/ahmed-elkhamisy",
      "portfolio": "https://portofolio-maker.vercel.app/a7medel5amisy",
    },
    {
      "name": "Abdelrahman Essam",
      "role": "Flutter Developer",
      "email": "eabdo7425@gmail.com",
      "image": "assets/team/2.jpeg",
      "github": "https://github.com/abdelrahaman293",
      "linkedin": "www.linkedin.com/in/abdelrahman-esam-",
      "portfolio": "https://abdoessam.lovable.app/",
    },
    {
      "name": "Mahmoud Mohsen",
      "role": "Flutter Developer",
      "email": "mahmoud5mohsen5@gmail.com",
      "image": "assets/team/3.jpeg",
      "github": "https://github.com/Mahmoud-Mohsen-1",
      "linkedin": "https://www.linkedin.com/in/mahmoud5mohsen5",
      "portfolio": "",
    },
    {
      "name": "Ahmed khalid",
      "role": "Flutter Developer",
      "email": "Ahmedelzmar111@gmail.com",
      "image": "assets/team/4.jpeg",
      "github": "https://github.com/Ahmedelzmar",
      "linkedin": "https://www.linkedin.com/in/ahmed-khalid-elzmar-2640b7358",
      "portfolio": "",
    },
    {
      "name": "Mahmoud Weal",
      "role": "Flutter Developer",
      "email": "Mahmoodwael888@gmail.com",
      "image": "assets/team/5.jpeg",
      "github": "https://github.com/MahmoudwaelElbadrawy?tab=repositories",
      "linkedin": "https://www.linkedin.com/in/ahmedelsharabasy",
      "portfolio": "",
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: theme.appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 🧠 About Us
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
                width: 2,
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
                  "About Us",
                  style: TextStyle(
                    color: theme.textTheme.bodyLarge!.color,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "We are Digital Egypt Pioneers students in the fourth cohort, learning Flutter. We met through our graduation project and built this app together.",
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium!.color,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// 👇 Team Cards
          ...List.generate(team.length, (index) {
            final member = team[index];

            final animation =
                Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval((index * 0.1), 1.0, curve: Curves.easeOut),
                  ),
                );

            return SlideTransition(
              position: animation,
              child: FadeTransition(
                opacity: _controller,
                child: FlipCard(member: member),
              ),
            );
          }),
        ],
      ),
    );
  }
}
