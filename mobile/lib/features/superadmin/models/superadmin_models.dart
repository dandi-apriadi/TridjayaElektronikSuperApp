/// ============================================================
/// 👑 SUPER ADMIN MODELS
/// ============================================================
/// Model untuk Super Admin dengan kontrol penuh sistem
/// ============================================================

import '../../../core/models/user_model.dart';

/// ============================================================
/// 🎛️ SYSTEM CONFIGURATION
/// ============================================================

class SystemConfig {
  final String id;
  final String appName;
  final String appVersion;
  final bool maintenanceMode;
  final DateTime? maintenanceStart;
  final DateTime? maintenanceEnd;
  final String maintenanceMessage;
  final bool allowNewRegistrations;
  final bool requireEmailVerification;
  final int maxLoginAttempts;
  final int lockoutDurationMinutes;
  final String defaultTimezone;
  final String defaultLanguage;
  final DateTime updatedAt;
  final String? updatedBy;
  
  SystemConfig({
    required this.id,
    required this.appName,
    required this.appVersion,
    this.maintenanceMode = false,
    this.maintenanceStart,
    this.maintenanceEnd,
    this.maintenanceMessage = '',
    this.allowNewRegistrations = true,
    this.requireEmailVerification = true,
    this.maxLoginAttempts = 5,
    this.lockoutDurationMinutes = 30,
    this.defaultTimezone = 'WITA',
    this.defaultLanguage = 'id',
    required this.updatedAt,
    this.updatedBy,
  });
}

/// ============================================================
/// 👥 USER MANAGEMENT
/// ============================================================

class SuperAdminUserManagement {
  final String userId;
  final String username;
  final String email;
  final String fullName;
  final String? phone;
  final UserRole role;
  final String? branchId;
  final String? branchName;
  final bool isActive;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String? lastLoginIp;
  final int totalLogins;
  final List<String> permissions;
  final List<String> restrictions;
  final DateTime? suspendedUntil;
  final String? suspensionReason;
  final bool isImpersonating;
  final String? impersonatedBy;
  
  SuperAdminUserManagement({
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    this.phone,
    required this.role,
    this.branchId,
    this.branchName,
    this.isActive = true,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
    this.lastLoginAt,
    this.lastLoginIp,
    this.totalLogins = 0,
    this.permissions = const [],
    this.restrictions = const [],
    this.suspendedUntil,
    this.suspensionReason,
    this.isImpersonating = false,
    this.impersonatedBy,
  });
  
  String get statusLabel {
    if (suspendedUntil != null && suspendedUntil!.isAfter(DateTime.now())) {
      return 'Suspended';
    }
    if (!isActive) return 'Inactive';
    if (isImpersonating) return 'Impersonating';
    return 'Active';
  }
}

/// ============================================================
/// 📊 SYSTEM ANALYTICS & MONITORING
/// ============================================================

class SystemAnalytics {
  final DateTime date;
  final int totalUsers;
  final int activeUsers;
  final int newUsers;
  final int totalSessions;
  final double averageSessionDuration;
  final Map<String, int> roleDistribution;
  final Map<String, int> featureUsage;
  final int apiCalls;
  final double errorRate;
  final double uptime;
  final Map<String, double> responseTime;
  final int criticalErrors;
  final int warnings;
  
  SystemAnalytics({
    required this.date,
    required this.totalUsers,
    required this.activeUsers,
    required this.newUsers,
    required this.totalSessions,
    required this.averageSessionDuration,
    required this.roleDistribution,
    required this.featureUsage,
    required this.apiCalls,
    required this.errorRate,
    required this.uptime,
    required this.responseTime,
    this.criticalErrors = 0,
    this.warnings = 0,
  });
}

/// ============================================================
/// 🔐 AUDIT LOG
/// ============================================================

enum AuditActionType {
  userCreated,
  userUpdated,
  userDeleted,
  userSuspended,
  userActivated,
  roleChanged,
  permissionGranted,
  permissionRevoked,
  dataExported,
  dataDeleted,
  configChanged,
  securityAlert,
  login,
  logout,
  impersonationStart,
  impersonationEnd,
}

