import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserActivity {
  Set<DateTime> _activeDays = {};
  String? _storageKey;
  bool _isLoaded = false;

  Future<void> init() async {
    await _load(forceReload: true);
  }

  Future<void> syncWithCurrentUser() async {
    await _load(forceReload: true);
  }

  Future<void> logActivity(DateTime date) async {
    await _load();

    final normalizedDate = _normalize(date);
    if (_activeDays.add(normalizedDate)) {
      await _save();
    }
  }

  int calculateStreak() {
    if (!_isLoaded || _activeDays.isEmpty) return 0;

    final normalizedToday = _normalize(DateTime.now());
    final sortedDays = _activeDays.toList()..sort((a, b) => b.compareTo(a));

    final lastActiveDate = sortedDays.first;
    if (normalizedToday.difference(lastActiveDate).inDays > 1) {
      return 0;
    }

    var streak = 1;
    for (var i = 0; i < sortedDays.length - 1; i++) {
      final diff = sortedDays[i].difference(sortedDays[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else if (diff > 1) {
        break;
      }
    }

    return streak;
  }

  DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _buildStorageKey() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    return 'user_activity_${userId ?? 'guest'}';
  }

  Future<void> _load({bool forceReload = false}) async {
    final currentStorageKey = _buildStorageKey();
    if (!forceReload && _isLoaded && _storageKey == currentStorageKey) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final storedValues = prefs.getStringList(currentStorageKey) ?? const [];

    _storageKey = currentStorageKey;
    _activeDays = storedValues.map(DateTime.parse).map(_normalize).toSet();
    _isLoaded = true;
  }

  Future<void> _save() async {
    final storageKey = _storageKey;
    if (storageKey == null) return;

    final prefs = await SharedPreferences.getInstance();
    final serializedDays = _activeDays.toList()
      ..sort((a, b) => a.compareTo(b));

    await prefs.setStringList(
      storageKey,
      serializedDays.map((day) => day.toIso8601String()).toList(),
    );
  }
}

final UserActivity globalUserActivity = UserActivity();
