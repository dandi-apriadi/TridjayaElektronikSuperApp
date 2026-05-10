import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/models/api_response_models.dart';
import '../../core/models/user_model.dart';
import '../../core/network/dio_client.dart';
import '../../core/services/storage_service.dart';

/// ===========================================
/// AUTH REPOSITORY
/// Handles all authentication API calls
/// ===========================================
class AuthRepository {
  final Dio _dio;
  final StorageService _storage;

  AuthRepository(this._dio, this._storage);

  /// Login with email and password
  /// POST /api/auth/login
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      // Save tokens to secure storage
      await _storage.setAccessToken(loginResponse.accessToken);
      await _storage.setRefreshToken(loginResponse.refreshToken);

      return loginResponse;
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Logout user
  /// POST /api/auth/logout
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken != null) {
        await _dio.post(
          ApiEndpoints.logout,
          data: {'refresh_token': refreshToken},
        );
      }
    } finally {
      // Always clear local storage
      await _storage.clearAll();
    }
  }

  /// Refresh access token
  /// POST /api/auth/refresh
  Future<LoginResponse> refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      // Update stored tokens
      await _storage.setAccessToken(loginResponse.accessToken);
      await _storage.setRefreshToken(loginResponse.refreshToken);

      return loginResponse;
    } on DioException catch (e) {
      // If refresh fails, clear everything
      await _storage.clearAll();
      throw _handleAuthError(e);
    }
  }

  /// Request password reset OTP
  /// POST /api/auth/password-reset/request
  Future<void> requestPasswordReset(String email) async {
    try {
      await _dio.post(
        ApiEndpoints.passwordResetRequest,
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Verify OTP and reset password
  /// POST /api/auth/password-reset/verify
  Future<void> verifyPasswordReset(
    String email,
    String otp,
    String newPassword,
  ) async {
    try {
      await _dio.post(
        ApiEndpoints.passwordResetVerify,
        data: {
          'email': email,
          'otp': otp,
          'new_password': newPassword,
        },
      );
    } on DioException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Get current stored user info
  Future<UserInfo?> getCurrentUser() async {
    final token = await _storage.getAccessToken();
    if (token == null) return null;

    // Decode JWT to get user info (simplified)
    // In production, you might want to call a /me endpoint instead
    return null;
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.getAccessToken();
    return token != null;
  }

  /// Handle authentication errors
  Exception _handleAuthError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data != null && data['message'] != null) {
        return Exception(data['message']);
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      default:
        return Exception('An error occurred. Please try again.');
    }
  }
}

/// ===========================================
/// RIVERPOD PROVIDER
/// ===========================================
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthRepository(dio, storage);
});
