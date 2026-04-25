import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:one_tap/features/auth/view/login_page.dart';
import '../../../../core/models/task_model.dart'; // import globalTasks
import '../../../../core/models/user_activity_model.dart'; // import globalUserActivity

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int get completedTasksCount {
    return globalTasks.where((task) => task.isDone).length;
  }

  String get hoursStudied {
    final int totalMinutes = globalTasks
        .where((task) => task.isDone)
        .fold(0, (sum, task) => sum + task.durationMinutes);
    if (totalMinutes < 60) {
      return '${totalMinutes}m';
    }
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  // TODO: Replace with actual streak calculation logic connecting to Firebase/Local Storage later.
  int get dayStreak {
    return globalUserActivity.calculateStreak();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D2F44),
            ),
          ),
          const SizedBox(height: 24),

          // User Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4C9EEB).withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF67ADF6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'M',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Mariem',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'mariem@studymate.app',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  Icons.local_fire_department_outlined,
                  '$dayStreak',
                  'DAY STREAK',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.schedule_outlined,
                  hoursStudied,
                  'STUDIED',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  Icons.check_circle_outline,
                  '$completedTasksCount',
                  'TASKS',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Settings Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4C9EEB).withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  showChevron: true,
                  onTap: () {
                    // TODO: Navigate to Edit Profile
                  },
                ),
                Divider(
                  height: 1,
                  color: Colors.grey.withOpacity(0.1),
                  indent: 56,
                  endIndent: 16,
                ),
                _buildSettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  trailing: Switch(
                    value: false, // TODO: Replace with actual theme state
                    onChanged: (value) {
                      // TODO: Toggle Dark Mode
                    },
                    activeColor: const Color(0xFF60A5FA),
                    activeTrackColor: const Color(0xFFEBF4FC),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFFE2E8F0),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout Button
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.logout, color: Color(0xFFEF4444), size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4C9EEB).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF67ADF6), size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Color(0xFF94A3B8),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    bool showChevron = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFEBF4FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF67ADF6), size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
            if (trailing != null) trailing,
            if (showChevron)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF94A3B8),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
