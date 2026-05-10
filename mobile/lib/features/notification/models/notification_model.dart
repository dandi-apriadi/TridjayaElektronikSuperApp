import 'package:flutter/material.dart';

/// ============================================================
/// 🔔 NOTIFICATION MODELS
/// ============================================================

enum NotificationType {
  jobdesk,
  attendance,
  approval,
  system,
  announcement,
}

extension NotificationTypeExtension on NotificationType {
  String get value => toString().split('.').last;

  String get label {
    switch (this) {
      case NotificationType.jobdesk:
        return 'Job Desk';
      case NotificationType.attendance:
        return 'Absensi';
      case NotificationType.approval:
        return 'Persetujuan';
      case NotificationType.system:
        return 'Sistem';
      case NotificationType.announcement:
        return 'Pengumuman';
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.jobdesk:
        return const Color(0xFF2196F3); // Blue
      case NotificationType.attendance:
        return const Color(0xFF4CAF50); // Green
      case NotificationType.approval:
        return const Color(0xFFFF9800); // Orange
      case NotificationType.system:
        return const Color(0xFF9C27B0); // Purple
      case NotificationType.announcement:
        return const Color(0xFFF44336); // Red
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.jobdesk:
        return Icons.assignment_turned_in;
      case NotificationType.attendance:
        return Icons.check_circle;
      case NotificationType.approval:
        return Icons.verified_user;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.announcement:
        return Icons.campaign;
    }
  }

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.system,
    );
  }
}

class Notification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final bool isRead;
  final String? actionRoute;
  final Map<String, dynamic>? actionParams;
  final DateTime createdAt;

  Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    this.actionRoute,
    this.actionParams,
    required this.createdAt,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'] as String,
      type: NotificationTypeExtension.fromString(json['type'] as String),
      title: json['title'] as String,
      message: json['message'] as String,
      isRead: json['is_read'] as bool? ?? false,
      actionRoute: json['action_route'] as String?,
      actionParams: json['action_params'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.value,
      'title': title,
      'message': message,
      'is_read': isRead,
      'action_route': actionRoute,
      'action_params': actionParams,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Notification copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    bool? isRead,
    String? actionRoute,
    Map<String, dynamic>? actionParams,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      actionRoute: actionRoute ?? this.actionRoute,
      actionParams: actionParams ?? this.actionParams,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class NotificationListResponse {
  final List<Notification> notifications;
  final int total;
  final int unreadCount;

  NotificationListResponse({
    required this.notifications,
    required this.total,
    required this.unreadCount,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    final notificationsJson = json['notifications'] as List<dynamic>? ?? [];
    return NotificationListResponse(
      notifications: notificationsJson
          .cast<Map<String, dynamic>>()
          .map(Notification.fromJson)
          .toList(),
      total: json['total'] as int? ?? 0,
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}

class UnreadCountResponse {
  final int unreadCount;

  UnreadCountResponse({required this.unreadCount});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }
}

class CreateNotificationRequest {
  final String userId;
  final String type;
  final String title;
  final String message;
  final String? actionRoute;
  final Map<String, dynamic>? actionParams;

  CreateNotificationRequest({
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    this.actionRoute,
    this.actionParams,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'type': type,
      'title': title,
      'message': message,
      'action_route': actionRoute,
      'action_params': actionParams,
    };
  }
}

class NotificationPreferences {
  final bool enableJobdesk;
  final bool enableAttendance;
  final bool enableApproval;
  final bool enableSystem;
  final bool enableAnnouncement;

  NotificationPreferences({
    required this.enableJobdesk,
    required this.enableAttendance,
    required this.enableApproval,
    required this.enableSystem,
    required this.enableAnnouncement,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      enableJobdesk: json['enable_jobdesk'] as bool? ?? true,
      enableAttendance: json['enable_attendance'] as bool? ?? true,
      enableApproval: json['enable_approval'] as bool? ?? true,
      enableSystem: json['enable_system'] as bool? ?? true,
      enableAnnouncement: json['enable_announcement'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enable_jobdesk': enableJobdesk,
      'enable_attendance': enableAttendance,
      'enable_approval': enableApproval,
      'enable_system': enableSystem,
      'enable_announcement': enableAnnouncement,
    };
  }

  NotificationPreferences copyWith({
    bool? enableJobdesk,
    bool? enableAttendance,
    bool? enableApproval,
    bool? enableSystem,
    bool? enableAnnouncement,
  }) {
    return NotificationPreferences(
      enableJobdesk: enableJobdesk ?? this.enableJobdesk,
      enableAttendance: enableAttendance ?? this.enableAttendance,
      enableApproval: enableApproval ?? this.enableApproval,
      enableSystem: enableSystem ?? this.enableSystem,
      enableAnnouncement: enableAnnouncement ?? this.enableAnnouncement,
    );
  }
}
