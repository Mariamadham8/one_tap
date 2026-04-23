class UserActivity {
  // Set to store unique days the user was active
  final Set<DateTime> activeDays = {};

  // Log activity and normalize the date to ignore time
  void logActivity(DateTime date) {
    activeDays.add(DateTime(date.year, date.month, date.day));
  }

  // Calculate the current day streak
  int calculateStreak() {
    if (activeDays.isEmpty) return 0;

    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    final List<DateTime> sortedDays = activeDays.toList()
      ..sort((a, b) => b.compareTo(a));

    DateTime lastActiveDate = sortedDays.first;

    // If the last active day is older than yesterday, the streak is broken
    if (normalizedToday.difference(lastActiveDate).inDays > 1) {
      return 0;
    }

    int streak = 1;
    for (int i = 0; i < sortedDays.length - 1; i++) {
      final diff = sortedDays[i].difference(sortedDays[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else if (diff > 1) {
        break;
      }
    }
    return streak;
  }
}

// Global instance to simulate database/activity logs for now
final UserActivity globalUserActivity = UserActivity()
  // Adding some dummy data for testing (e.g., active for the last 5 days)
  ..logActivity(DateTime.now().subtract(const Duration(days: 4)))
  ..logActivity(DateTime.now().subtract(const Duration(days: 3)))
  ..logActivity(DateTime.now().subtract(const Duration(days: 2)))
  ..logActivity(DateTime.now().subtract(const Duration(days: 1)))
  ..logActivity(DateTime.now());