class AuditLogEntry {
  final String id;
  final DateTime timestamp;
  final String userId;
  final String userName;
  final UserRole userRole;
  final AuditActionType action;
  final String targetType; // 'user', 'config', 'data', etc
  final String? targetId;
  final String? targetName;
  final Map<String, dynamic>? oldValues;
  final Map<String, dynamic>? newValues;
  final String? reason;
  final String ipAddress;
  final String userAgent;
  final bool isCritical;
  
  AuditLogEntry({
    required this.id,
    required this.timestamp,
    required this.userId,
    required this.userName,
    required this.userRole,
    required this.action,
    required this.targetType,
    this.targetId,
    this.targetName,
    this.oldValues,
    this.newValues,
    this.reason,
    required this.ipAddress,
    required this.userAgent,
    this.isCritical = false,
  });
  
  String get actionLabel {
    switch (action) {
      case AuditActionType.userCreated:
        return 'Created User';
      case AuditActionType.userUpdated:
        return 'Updated User';
      case AuditActionType.userDeleted:
        return 'Deleted User';
      case AuditActionType.userSuspended:
        return 'Suspended User';
      case AuditActionType.userActivated:
        return 'Activated User';
      case AuditActionType.roleChanged:
        return 'Changed Role';
      case AuditActionType.permissionGranted:
        return 'Granted Permission';
      case AuditActionType.permissionRevoked:
        return 'Revoked Permission';
      case AuditActionType.dataExported:
        return 'Exported Data';
      case AuditActionType.dataDeleted:
        return 'Deleted Data';
      case AuditActionType.configChanged:
        return 'Changed Config';
      case AuditActionType.securityAlert:
        return 'Security Alert';
      case AuditActionType.login:
        return 'Login';
      case AuditActionType.logout:
        return 'Logout';
      case AuditActionType.impersonationStart:
        return 'Started Impersonation';
      case AuditActionType.impersonationEnd:
        return 'Ended Impersonation';
    }
  }
}

/// ============================================================
/// 🏢 BRANCH MANAGEMENT
/// ============================================================

class BranchManagement {
  final String id;
  final String name;
  final String code;
  final String address;
  final String? phone;
  final String? email;
  final String? managerId;
  final String? managerName;
  final bool isActive;
  final DateTime createdAt;
  final int totalUsers;
  final int activeUsers;
  final double monthlyRevenue;
  final double performanceScore;
  final Map<String, dynamic>? settings;
  
  BranchManagement({
    required this.id,
    required this.name,
    required this.code,
    required this.address,
    this.phone,
    this.email,
    this.managerId,
    this.managerName,
    this.isActive = true,
    required this.createdAt,
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.monthlyRevenue = 0,
    this.performanceScore = 0,
    this.settings,
  });
}

/// ============================================================
/// 🔑 ROLE & PERMISSION MANAGEMENT
/// ============================================================

class RoleDefinition {
  final UserRole role;
  final String name;
  final String description;
  final int level; // Higher = more privileges
  final List<String> permissions;
  final List<String> defaultPermissions;
  final bool canAccessAllBranches;
  final bool canManageUsers;
  final bool canEditData;
  final bool canDeleteData;
  final bool canViewReports;
  final bool canExportData;
  final bool isCustomizable;
  final Map<String, dynamic>? restrictions;
  
  RoleDefinition({
    required this.role,
    required this.name,
    required this.description,
    required this.level,
    required this.permissions,
    this.defaultPermissions = const [],
    this.canAccessAllBranches = false,
    this.canManageUsers = false,
    this.canEditData = false,
    this.canDeleteData = false,
    this.canViewReports = false,
    this.canExportData = false,
    this.isCustomizable = false,
    this.restrictions,
  });
}

