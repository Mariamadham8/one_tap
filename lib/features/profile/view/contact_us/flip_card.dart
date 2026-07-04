import 'package:flutter/material.dart';
import 'profile_popup.dart';

class FlipCard extends StatelessWidget {
  final Map member;

  const FlipCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.15),
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
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
                style: TextStyle(
                  color: theme.textTheme.bodyLarge!.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// 👉 السهم
            Icon(
              Icons.arrow_forward_ios,
              color: theme.textTheme.bodyMedium!.color,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
