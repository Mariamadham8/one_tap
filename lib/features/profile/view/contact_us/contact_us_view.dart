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
      "name": "Osama Elkayyal",
      "role": "Flutter Developer",
      "email": "Osama.Elkayyal@gmail.com",
      "image": "assets/team/1.jpeg",
      "github": "https://github.com/Osama7amed04",
      "linkedin": "https://www.linkedin.com/in/os-7k",
      "portfolio": "https://os-7-k.web.app",
    },
    {
      "name": "Ahmed Elkhamisy",
      "role": "Flutter Developer",
      "email": "ahmedelkhamisy40@gmail.com",
      "image": "assets/team/2.jpg",
      "github": "https://github.com/A7medElKhamisy",
      "linkedin": "https://www.linkedin.com/in/ahmed-elkhamisy",
      "portfolio": "",
    },
    {
      "name": "Abdelrahman Eltahrany",
      "role": "Flutter Developer",
      "email": "abdsalama2020@gmail.com",
      "image": "assets/team/3.jpeg",
      "github": "https://github.com/abdsalama",
      "linkedin": "https://www.linkedin.com/in/abd-elrahman-el-tahrany",
      "portfolio": "",
    },
    {
      "name": "Fedaa Mohammed",
      "role": "Embedded Engineer",
      "email": "kanishey@gmail.com",
      "image": "assets/team/4.jpeg",
      "github": "https://github.com/fedokanishey",
      "linkedin": "https://www.linkedin.com/in/fedaamohammed",
      "portfolio": "",
    },
    {
      "name": "Ahmed Elsharabasy",
      "role": "Backend Nodejs Developer",
      "email": "ahmedelsharabasy2004@gmail.com",
      "image": "assets/team/5.HEIC",
      "github": "https://github.com/Ahmed-Sharabasy",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4C9EEB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4C9EEB), Color(0xFF67ADF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        /// ✅ كله بقى Scroll واحد
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// 🧠 About Us
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF75B9F0), width: 2),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Us",
                    style: TextStyle(
                      color: Color(0xFF1E293B),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "We are students of the Faculty of Computers and Artificial Intelligence at Damietta University, majoring in Computer Science. This project was developed as part of our graduation requirements, where we applied the knowledge and skills we acquired throughout our studies in a practical form. It was carried out under academic supervision, with a focus on delivering an effective solution that reflects our academic and practical level.",
                    style: TextStyle(
                      color: Color(0xFF1E293B),
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

              final animation = Tween<Offset>(
                begin: const Offset(1, 0),
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
                  child: FlipCard(member: member),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
