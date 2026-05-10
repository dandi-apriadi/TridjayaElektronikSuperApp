import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  final client = DioClient();
  client.initialize();
  return client;
});

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  DioClient._internal();

  late Dio _dio;
  String? _authToken;

  static const List<String> _fallbackUrls = [
    'http://10.0.2.2:8080/api',
    'http://localhost:8080/api',
  ];

  Dio get dio => _dio;

  void initialize() {
    final baseUrl = _getBaseUrl();
    
    // Ambil timeout dari env atau gunakan default
    final connectTimeout = int.tryParse(dotenv.env['CONNECT_TIMEOUT'] ?? '30') ?? 30;
    final receiveTimeout = int.tryParse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30') ?? 30;

    print('🔌 DioClient initialized with baseUrl: $baseUrl');
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: connectTimeout),
      receiveTimeout: Duration(seconds: receiveTimeout),
      sendTimeout: Duration(seconds: connectTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    _dio.interceptors.addAll([
      _AuthInterceptor(const FlutterSecureStorage()),
      _ErrorHandlingInterceptor(),
      _RequestIdInterceptor(),
      LogInterceptor(
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        logPrint: (obj) => debugPrint(obj.toString()),
      ),
    ]);
    
    debugPrint('[DioClient] Initialized with baseUrl: $baseUrl');
    debugPrint('[DioClient] 🔍 VERIFIED BASE URL: ${_dio.options.baseUrl}');
  }
  
  /// Get base URL from environment or use smart fallback
  String _getBaseUrl() {
    // First, try to get from .env
    String? envUrl = dotenv.env['API_BASE_URL'];

    if (envUrl != null && envUrl.isNotEmpty) {
      return envUrl;
    }
    
    // For development, check if we're on Android emulator
    if (Platform.isAndroid) {
      return _fallbackUrls[0]; // 10.0.2.2
    }
    
    // For iOS simulator or other platforms
    return _fallbackUrls[1]; // localhost
  }
  
  /// Test connection and return working URL
  Future<String> testConnection() async {
    for (final url in _fallbackUrls) {
      try {
        final testDio = Dio(BaseOptions(
          baseUrl: url,
          connectTimeout: const Duration(seconds: 5),
        ));
        
        await testDio.get('/health');
        debugPrint('[DioClient] Connection test successful: $url');
        return url;
      } catch (e) {
        debugPrint('[DioClient] Connection test failed for $url: $e');
      }
    }
    
    // If all fail, return the default
    return _fallbackUrls[0];
  }

  /// Ping server untuk test koneksi
  /// Mengembalikan true jika server terhubung, false jika tidak
  Future<bool> pingServer() async {
    try {
      debugPrint('[DioClient] Pinging server...');
      final response = await _dio.get('/ping');
      if (response.statusCode == 200) {
        debugPrint('[DioClient] Ping successful: ${response.data}');
        return true;
      }
      debugPrint('[DioClient] Ping failed with status: ${response.statusCode}');
      return false;
    } on DioException catch (e) {
      debugPrint('[DioClient] Ping error: ${e.type} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('[DioClient] Ping unexpected error: $e');
      return false;
    }
  }

  /// Health check dengan detail lengkap
  /// Mengembalikan status koneksi dan informasi server
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      debugPrint('[DioClient] Checking server health...');
      final response = await _dio.get('/health');
      if (response.statusCode == 200) {
        debugPrint('[DioClient] Health check successful: ${response.data}');
        return {
          'connected': true,
          'status': response.data['status'],
          'database': response.data['database'],
          'timestamp': response.data['timestamp'],
          'version': response.data['version'],
        };
      }
      debugPrint('[DioClient] Health check failed with status: ${response.statusCode}');
      return {
        'connected': false,
        'error': 'Server returned status ${response.statusCode}',
      };
    } on DioException catch (e) {
      debugPrint('[DioClient] Health check error: ${e.type} - ${e.message}');
      String errorMsg = 'Tidak dapat terhubung ke server';
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = 'Koneksi timeout. Server tidak merespons.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMsg = 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        errorMsg = 'Server mengembalikan respon yang tidak valid.';
      }
      return {
        'connected': false,
        'error': errorMsg,
        'detail': e.message,
      };
    } catch (e) {
      debugPrint('[DioClient] Health check unexpected error: $e');
      return {
        'connected': false,
        'error': 'Terjadi kesalahan tidak terduga',
        'detail': e.toString(),
      };
    }
  }
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.read(key: AppConstants.accessTokenKey);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 - Unauthorized
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        final token = await _storage.read(key: AppConstants.accessTokenKey);
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $token';
        try {
          final response = await Dio().fetch(opts);
          return handler.resolve(response);
        } catch (_) {}
      }
      await _storage.deleteAll();
    }
    
    // Log detailed error information
    _logError(err);
    
    handler.next(err);
  }
  
  void _logError(DioException err) {
    final errorType = err.type;
    final message = err.message;
    final url = err.requestOptions.uri.toString();
    
    debugPrint('[DioClient] Error: $errorType');
    debugPrint('[DioClient] URL: $url');
    debugPrint('[DioClient] Message: $message');
    
    switch (errorType) {
      case DioExceptionType.connectionTimeout:
        debugPrint('[DioClient] Connection timeout - Server may be down or unreachable');
        break;
      case DioExceptionType.receiveTimeout:
        debugPrint('[DioClient] Receive timeout - Server is taking too long to respond');
        break;
      case DioExceptionType.badResponse:
        debugPrint('[DioClient] Bad response - Status: ${err.response?.statusCode}');
        break;
      case DioExceptionType.connectionError:
        debugPrint('[DioClient] Connection error - Check network and server status');
        debugPrint('[DioClient] Possible causes:');
        debugPrint('  - Server is not running');
        debugPrint('  - Network is unreachable');
        debugPrint('  - Firewall blocking connection');
        debugPrint('  - Wrong IP address or port');
        break;
      default:
        debugPrint('[DioClient] Unexpected error: $errorType');
    }
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storage.read(key: AppConstants.refreshTokenKey);
      if (refreshToken == null) return false;

      final dio = Dio(BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8080/api',
      ));
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      final newAccessToken = response.data['access_token'] as String;
      final newRefreshToken = response.data['refresh_token'] as String;
      await _storage.write(key: AppConstants.accessTokenKey, value: newAccessToken);
      await _storage.write(key: AppConstants.refreshTokenKey, value: newRefreshToken);
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Enhanced error handling interceptor
class _ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String userFriendlyMessage;
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
        userFriendlyMessage = 'Koneksi timeout. Pastikan server berjalan dan dapat dijangkau.';
        break;
      case DioExceptionType.receiveTimeout:
        userFriendlyMessage = 'Server terlalu lama merespons. Silakan coba lagi.';
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 404) {
          userFriendlyMessage = 'Endpoint tidak ditemukan. Periksa konfigurasi API.';
        } else if (statusCode == 500) {
          userFriendlyMessage = 'Error server internal. Silakan hubungi administrator.';
        } else {
          userFriendlyMessage = 'Error server: $statusCode';
        }
        break;
      case DioExceptionType.cancel:
        userFriendlyMessage = 'Permintaan dibatalkan.';
        break;
      case DioExceptionType.connectionError:
        userFriendlyMessage = 'Tidak dapat terhubung ke server. Periksa:\n'
            '• Apakah server berjalan?\n'
            '• Apakah URL API benar?\n'
            '• Apakah perangkat terhubung ke jaringan?';
        break;
      case DioExceptionType.unknown:
        userFriendlyMessage = 'Error tidak diketahui: ${err.message}';
        break;
      default:
        userFriendlyMessage = 'Terjadi kesalahan koneksi.';
    }
    
    // Attach user-friendly message to error
    err = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: userFriendlyMessage,
    );
    
    handler.next(err);
  }
}

class _RequestIdInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Request-ID'] =
        DateTime.now().millisecondsSinceEpoch.toString();
    handler.next(options);
  }
}
