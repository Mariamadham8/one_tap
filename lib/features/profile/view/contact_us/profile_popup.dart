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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          /// 🔘 Handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: theme.dividerColor,
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.bodyLarge!.color,
            ),
          ),

          const SizedBox(height: 5),

          /// 💼 الوظيفة
          Text(
            member["role"] ?? "",
            style: TextStyle(
              color: theme.textTheme.bodySmall!.color,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 15),

          /// 📧 Email
          GestureDetector(
            onTap: () => sendEmail(member["email"]),
            child: Text(
              member["email"] ?? "",
              style: TextStyle(
                color: colorScheme.primary,
                decoration: TextDecoration.underline,
                decorationColor: colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🌐 Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (member["github"] != null)
                _iconButton(
                  context,
                  FontAwesomeIcons.github,
                  () => openUrl(member["github"]),
                ),
              if (member["linkedin"] != null)
                _iconButton(
                  context,
                  FontAwesomeIcons.linkedin,
                  () => openUrl(member["linkedin"]),
                ),
              if (member["portfolio"] != null)
                _iconButton(
                  context,
                  FontAwesomeIcons.addressCard,
                  () => openUrl(member["portfolio"]),
                ),
            ],
          ),

          const Spacer(),

          /// ❌ Close Button
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            ),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          child: FaIcon(icon, color: colorScheme.primary),
        ),
      ),
    );
  }
}
