import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _usernameController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  Timer? _countdownTimer;
  int _secondsRemaining = AppConstants.otpExpiryMinutes * 60;

  @override
  void dispose() {
    _usernameController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _secondsRemaining = AppConstants.otpExpiryMinutes * 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  String get _countdownText {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final resetState = ref.watch(passwordResetProvider);

    ref.listen(passwordResetProvider, (prev, next) {
      if (next.otpSent && !(prev?.otpSent ?? false)) {
        _startCountdown();
      }
      if (next.isCompleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password berhasil diubah. Silakan login.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        ref.read(passwordResetProvider.notifier).reset();
        context.go('/login');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: resetState.otpSent
              ? _buildOtpAndNewPasswordStep(resetState)
              : _buildUsernameStep(resetState),
        ),
      ),
    );
  }

  Widget _buildUsernameStep(PasswordResetState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.lock_reset_rounded, size: 48, color: AppColors.primary),
        const SizedBox(height: 16),
        Text('Lupa Password?', style: AppTextStyles.heading2),
        const SizedBox(height: 8),
        Text(
          'Masukkan username Anda. Kami akan mengirim kode OTP ke nomor WhatsApp yang terdaftar.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          _buildErrorBanner(state.errorMessage!),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: state.isLoading
              ? null
              : () {
                  if (_usernameController.text.trim().isEmpty) return;
                  ref
                      .read(passwordResetProvider.notifier)
                      .requestOtp(_usernameController.text.trim());
                },
          child: state.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: Colors.white),
                )
              : const Text('Kirim Kode OTP'),
        ),
      ],
    );
  }

  Widget _buildOtpAndNewPasswordStep(PasswordResetState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.message_outlined, size: 48, color: AppColors.success),
        const SizedBox(height: 16),
        Text('Masukkan Kode OTP', style: AppTextStyles.heading2),
        const SizedBox(height: 8),
        Text(
          'Kode OTP 6 digit telah dikirim ke WhatsApp Anda.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.timer_outlined, size: 16, color: AppColors.warning),
            const SizedBox(width: 4),
            Text(
              _secondsRemaining > 0
                  ? 'Kode kedaluwarsa dalam $_countdownText'
                  : 'Kode telah kedaluwarsa. Mulai ulang.',
              style: AppTextStyles.caption.copyWith(
                color: _secondsRemaining > 0
                    ? AppColors.warning
                    : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(
            labelText: 'Kode OTP',
            hintText: '6 digit kode',
            prefixIcon: Icon(Icons.pin_outlined),
            counterText: '',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          decoration: InputDecoration(
            labelText: 'Password Baru',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(_obscureNewPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () =>
                  setState(() => _obscureNewPassword = !_obscureNewPassword),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: 'Konfirmasi Password Baru',
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined),
              onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
        ),
        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          _buildErrorBanner(state.errorMessage!),
        ],
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: state.isLoading || _secondsRemaining == 0
              ? null
              : () {
                  if (_otpController.text.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kode OTP harus 6 digit')),
                    );
                    return;
                  }
                  if (_newPasswordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Konfirmasi password tidak cocok')),
                    );
                    return;
                  }
                  ref.read(passwordResetProvider.notifier).verifyOtp(
                        otp: _otpController.text,
                        newPassword: _newPasswordController.text,
                      );
                },
          child: state.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: Colors.white),
                )
              : const Text('Ubah Password'),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () {
              ref.read(passwordResetProvider.notifier).reset();
            },
            child: const Text('Kirim Ulang OTP'),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: AppTextStyles.caption.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
