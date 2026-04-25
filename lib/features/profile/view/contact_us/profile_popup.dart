import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePopup extends StatelessWidget {
  final Map member;

  const ProfilePopup({super.key, required this.member});

  Future<void> openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  Future<void> sendEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Contact from App',
    );
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E2A38),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          /// 🔘 Handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          /// 🖼️ صورة كبيرة
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(member["image"]),
          ),

          const SizedBox(height: 15),

          /// 👤 الاسم
          Text(
            member["name"] ?? "",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 5),

          /// 💼 الوظيفة
          Text(
            member["role"] ?? "",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 15),

          /// 📧 Email
          GestureDetector(
            onTap: () => sendEmail(member["email"]),
            child: Text(
              member["email"] ?? "",
              style: const TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🌐 Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (member["github"] != null)
                icon(FontAwesomeIcons.github, () => openUrl(member["github"])),
              if (member["linkedin"] != null)
                icon(FontAwesomeIcons.linkedin,
                    () => openUrl(member["linkedin"])),
              if (member["portfolio"] != null)
                icon(FontAwesomeIcons.addressCard,
                    () => openUrl(member["portfolio"])),
            ],
          ),

          const Spacer(),

          /// ❌ Close Button
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Widget icon(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: Colors.white10,
          child: FaIcon(icon, color: Colors.white),
        ),
      ),
    );
  }
}
