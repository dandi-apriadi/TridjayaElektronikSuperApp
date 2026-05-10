import 'package:flutter/material.dart';

/// ============================================================
/// 👤 USER SETTINGS MODEL
/// Pengaturan notifikasi dan preferensi pengguna
/// ============================================================

class UserSettings {
  final String userId;
  
  // Notification Settings
  final bool taskReminderEnabled;
  final TimeOfDay reminderTime;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  
  // Reminder Settings
  final bool remindBeforeDeadline;
  final int reminderDaysBefore;
  final bool remindDailySummary;
  
  // Appearance Settings
  final bool darkModeEnabled;
  final String language;
  
  // Security Settings
  final bool biometricLoginEnabled;
  final bool requirePasswordForSensitiveActions;

  UserSettings({
    required this.userId,
    this.taskReminderEnabled = true,
    this.reminderTime = const TimeOfDay(hour: 21, minute: 0), // Default 9 PM
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = false,
    this.smsNotificationsEnabled = false,
    this.remindBeforeDeadline = true,
    this.reminderDaysBefore = 1,
    this.remindDailySummary = true,
    this.darkModeEnabled = false,
    this.language = 'id',
    this.biometricLoginEnabled = false,
    this.requirePasswordForSensitiveActions = true,
  });

  UserSettings copyWith({
    String? userId,
    bool? taskReminderEnabled,
    TimeOfDay? reminderTime,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? smsNotificationsEnabled,
    bool? remindBeforeDeadline,
    int? reminderDaysBefore,
    bool? remindDailySummary,
    bool? darkModeEnabled,
    String? language,
    bool? biometricLoginEnabled,
    bool? requirePasswordForSensitiveActions,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      taskReminderEnabled: taskReminderEnabled ?? this.taskReminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      remindBeforeDeadline: remindBeforeDeadline ?? this.remindBeforeDeadline,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
      remindDailySummary: remindDailySummary ?? this.remindDailySummary,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      language: language ?? this.language,
      biometricLoginEnabled: biometricLoginEnabled ?? this.biometricLoginEnabled,
      requirePasswordForSensitiveActions: requirePasswordForSensitiveActions ?? this.requirePasswordForSensitiveActions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'taskReminderEnabled': taskReminderEnabled,
      'reminderTime': '${reminderTime.hour}:${reminderTime.minute}',
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'smsNotificationsEnabled': smsNotificationsEnabled,
      'remindBeforeDeadline': remindBeforeDeadline,
      'reminderDaysBefore': reminderDaysBefore,
      'remindDailySummary': remindDailySummary,
      'darkModeEnabled': darkModeEnabled,
      'language': language,
      'biometricLoginEnabled': biometricLoginEnabled,
      'requirePasswordForSensitiveActions': requirePasswordForSensitiveActions,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['reminderTime'] as String?)?.split(':') ?? ['21', '0'];
    return UserSettings(
      userId: json['userId'] ?? '',
      taskReminderEnabled: json['taskReminderEnabled'] ?? true,
      reminderTime: TimeOfDay(
        hour: int.tryParse(timeParts[0]) ?? 21,
        minute: int.tryParse(timeParts[1]) ?? 0,
      ),
      pushNotificationsEnabled: json['pushNotificationsEnabled'] ?? true,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] ?? false,
      smsNotificationsEnabled: json['smsNotificationsEnabled'] ?? false,
      remindBeforeDeadline: json['remindBeforeDeadline'] ?? true,
      reminderDaysBefore: json['reminderDaysBefore'] ?? 1,
      remindDailySummary: json['remindDailySummary'] ?? true,
      darkModeEnabled: json['darkModeEnabled'] ?? false,
      language: json['language'] ?? 'id',
      biometricLoginEnabled: json['biometricLoginEnabled'] ?? false,
      requirePasswordForSensitiveActions: json['requirePasswordForSensitiveActions'] ?? true,
    );
  }
}
