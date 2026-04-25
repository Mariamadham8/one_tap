import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/firebase_auth_services.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
