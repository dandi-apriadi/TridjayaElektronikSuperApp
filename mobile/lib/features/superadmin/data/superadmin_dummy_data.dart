/// ============================================================
/// 👑 SUPER ADMIN DUMMY DATA
/// ============================================================
/// Data dummy untuk testing Super Admin dashboard
/// ============================================================

import '../../../core/models/user_model.dart';
import '../models/superadmin_models.dart';

class SuperAdminDummyData {
  
  /// ============================================================
  /// 🎛️ SYSTEM CONFIG
  /// ============================================================
  
  static SystemConfig getSystemConfig() {
    return SystemConfig(
      id: 'sys_config_001',
      appName: 'Tridjaya SuperApp',
      appVersion: '2.1.0',
      maintenanceMode: false,
      maintenanceStart: null,
      maintenanceEnd: null,
      maintenanceMessage: 'Sistem sedang dalam maintenance. Mohon tunggu.',
      allowNewRegistrations: true,
      requireEmailVerification: true,
      maxLoginAttempts: 5,
      lockoutDurationMinutes: 30,
      defaultTimezone: 'WITA',
      defaultLanguage: 'id',
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedBy: 'Super Admin',
    );
  }
  
  /// ============================================================
  /// 👥 USERS MANAGEMENT
  /// ============================================================
  
  static List<SuperAdminUserManagement> getAllUsers() {
    return [
      SuperAdminUserManagement(
        userId: 'superadmin_001',
        username: 'superadmin',
        email: 'superadmin@tridjaya.id',
        fullName: 'Super Administrator',
        phone: '081234567890',
        role: UserRole.superAdmin,
        branchId: null,
        branchName: 'All Branches',
        isActive: true,
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 365)),
        lastLoginAt: DateTime.now().subtract(const Duration(minutes: 5)),
        lastLoginIp: '192.168.1.100',
        totalLogins: 1247,
        permissions: ['all'],
        restrictions: [],
      ),
      
