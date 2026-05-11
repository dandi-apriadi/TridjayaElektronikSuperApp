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
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password},
      );

      if (response.data == null) {
        throw Exception('Server mengembalikan respon kosong');
      }

      final accessToken = response.data['access_token'] as String?;
      final refreshToken = response.data['refresh_token'] as String?;

      if (accessToken == null || refreshToken == null) {
        throw Exception('Format respon server tidak valid (missing tokens)');
      }

      await _storage.write(key: AppConstants.accessTokenKey, value: accessToken);
      await _storage.write(key: AppConstants.refreshTokenKey, value: refreshToken);

      final user = _parseUserFromToken(accessToken);
      await _storage.write(
        key: AppConstants.userDataKey,
        value: jsonEncode(user.toJson()),
      );
      return user;
    } on DioException {
      rethrow;
    } catch (e) {
      throw Exception('Gagal memproses data login: $e');
    }
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
    try {
      final claims = JwtDecoder.decode(token);
      final roleStr = claims['role'] as String? ?? 'Admin';
      final role = UserRole.values.firstWhere(
        (r) => r.name == _normalizeRole(roleStr),
        orElse: () => UserRole.admin,
      );
      return UserModel(
        id: claims['sub']?.toString() ?? claims['id']?.toString() ?? '0',
        username: claims['username'] as String? ?? claims['email'] as String? ?? '',
        email: claims['email'] as String? ?? claims['username'] as String? ?? '',
        fullName: claims['full_name'] as String? ?? claims['username'] as String? ?? 'User',
        role: role,
        branchId: claims['branch_id']?.toString(),
        branchName: claims['branch_name'] as String?,
      );
    } catch (e) {
      throw Exception('Gagal mendecode token user: $e');
    }
  }

  String _normalizeRole(String raw) {
    final normalized = raw.trim().toLowerCase();
    switch (normalized) {
      case 'superadmin':
      case 'super_admin':
        return 'superAdmin';
      case 'owner':
        return 'owner';
      case 'kepalacabang':
      case 'kepala_cabang':
        return 'kepalaCabang';
      case 'pic_pelaporan':
      case 'picpelaporan':
        return 'picPelaporan';
      case 'admin':
        return 'admin';
      case 'sales':
        return 'sales';
      case 'driver':
        return 'driver';
      default:
        return normalized;
    }
  }
}