class PermissionDetail {
  final String id;
  final String name;
  final String description;
  final String module; // 'users', 'branches', 'reports', etc
  final String category; // 'read', 'write', 'delete', 'admin'
  final bool requiresApproval;
  final List<UserRole>? allowedRoles;
  
  PermissionDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.module,
    required this.category,
    this.requiresApproval = false,
    this.allowedRoles,
  });
}

/// ============================================================
/// 📱 FEATURE FLAGS
/// ============================================================

class FeatureFlag {
  final String id;
  final String name;
  final String description;
  final String key;
  final bool isEnabled;
  final List<UserRole>? allowedRoles;
  final List<String>? allowedBranches;
  final DateTime? enabledSince;
  final DateTime? disabledSince;
  final String? enabledBy;
  final String? disabledBy;
  final String? reason;
  final bool requiresSuperAdmin;
  final Map<String, dynamic>? config;
  
  FeatureFlag({
    required this.id,
    required this.name,
    required this.description,
    required this.key,
    this.isEnabled = true,
    this.allowedRoles,
    this.allowedBranches,
    this.enabledSince,
    this.disabledSince,
    this.enabledBy,
    this.disabledBy,
    this.reason,
    this.requiresSuperAdmin = false,
    this.config,
  });
}

/// ============================================================
/// ⚠️ SECURITY ALERTS
/// ============================================================

enum SecurityAlertSeverity {
  critical,
  high,
  medium,
  low,
  info,
}

class SecurityAlert {
  final String id;
  final DateTime timestamp;
  final SecurityAlertSeverity severity;
  final String type;
  final String title;
  final String description;
  final String? userId;
  final String? userName;
  final String? ipAddress;
  final Map<String, dynamic>? details;
  final bool isResolved;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? resolution;
  
  SecurityAlert({
    required this.id,
    required this.timestamp,
    required this.severity,
    required this.type,
    required this.title,
    required this.description,
    this.userId,
    this.userName,
    this.ipAddress,
    this.details,
    this.isResolved = false,
    this.resolvedAt,
    this.resolvedBy,
    this.resolution,
  });
}

/// ============================================================
/// 📈 DASHBOARD WIDGETS DATA
/// ============================================================

class SuperAdminDashboardStats {
  final int totalUsers;
  final int activeUsers;
  final int inactiveUsers;
  final int suspendedUsers;
  final int totalBranches;
  final int activeBranches;
  final int totalRoles;
  final int activeSessions;
  final int pendingVerifications;
  final int criticalAlerts;
  final double systemUptime;
  final double averageResponseTime;
  final int apiCallsToday;
  final Map<String, int> loginsByRole;
  final List<Map<String, dynamic>> recentActivity;
  final Map<String, double> featureUsagePercentage;
  
  SuperAdminDashboardStats({
    required this.totalUsers,
    required this.activeUsers,
    required this.inactiveUsers,
    required this.suspendedUsers,
    required this.totalBranches,
    required this.activeBranches,
    required this.totalRoles,
    required this.activeSessions,
    required this.pendingVerifications,
    required this.criticalAlerts,
    required this.systemUptime,
    required this.averageResponseTime,
    required this.apiCallsToday,
    required this.loginsByRole,
    required this.recentActivity,
    required this.featureUsagePercentage,
  });
}

/// ============================================================
/// 🔄 DATA BACKUP & EXPORT
/// ============================================================

class BackupInfo {
  final String id;
  final String name;
  final DateTime createdAt;
  final int sizeBytes;
  final String type; // 'full', 'incremental', 'users', 'transactions'
  final String status; // 'completed', 'in_progress', 'failed'
  final String? createdBy;
  final String? downloadUrl;
  final int? expiresInDays;
  final Map<String, dynamic>? metadata;
  
  BackupInfo({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.sizeBytes,
    required this.type,
    required this.status,
    this.createdBy,
    this.downloadUrl,
    this.expiresInDays,
    this.metadata,
  });
  
  String get sizeFormatted {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    if (sizeBytes < 1024 * 1024 * 1024) return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
