import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/dio_client.dart';

/// State untuk connection status
class ConnectionState {
  final bool isConnected;
  final bool isChecking;
  final String lastError;
  final Map<String, dynamic> serverInfo;

  const ConnectionState({
    this.isConnected = false,
    this.isChecking = false,
    this.lastError = '',
    this.serverInfo = const {},
  });

  ConnectionState copyWith({
    bool? isConnected,
    bool? isChecking,
    String? lastError,
    Map<String, dynamic>? serverInfo,
  }) {
    return ConnectionState(
      isConnected: isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
      lastError: lastError ?? this.lastError,
      serverInfo: serverInfo ?? this.serverInfo,
    );
  }
}

/// Notifier untuk connection status
class ConnectionNotifier extends StateNotifier<ConnectionState> {
  Timer? _pingTimer;

  ConnectionNotifier() : super(const ConnectionState());

  /// Mulai monitoring koneksi
  void startMonitoring({Duration interval = const Duration(seconds: 30)}) {
    checkConnection();
    
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(interval, (_) => checkConnection());
  }

  /// Hentikan monitoring
  void stopMonitoring() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  /// Cek koneksi sekali
  Future<bool> checkConnection() async {
    if (state.isChecking) return state.isConnected;
    
    state = state.copyWith(isChecking: true);

    try {
      final dioClient = DioClient();
      final isReachable = await dioClient.pingServer();
      
      if (isReachable) {
        final health = await dioClient.healthCheck();
        
        state = state.copyWith(
          isConnected: health['connected'] ?? false,
          isChecking: false,
          serverInfo: health,
          lastError: health['error'] ?? '',
        );
        
        if (kDebugMode && state.isConnected) {
          print('✅ Server connected: ${health['status']}');
        }
      } else {
        state = state.copyWith(
          isConnected: false,
          isChecking: false,
          lastError: 'Server tidak merespons',
          serverInfo: {},
        );
      }
    } catch (e) {
      state = state.copyWith(
        isConnected: false,
        isChecking: false,
        lastError: 'Error: $e',
        serverInfo: {},
      );
    }

    return state.isConnected;
  }

  /// Quick check tanpa mengubah state
  static Future<bool> quickCheck() async {
    return await DioClient().pingServer();
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}

/// Provider untuk connection status
final connectionProvider = StateNotifierProvider<ConnectionNotifier, ConnectionState>(
  (ref) => ConnectionNotifier(),
);
