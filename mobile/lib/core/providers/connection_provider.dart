import 'dart:async';
import 'package:flutter/foundation.dart';
import '../network/dio_client.dart';

/// Provider untuk memantau status koneksi ke server
class ConnectionProvider extends ChangeNotifier {
  bool _isConnected = false;
  bool _isChecking = false;
  String _lastError = '';
  Map<String, dynamic> _serverInfo = {};
  Timer? _pingTimer;

  // Getters
  bool get isConnected => _isConnected;
  bool get isChecking => _isChecking;
  String get lastError => _lastError;
  Map<String, dynamic> get serverInfo => _serverInfo;

  /// Inisialisasi dan mulai monitoring koneksi
  void startMonitoring({Duration interval = const Duration(seconds: 30)}) {
    // Ping pertama kali
    checkConnection();
    
    // Setup timer untuk ping berkala
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(interval, (_) => checkConnection());
  }

  /// Hentikan monitoring
  void stopMonitoring() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  /// Cek koneksi ke server
  Future<bool> checkConnection() async {
    if (_isChecking) return _isConnected;
    
    _isChecking = true;
    notifyListeners();

    try {
      final dioClient = DioClient();
      
      // Coba ping server
      final isReachable = await dioClient.pingServer();
      
      if (isReachable) {
        // Jika ping berhasil, ambil health check detail
        final health = await dioClient.healthCheck();
        
        _isConnected = health['connected'] ?? false;
        _serverInfo = health;
        _lastError = health['error'] ?? '';
        
        if (_isConnected) {
          if (kDebugMode) {
            print('✅ Server connected: ${health['status']}');
          }
        } else {
          if (kDebugMode) {
            print('⚠️ Server unreachable: $_lastError');
          }
        }
      } else {
        _isConnected = false;
        _lastError = 'Server tidak merespons';
        _serverInfo = {};
        
        if (kDebugMode) {
          print('❌ Server ping failed');
        }
      }
    } catch (e) {
      _isConnected = false;
      _lastError = 'Error: $e';
      _serverInfo = {};
      
      if (kDebugMode) {
        print('❌ Connection check error: $e');
      }
    } finally {
      _isChecking = false;
      notifyListeners();
    }

    return _isConnected;
  }

  /// Cek koneksi sekali (tanpa menyimpan state)
  static Future<bool> quickCheck() async {
    return await DioClient().pingServer();
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
