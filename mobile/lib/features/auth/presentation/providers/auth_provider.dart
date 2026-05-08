import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/user_model.dart';
import '../../data/auth_repository.dart';

final currentUserProvider = StateProvider<UserModel?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState.valueOrNull;
});

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    return repo.getCurrentUser();
  }

  Future<void> login(String username, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(username, password);
      ref.read(currentUserProvider.notifier).state = user;
      return user;
    });
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    ref.read(currentUserProvider.notifier).state = null;
    state = const AsyncData(null);
  }
}

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, UserModel?>(
  AuthNotifier.new,
);

class PasswordResetNotifier extends Notifier<PasswordResetState> {
  @override
  PasswordResetState build() => const PasswordResetState();

  Future<void> requestOtp(String username) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.requestPasswordReset(username);
      state = state.copyWith(
        isLoading: false,
        otpSent: true,
        username: username,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseError(e),
      );
    }
  }

  Future<void> verifyOtp({
    required String otp,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.verifyPasswordReset(
        username: state.username!,
        otp: otp,
        newPassword: newPassword,
      );
      state = state.copyWith(isLoading: false, isCompleted: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseError(e),
      );
    }
  }

  void reset() => state = const PasswordResetState();

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('429')) return 'Terlalu banyak percobaan. Coba lagi 1 jam lagi.';
    if (msg.contains('400')) return 'OTP tidak valid atau sudah kadaluarsa.';
    if (msg.contains('404')) return 'Username tidak ditemukan.';
    return 'Terjadi kesalahan. Silakan coba lagi.';
  }
}

final passwordResetProvider =
    NotifierProvider<PasswordResetNotifier, PasswordResetState>(
  PasswordResetNotifier.new,
);

class PasswordResetState {
  final bool isLoading;
  final bool otpSent;
  final bool isCompleted;
  final String? username;
  final String? errorMessage;

  const PasswordResetState({
    this.isLoading = false,
    this.otpSent = false,
    this.isCompleted = false,
    this.username,
    this.errorMessage,
  });

  PasswordResetState copyWith({
    bool? isLoading,
    bool? otpSent,
    bool? isCompleted,
    String? username,
    String? errorMessage,
  }) {
    return PasswordResetState(
      isLoading: isLoading ?? this.isLoading,
      otpSent: otpSent ?? this.otpSent,
      isCompleted: isCompleted ?? this.isCompleted,
      username: username ?? this.username,
      errorMessage: errorMessage,
    );
  }
}
