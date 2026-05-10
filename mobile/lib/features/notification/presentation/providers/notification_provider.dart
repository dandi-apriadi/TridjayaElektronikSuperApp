import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/notification_model.dart';

/// ============================================================
/// 🔔 NOTIFICATION PROVIDERS
/// ============================================================

// Notification list with filters
final notificationsProvider = FutureProvider.family<
    NotificationListResponse,
    Map<String, dynamic>?
>(
  (ref, filters) async {
    final dio = ref.watch(dioClientProvider).dio;
    
    try {
      final params = <String, dynamic>{
        'limit': filters?['limit'] ?? 50,
        'offset': filters?['offset'] ?? 0,
      };
      
      if (filters?['unread_only'] == true) {
        params['unread_only'] = 'true';
      }
      
      if (filters?['type'] != null) {
        params['type'] = filters!['type'];
      }
      
      final response = await dio.get(
        '/notifications',
        queryParameters: params,
      );
      
      return NotificationListResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _extractErrorMessage(e);
    }
  },
);

// Unread count
final unreadCountProvider = FutureProvider<int>(
  (ref) async {
    final dio = ref.watch(dioClientProvider).dio;
    
    try {
      final response = await dio.get('/notifications/unread-count');
      return response.data['unread_count'] as int? ?? 0;
    } on DioException catch (e) {
      throw _extractErrorMessage(e);
    }
  },
);

// All notifications
final allNotificationsProvider = FutureProvider<List<Notification>>(
  (ref) async {
    final response = ref.watch(notificationsProvider(null));
    return response.whenData((data) => data.notifications).value ?? [];
  },
);

// Unread notifications only
final unreadNotificationsProvider = FutureProvider<List<Notification>>(
  (ref) async {
    final response = ref.watch(notificationsProvider({'unread_only': true}));
    return response.whenData((data) => data.notifications).value ?? [];
  },
);

// Notification preferences
final notificationPreferencesProvider = FutureProvider<NotificationPreferences>(
  (ref) async {
    final dio = ref.watch(dioClientProvider).dio;
    
    try {
      final response = await dio.get('/notifications/preferences');
      return NotificationPreferences.fromJson(response.data);
    } on DioException catch (e) {
      throw _extractErrorMessage(e);
    }
  },
);

// Notifier for notification actions
class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final Dio _dio;
  final Ref _ref;

  NotificationNotifier(this._dio, this._ref) : super(const AsyncValue.data(null));

  Future<void> markAsRead(String notificationId) async {
    state = const AsyncValue.loading();
    try {
      await _dio.put('/notifications/$notificationId/read');
      // Refresh providers
      _ref.refresh(notificationsProvider(null));
      _ref.refresh(unreadCountProvider);
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(_extractErrorMessage(e), StackTrace.current);
    }
  }

  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    try {
      await _dio.put('/notifications/read-all');
      // Refresh providers
      _ref.refresh(notificationsProvider(null));
      _ref.refresh(unreadCountProvider);
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(_extractErrorMessage(e), StackTrace.current);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    state = const AsyncValue.loading();
    try {
      await _dio.delete('/notifications/$notificationId');
      // Refresh providers
      _ref.refresh(notificationsProvider(null));
      _ref.refresh(unreadCountProvider);
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(_extractErrorMessage(e), StackTrace.current);
    }
  }

  Future<void> deleteAllNotifications() async {
    state = const AsyncValue.loading();
    try {
      await _dio.delete('/notifications');
      // Refresh providers
      _ref.refresh(notificationsProvider(null));
      _ref.refresh(unreadCountProvider);
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(_extractErrorMessage(e), StackTrace.current);
    }
  }

  Future<void> updatePreferences(NotificationPreferences preferences) async {
    state = const AsyncValue.loading();
    try {
      await _dio.put(
        '/notifications/preferences',
        data: preferences.toJson(),
      );
      // Refresh preferences provider
      _ref.refresh(notificationPreferencesProvider);
      state = const AsyncValue.data(null);
    } on DioException catch (e) {
      state = AsyncValue.error(_extractErrorMessage(e), StackTrace.current);
    }
  }
}

// Notification notifier provider
final notificationNotifierProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<void>>(
  (ref) {
    final dio = ref.watch(dioClientProvider).dio;
    return NotificationNotifier(dio, ref);
  },
);

// Helper to extract error message
String _extractErrorMessage(DioException exception) {
  if (exception.response?.data is Map<String, dynamic>) {
    final data = exception.response!.data as Map<String, dynamic>;
    return data['message'] as String? ??
        data['error'] as String? ??
        'Terjadi kesalahan';
  }
  
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
      return 'Koneksi timeout. Periksa jaringan Anda.';
    case DioExceptionType.sendTimeout:
      return 'Waktu pengiriman habis.';
    case DioExceptionType.receiveTimeout:
      return 'Waktu penerimaan habis.';
    case DioExceptionType.badResponse:
      return 'Terjadi kesalahan server.';
    case DioExceptionType.cancel:
      return 'Permintaan dibatalkan.';
    case DioExceptionType.badCertificate:
      return 'Sertifikat tidak valid.';
    case DioExceptionType.connectionError:
      return 'Gagal terhubung. Periksa jaringan Anda.';
    case DioExceptionType.unknown:
      return 'Terjadi kesalahan yang tidak diketahui.';
  }
}

// Manual refresh trigger
final notificationRefreshProvider = StateProvider<int>((ref) => 0);

// Refreshable notifications that responds to manual refresh
final refreshableNotificationsProvider = FutureProvider.family<
    NotificationListResponse,
    Map<String, dynamic>?
>(
  (ref, filters) async {
    // Watch refresh trigger to invalidate when needed
    ref.watch(notificationRefreshProvider);
    return ref.watch(notificationsProvider(filters)).value ??
        NotificationListResponse(notifications: [], total: 0, unreadCount: 0);
  },
);
