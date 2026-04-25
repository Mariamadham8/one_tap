import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_tap/core/widgets/custom_snackbar.dart';
import 'package:one_tap/features/auth/providers/auth_provider.dart';
import '../../home/home_page.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  bool _isCheckingVerification = false;
  bool _isResending = false;
  Future<void> _checkVerification() async {
    setState(() => _isCheckingVerification = true);
    try {
      await FirebaseAuth.instance.currentUser?.reload();

      if (!mounted) return;
      setState(() => _isCheckingVerification = false);

      final isVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;

      if (isVerified) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      } else {
        showSnackBar(
          context,
          'Email not verified yet. Please check your inbox.',
          isError: true,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCheckingVerification = false);
      showSnackBar(
        context,
        'Something went wrong. Please try again.',
        isError: true,
      );
    }
  }

  Future<void> _resendEmail() async {
    setState(() => _isResending = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendVerifyEmail();

      if (!mounted) return;
      setState(() => _isResending = false);
      showSnackBar(context, 'Verification email sent! Check your inbox.');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _isResending = false);
      final authService = ref.read(authServiceProvider);
      showSnackBar(context, authService.getErrorMessage(e.code), isError: true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isResending = false);
      showSnackBar(
        context,
        'Something went wrong. Please try again.',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBF4FC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF1D2F44),
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const SizedBox(height: 60),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF67ADF6).withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_unread_outlined,
                  size: 50,
                  color: Color(0xFF67ADF6),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Verify your email',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D2F44),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We have sent a verification email to your address. Please check your inbox and click the link to verify your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCheckingVerification
                      ? null
                      : _checkVerification,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF67ADF6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isCheckingVerification
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'I have verified',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isResending ? null : _resendEmail,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: const Color(0xFF67ADF6),
                    side: const BorderSide(color: Color(0xFF67ADF6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isResending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Color(0xFF67ADF6),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Resend Email',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
