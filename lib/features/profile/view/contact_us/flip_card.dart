import 'package:flutter/material.dart';
import 'profile_popup.dart';

class FlipCard extends StatelessWidget {
  final Map member;

  const FlipCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => ProfilePopup(member: member),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            /// 🖼️ صورة
            CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage(member["image"]),
            ),

            const SizedBox(width: 12),

            /// 👤 الاسم
            Expanded(
              child: Text(
                member["name"] ?? "",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// 👉 السهم
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.black87,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