      SuperAdminUserManagement(
        userId: 'owner_001',
        username: 'owner_tridjaya',
        email: 'owner@tridjaya.id',
        fullName: 'Owner Tridjaya',
        phone: '081234567891',
        role: UserRole.owner,
        branchId: null,
        branchName: 'All Branches',
        isActive: true,
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 300)),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
        lastLoginIp: '192.168.1.101',
        totalLogins: 856,
        permissions: ['view_all', 'edit_all', 'manage_branches'],
        restrictions: [],
      ),
      
      SuperAdminUserManagement(
        userId: 'kc_001',
        username: 'kc_pusat',
        email: 'kc@tridjaya.id',
        fullName: 'Ahmad Kepala Cabang',
        phone: '081234567892',
        role: UserRole.kepalaCabang,
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        isActive: true,
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 200)),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 4)),
        lastLoginIp: '192.168.2.100',
        totalLogins: 423,
        permissions: ['view_branch', 'edit_branch', 'verify_jobdesk'],
        restrictions: [],
      ),
      
      SuperAdminUserManagement(
        userId: 'kc_002',
        username: 'kc_selatan',
        email: 'kc.selatan@tridjaya.id',
        fullName: 'Budi Kepala Cabang Selatan',
        phone: '081234567893',
        role: UserRole.kepalaCabang,
        branchId: 'branch_002',
        branchName: 'Cabang Selatan',
        isActive: true,
        isEmailVerified: true,
        isPhoneVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 150)),
        lastLoginAt: DateTime.now().subtract(const Duration(days: 1)),
        lastLoginIp: '192.168.3.100',
        totalLogins: 234,
        permissions: ['view_branch', 'edit_branch'],
        restrictions: ['no_export'],
      ),
      
      SuperAdminUserManagement(
        userId: 'admin_001',
        username: 'admin_support',
        email: 'admin@tridjaya.id',
        fullName: 'Citra Admin',
        phone: '081234567894',
        role: UserRole.admin,
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        isActive: true,
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 1)),
        lastLoginIp: '192.168.2.101',
        totalLogins: 567,
        permissions: ['view_inventory', 'edit_inventory'],
        restrictions: [],
      ),
      
      SuperAdminUserManagement(
        userId: 'sales_001',
        username: 'sales_ahmad',
        email: 'ahmad.sales@tridjaya.id',
        fullName: 'Ahmad Sales',
        phone: '081234567895',
        role: UserRole.sales,
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        isActive: true,
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 3)),
        lastLoginIp: '192.168.2.102',
        totalLogins: 345,
        permissions: ['view_prospects', 'edit_prospects'],
        restrictions: [],
      ),
      
      SuperAdminUserManagement(
        userId: 'sales_002',
        username: 'sales_budi',
        email: 'budi.sales@tridjaya.id',
        fullName: 'Budi Sales',
        phone: '081234567896',
        role: UserRole.sales,
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        isActive: false, // Inactive
        isEmailVerified: false,
        isPhoneVerified: false,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        lastLoginAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLoginIp: '192.168.2.103',
        totalLogins: 45,
        permissions: ['view_prospects'],
        restrictions: ['cannot_create'],
      ),
      
      SuperAdminUserManagement(
        userId: 'driver_001',
        username: 'driver_dedi',
        email: 'dedi@tridjaya.id',
        fullName: 'Dedi Driver',
        phone: '081234567897',
        role: UserRole.driver,
        branchId: 'branch_001',
        branchName: 'Cabang Pusat',
        isActive: true,
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 100)),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 6)),
        lastLoginIp: '192.168.2.104',
        totalLogins: 289,
        permissions: ['view_deliveries', 'update_deliveries'],
        restrictions: [],
      ),
      
      // Suspended user
      SuperAdminUserManagement(
        userId: 'admin_002',
        username: 'admin_problem',
        email: 'problem@tridjaya.id',
        fullName: 'Problem User',
        phone: '081234567898',
        role: UserRole.admin,
        branchId: 'branch_002',
        branchName: 'Cabang Selatan',
        isActive: false,
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        lastLoginAt: DateTime.now().subtract(const Duration(days: 7)),
        lastLoginIp: '192.168.3.101',
        totalLogins: 78,
        permissions: [],
        restrictions: ['all'],
        suspendedUntil: DateTime.now().add(const Duration(days: 7)),
        suspensionReason: 'Pelanggaran kebijakan penggunaan data',
      ),
      
      // Impersonating session
      SuperAdminUserManagement(
        userId: 'owner_002',
        username: 'owner_testing',
        email: 'test@tridjaya.id',
        fullName: 'Test Owner',
        phone: '081234567899',
        role: UserRole.owner,
        branchId: 'branch_003',
        branchName: 'Cabang Timur',
        isActive: true,
        isEmailVerified: true,
        isPhoneVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLoginAt: DateTime.now(),
        lastLoginIp: '192.168.1.100',
        totalLogins: 12,
        permissions: ['view_all'],
        restrictions: [],
        isImpersonating: true,
        impersonatedBy: 'superadmin',
      ),
    ];
  }
  
  /// ============================================================
  /// 📊 SYSTEM ANALYTICS
  /// ============================================================
  
  static SystemAnalytics getSystemAnalytics() {
    return SystemAnalytics(
      date: DateTime.now(),
      totalUsers: 156,
      activeUsers: 142,
      newUsers: 12,
      totalSessions: 1247,
      averageSessionDuration: 28.5,
      roleDistribution: {
        'SuperAdmin': 1,
        'Owner': 3,
        'KepalaCabang': 5,
        'Admin': 24,
        'Sales': 67,
        'Driver': 56,
      },
      featureUsage: {
        'jobdesk': 1240,
        'inventory': 856,
        'prospects': 2341,
        'deliveries': 1890,
        'reports': 567,
      },
      apiCalls: 45678,
      errorRate: 0.02,
      uptime: 99.9,
      responseTime: {
        'average': 245,
        'p95': 450,
        'p99': 890,
      },
      criticalErrors: 2,
      warnings: 15,
    );
  }
  
  /// ============================================================
  /// 🔐 AUDIT LOGS
  /// ============================================================
  
  static List<AuditLogEntry> getAuditLogs() {
    return [
      AuditLogEntry(
        id: 'audit_001',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        userId: 'superadmin_001',
        userName: 'Super Administrator',
        userRole: UserRole.superAdmin,
        action: AuditActionType.userCreated,
        targetType: 'user',
        targetId: 'admin_003',
        targetName: 'Admin Baru',
        newValues: {
          'username': 'admin_baru',
          'role': 'Admin',
          'branch': 'Cabang Pusat',
        },
        reason: 'Rekrutmen baru',
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0)',
        isCritical: false,
      ),
      
      AuditLogEntry(
        id: 'audit_002',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        userId: 'superadmin_001',
        userName: 'Super Administrator',
        userRole: UserRole.superAdmin,
        action: AuditActionType.roleChanged,
        targetType: 'user',
        targetId: 'sales_003',
        targetName: 'Citra Lestari',
        oldValues: {'role': 'Sales'},
        newValues: {'role': 'Admin'},
        reason: 'Promosi jabatan',
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0)',
        isCritical: true,
      ),
      
      AuditLogEntry(
        id: 'audit_003',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        userId: 'superadmin_001',
        userName: 'Super Administrator',
        userRole: UserRole.superAdmin,
        action: AuditActionType.userSuspended,
        targetType: 'user',
        targetId: 'admin_002',
        targetName: 'Problem User',
        oldValues: {'status': 'active'},
        newValues: {
          'status': 'suspended',
          'until': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        },
        reason: 'Pelanggaran kebijakan penggunaan data',
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0)',
        isCritical: true,
      ),
      
      AuditLogEntry(
        id: 'audit_004',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        userId: 'owner_001',
        userName: 'Owner Tridjaya',
        userRole: UserRole.owner,
        action: AuditActionType.configChanged,
        targetType: 'config',
        targetId: 'jobdesk_config',
        targetName: 'Job Desk Settings',
        oldValues: {'cutoff_time': '08:00'},
        newValues: {'cutoff_time': '09:00'},
        reason: 'Penyesuaian dengan jam kerja baru',
        ipAddress: '192.168.1.101',
        userAgent: 'Mozilla/5.0 (iPhone)',
        isCritical: false,
      ),
      
      AuditLogEntry(
        id: 'audit_005',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        userId: 'superadmin_001',
        userName: 'Super Administrator',
        userRole: UserRole.superAdmin,
        action: AuditActionType.impersonationStart,
        targetType: 'user',
        targetId: 'owner_002',
        targetName: 'Test Owner',
        reason: 'Troubleshooting issue',
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0)',
        isCritical: true,
      ),
      
      AuditLogEntry(
        id: 'audit_006',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        userId: 'kc_001',
        userName: 'Ahmad Kepala Cabang',
        userRole: UserRole.kepalaCabang,
        action: AuditActionType.permissionGranted,
        targetType: 'user',
        targetId: 'sales_001',
        targetName: 'Ahmad Sales',
        newValues: {'permission': 'export_reports'},
        reason: 'Kebutuhan laporan bulanan',
        ipAddress: '192.168.2.100',
        userAgent: 'Mozilla/5.0 (Android)',
        isCritical: false,
      ),
      
      AuditLogEntry(
        id: 'audit_007',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        userId: 'superadmin_001',
        userName: 'Super Administrator',
        userRole: UserRole.superAdmin,
        action: AuditActionType.dataExported,
        targetType: 'data',
        targetId: 'all_users',
        targetName: 'All Users Data',
        newValues: {
          'format': 'CSV',
          'records': 156,
          'size': '45KB',
        },
        reason: 'Backup bulanan',
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0)',
        isCritical: false,
      ),
      
      AuditLogEntry(
        id: 'audit_008',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        userId: 'system',
        userName: 'System',
        userRole: UserRole.superAdmin,
        action: AuditActionType.securityAlert,
        targetType: 'security',
        targetId: 'failed_login',
        targetName: 'Multiple Failed Login Attempts',
        newValues: {
          'attempts': 10,
          'ip': '203.0.113.45',
          'user': 'admin_001',
        },
        reason: 'Auto-generated security alert',
        ipAddress: '127.0.0.1',
        userAgent: 'System',
        isCritical: true,
      ),
    ];
  }
  
  /// ============================================================
  /// 🏢 BRANCHES
  /// ============================================================
  
  static List<BranchManagement> getAllBranches() {
    return [
      BranchManagement(
        id: 'branch_001',
        name: 'Cabang Pusat',
        code: 'CP001',
        address: 'Jl. Sudirman No. 123, Jakarta',
        phone: '021-12345678',
        email: 'pusat@tridjaya.id',
        managerId: 'kc_001',
        managerName: 'Ahmad Kepala Cabang',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 400)),
        totalUsers: 45,
        activeUsers: 43,
        monthlyRevenue: 2500000000,
        performanceScore: 92.5,
        settings: {
          'cutoff_time': '09:00',
          'timezone': 'WITA',
        },
      ),
      
      BranchManagement(
        id: 'branch_002',
        name: 'Cabang Selatan',
        code: 'CS002',
        address: 'Jl. Gatot Subroto No. 45, Bandung',
        phone: '022-87654321',
        email: 'selatan@tridjaya.id',
        managerId: 'kc_002',
        managerName: 'Budi Kepala Cabang Selatan',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 250)),
        totalUsers: 38,
        activeUsers: 35,
        monthlyRevenue: 1800000000,
        performanceScore: 85.0,
        settings: {
          'cutoff_time': '09:00',
          'timezone': 'WIB',
        },
      ),
      
      BranchManagement(
        id: 'branch_003',
        name: 'Cabang Timur',
        code: 'CT003',
        address: 'Jl. Ahmad Yani No. 67, Surabaya',
        phone: '031-98765432',
        email: 'timur@tridjaya.id',
        managerId: 'kc_003',
        managerName: 'Citra Kepala Cabang Timur',
        isActive: true,
        createdAt: DateTime.now().subtract(const Duration(days: 180)),
        totalUsers: 42,
        activeUsers: 40,
        monthlyRevenue: 2100000000,
        performanceScore: 88.5,
        settings: {
          'cutoff_time': '09:00',
          'timezone': 'WITA',
        },
      ),
      
      BranchManagement(
        id: 'branch_004',
        name: 'Cabang Barat',
        code: 'CB004',
        address: 'Jl. Pemuda No. 89, Semarang',
        phone: '024-56789123',
        email: 'barat@tridjaya.id',
        managerId: null,
        managerName: null,
        isActive: false, // Inactive
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        totalUsers: 15,
        activeUsers: 0,
        monthlyRevenue: 0,
        performanceScore: 0,
        settings: null,
      ),
    ];
  }
  
  /// ============================================================
  /// 🎭 ROLE DEFINITIONS
  /// ============================================================
  
  static List<RoleDefinition> getAllRoles() {
    return [
      RoleDefinition(
        role: UserRole.superAdmin,
        name: 'Super Admin',
        description: 'Full system access and control',
        level: 100,
        permissions: ['all', 'impersonate', 'manage_admins', 'system_config'],
        canAccessAllBranches: true,
        canManageUsers: true,
        canEditData: true,
        canDeleteData: true,
        canViewReports: true,
        canExportData: true,
        isCustomizable: false,
      ),
      
      RoleDefinition(
        role: UserRole.owner,
        name: 'Owner',
        description: 'Business owner with full business access',
        level: 80,
        permissions: ['view_all', 'edit_all', 'manage_branches', 'view_financials'],
        canAccessAllBranches: true,
        canManageUsers: true,
        canEditData: true,
        canDeleteData: true,
        canViewReports: true,
        canExportData: true,
        isCustomizable: true,
      ),
      
      RoleDefinition(
        role: UserRole.kepalaCabang,
        name: 'Kepala Cabang',
        description: 'Branch manager with branch-level access',
        level: 60,
        permissions: ['view_branch', 'edit_branch', 'verify_jobdesk', 'manage_branch_users'],
        canAccessAllBranches: false,
        canManageUsers: true,
        canEditData: true,
        canDeleteData: false,
        canViewReports: true,
        canExportData: false,
        isCustomizable: true,
      ),
      
      RoleDefinition(
        role: UserRole.admin,
        name: 'Admin',
        description: 'Administrative staff',
        level: 40,
        permissions: ['view_inventory', 'edit_inventory', 'view_reports'],
        canAccessAllBranches: false,
        canManageUsers: false,
        canEditData: true,
        canDeleteData: false,
        canViewReports: true,
        canExportData: false,
        isCustomizable: true,
      ),
      
      RoleDefinition(
        role: UserRole.sales,
        name: 'Sales',
        description: 'Sales team member',
        level: 20,
        permissions: ['view_prospects', 'edit_prospects', 'view_campaigns'],
        canAccessAllBranches: false,
        canManageUsers: false,
        canEditData: true,
        canDeleteData: false,
        canViewReports: false,
        canExportData: false,
        isCustomizable: true,
      ),
      
      RoleDefinition(
        role: UserRole.driver,
        name: 'Driver',
        description: 'Delivery driver',
        level: 20,
        permissions: ['view_deliveries', 'update_deliveries', 'view_routes'],
        canAccessAllBranches: false,
        canManageUsers: false,
        canEditData: true,
        canDeleteData: false,
        canViewReports: false,
        canExportData: false,
        isCustomizable: false,
      ),
    ];
  }
  
  /// ============================================================
  /// 🚩 FEATURE FLAGS
  /// ============================================================
  
  static List<FeatureFlag> getFeatureFlags() {
    return [
      FeatureFlag(
        id: 'feat_001',
        name: 'Job Desk System',
        description: 'Enable job desk feature for all users',
        key: 'jobdesk_enabled',
        isEnabled: true,
        enabledSince: DateTime.now().subtract(const Duration(days: 30)),
        enabledBy: 'Super Admin',
        requiresSuperAdmin: false,
      ),
      
      FeatureFlag(
        id: 'feat_002',
        name: 'Advanced Analytics',
        description: 'Enable advanced analytics dashboard',
        key: 'advanced_analytics',
        isEnabled: true,
        allowedRoles: [UserRole.superAdmin, UserRole.owner, UserRole.kepalaCabang],
        enabledSince: DateTime.now().subtract(const Duration(days: 15)),
        enabledBy: 'Super Admin',
        requiresSuperAdmin: true,
      ),
      
      FeatureFlag(
        id: 'feat_003',
        name: 'Beta Inventory System',
        description: 'New inventory management system (Beta)',
        key: 'beta_inventory',
        isEnabled: false,
        allowedRoles: [UserRole.superAdmin, UserRole.owner],
        disabledSince: DateTime.now().subtract(const Duration(days: 5)),
        disabledBy: 'Super Admin',
        reason: 'Pending stability improvements',
        requiresSuperAdmin: true,
      ),
      
      FeatureFlag(
        id: 'feat_004',
        name: 'Multi-Branch Job Desk',
        description: 'Allow job desk across multiple branches',
        key: 'multi_branch_jobdesk',
        isEnabled: true,
        allowedBranches: ['branch_001', 'branch_002'],
        enabledSince: DateTime.now().subtract(const Duration(days: 20)),
        enabledBy: 'Super Admin',
        requiresSuperAdmin: true,
      ),
      
      FeatureFlag(
        id: 'feat_005',
        name: 'Export to PDF',
        description: 'Allow PDF export feature',
        key: 'export_pdf',
        isEnabled: true,
        allowedRoles: [UserRole.superAdmin, UserRole.owner, UserRole.kepalaCabang, UserRole.admin],
        enabledSince: DateTime.now().subtract(const Duration(days: 60)),
        enabledBy: 'Super Admin',
        requiresSuperAdmin: false,
      ),
    ];
  }
  
  /// ============================================================
  /// ⚠️ SECURITY ALERTS
  /// ============================================================
  
  static List<SecurityAlert> getSecurityAlerts() {
    return [
      SecurityAlert(
        id: 'alert_001',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        severity: SecurityAlertSeverity.critical,
        type: 'suspicious_login',
        title: 'Suspicious Login Attempts',
        description: 'Multiple failed login attempts detected from IP 203.0.113.45 targeting admin account',
        userId: 'admin_001',
        userName: 'Admin Support',
        ipAddress: '203.0.113.45',
        details: {
          'attempts': 10,
          'time_window': '5 minutes',
          'country': 'Unknown',
        },
        isResolved: false,
      ),
      
      SecurityAlert(
        id: 'alert_002',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        severity: SecurityAlertSeverity.high,
        type: 'unusual_activity',
        title: 'Unusual Data Access Pattern',
        description: 'User accessed 500+ records in 10 minutes, significantly above normal pattern',
        userId: 'sales_001',
        userName: 'Ahmad Sales',
        ipAddress: '192.168.2.102',
        details: {
          'records_accessed': 523,
          'time_window': '10 minutes',
          'normal_average': 25,
        },
        isResolved: true,
        resolvedAt: DateTime.now().subtract(const Duration(hours: 1)),
        resolvedBy: 'Super Admin',
        resolution: 'Investigated - User was generating monthly report',
      ),
      
      SecurityAlert(
        id: 'alert_003',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        severity: SecurityAlertSeverity.medium,
        type: 'password_weak',
        title: 'Weak Password Detected',
        description: '5 users still using passwords that do not meet new security policy',
        details: {
          'affected_users': 5,
          'policy_version': '2.0',
        },
        isResolved: false,
      ),
      
      SecurityAlert(
        id: 'alert_004',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        severity: SecurityAlertSeverity.info,
        type: 'maintenance',
        title: 'Scheduled Maintenance Completed',
        description: 'System maintenance completed successfully. No issues detected.',
        isResolved: true,
        resolvedAt: DateTime.now().subtract(const Duration(days: 1)),
        resolvedBy: 'System',
      ),
    ];
  }
  
  /// ============================================================
  /// 📊 DASHBOARD STATS
  /// ============================================================
  
  static SuperAdminDashboardStats getDashboardStats() {
    return SuperAdminDashboardStats(
      totalUsers: 156,
      activeUsers: 142,
      inactiveUsers: 8,
      suspendedUsers: 6,
      totalBranches: 4,
      activeBranches: 3,
      totalRoles: 6,
      activeSessions: 47,
      pendingVerifications: 23,
      criticalAlerts: 1,
      systemUptime: 99.92,
      averageResponseTime: 245.5,
      apiCallsToday: 45678,
      loginsByRole: {
        'SuperAdmin': 12,
        'Owner': 28,
        'KepalaCabang': 45,
        'Admin': 134,
        'Sales': 567,
        'Driver': 298,
      },
      recentActivity: [
        {
          'action': 'User Created',
          'user': 'Super Admin',
          'target': 'Admin Baru',
          'time': '5 menit lalu',
        },
        {
          'action': 'Role Changed',
          'user': 'Super Admin',
          'target': 'Citra Lestari',
          'time': '30 menit lalu',
        },
        {
          'action': 'Config Updated',
          'user': 'Owner Tridjaya',
          'target': 'Job Desk Settings',
          'time': '2 jam lalu',
        },
        {
          'action': 'User Suspended',
          'user': 'Super Admin',
          'target': 'Problem User',
          'time': '3 jam lalu',
        },
        {
          'action': 'Data Exported',
          'user': 'Super Admin',
          'target': 'All Users CSV',
          'time': '1 hari lalu',
        },
      ],
      featureUsagePercentage: {
        'Job Desk': 87.5,
        'Inventory': 62.3,
        'Prospects': 91.2,
        'Deliveries': 78.9,
        'Reports': 45.6,
      },
    );
  }
  
  /// ============================================================
  /// 💾 BACKUP INFO
  /// ============================================================
  
  static List<BackupInfo> getBackups() {
    return [
      BackupInfo(
        id: 'backup_001',
        name: 'Full System Backup - May 2026',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        sizeBytes: 2 * 1024 * 1024 * 1024, // 2GB
        type: 'full',
        status: 'completed',
        createdBy: 'Super Admin',
        expiresInDays: 30,
        metadata: {
          'tables': 45,
          'records': 125678,
          'duration': '15 minutes',
        },
      ),
      
      BackupInfo(
        id: 'backup_002',
        name: 'Incremental - May 8, 2026',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        sizeBytes: 156 * 1024 * 1024, // 156MB
        type: 'incremental',
        status: 'completed',
        createdBy: 'System',
        expiresInDays: 7,
        metadata: {
          'changes': 2341,
          'duration': '2 minutes',
        },
      ),
      
      BackupInfo(
        id: 'backup_003',
        name: 'User Data Only',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        sizeBytes: 45 * 1024 * 1024, // 45MB
        type: 'users',
        status: 'completed',
        createdBy: 'Super Admin',
        expiresInDays: 90,
        metadata: {
          'users_exported': 156,
          'duration': '30 seconds',
        },
      ),
      
      BackupInfo(
        id: 'backup_004',
        name: 'Emergency Backup',
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        sizeBytes: 1 * 1024 * 1024 * 1024, // 1GB
        type: 'full',
        status: 'in_progress',
        createdBy: 'Super Admin',
        expiresInDays: 7,
        metadata: {
          'progress': '75%',
          'estimated_completion': '5 minutes',
        },
      ),
    ];
  }
}
