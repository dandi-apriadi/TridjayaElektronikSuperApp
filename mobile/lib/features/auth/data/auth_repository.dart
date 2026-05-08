import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/user_model.dart';
import '../../../core/network/dio_client.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthRepository(dioClient.dio);
});

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthRepository(this._dio);

  Future<UserModel> login(String username, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'username': username, 'password': password},
    );

    final accessToken = response.data['access_token'] as String;
    final refreshToken = response.data['refresh_token'] as String;

    await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
    await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);

    final user = _parseUserFromToken(accessToken);
    await _storage.write(
      key: AppConstants.userDataKey,
      value: jsonEncode(user.toJson()),
    );
    return user;
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {}
    await _storage.deleteAll();
  }

  Future<UserModel?> getCurrentUser() async {
    final userData = await _storage.read(key: AppConstants.userDataKey);
    final token = await _storage.read(key: AppConstants.accessTokenKey);

    if (userData == null || token == null) return null;
    if (JwtDecoder.isExpired(token)) {
      await _storage.deleteAll();
      return null;
    }
    return UserModel.fromJson(jsonDecode(userData) as Map<String, dynamic>);
  }

  Future<void> requestPasswordReset(String username) async {
    await _dio.post(
      ApiEndpoints.passwordResetRequest,
      data: {'username': username},
    );
  }

  Future<void> verifyPasswordReset({
    required String username,
    required String otp,
    required String newPassword,
  }) async {
    await _dio.post(
      ApiEndpoints.passwordResetVerify,
      data: {
        'username': username,
        'otp': otp,
        'new_password': newPassword,
      },
    );
  }

  UserModel _parseUserFromToken(String token) {
    final claims = JwtDecoder.decode(token);
    final roleStr = claims['role'] as String;
    final role = UserRole.values.firstWhere(
      (r) => r.name == _normalizeRole(roleStr),
      orElse: () => UserRole.admin,
    );
    return UserModel(
      id: claims['sub'] as String,
      username: claims['username'] as String? ?? '',
      role: role,
      branchId: claims['branch_id'] as String?,
      branchName: claims['branch_name'] as String?,
    );
  }

  String _normalizeRole(String raw) {
    switch (raw) {
      case 'Owner':
        return 'owner';
      case 'Kepala_Cabang':
        return 'kepalaCabang';
      case 'Admin':
        return 'admin';
      case 'Sales':
        return 'sales';
      case 'Driver':
        return 'driver';
      default:
        return raw.toLowerCase();
    }
  }
}
