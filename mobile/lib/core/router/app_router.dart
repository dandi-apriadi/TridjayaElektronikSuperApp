import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user_model.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/password_reset_screen.dart';
import '../../features/owner/presentation/screens/owner_dashboard_screen.dart';
import '../../features/owner/presentation/screens/performance_screen.dart';
import '../../features/owner/presentation/screens/branch_detail_screen.dart';
import '../../features/kepala_cabang/presentation/screens/kepala_cabang_dashboard_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard_screen.dart';
import '../../features/admin/presentation/screens/inventory_screen.dart';
import '../../features/sales/presentation/screens/sales_dashboard_screen.dart';
import '../../features/sales/presentation/screens/prospect_screen.dart';
import '../../features/sales/presentation/screens/campaign_screen.dart';
import '../../features/driver/presentation/screens/driver_dashboard_screen.dart';
import '../../shared/screens/attendance_screen.dart';
import '../../shared/screens/task_screen.dart';
import '../../shared/screens/work_report_screen.dart';
import '../../shared/screens/profile_screen.dart';
import '../../shared/screens/notification_screen.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../features/jobdesk/presentation/screens/my_jobdesk_screen.dart';
import '../../features/jobdesk/presentation/screens/jobdesk_template_list_screen.dart';
import '../../features/jobdesk/presentation/screens/jobdesk_monitoring_screen.dart';
import '../../features/jobdesk/presentation/screens/pic_dashboard_screen.dart';
import '../../features/jobdesk/presentation/screens/photo_review_screen.dart';
import '../../features/jobdesk/presentation/screens/task_submission_screen.dart';
import '../../features/jobdesk/presentation/screens/jobdesk_activity_report_screen.dart';
import '../../features/superadmin/presentation/screens/superadmin_dashboard_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoading = authState.isLoading;
      if (isLoading) return null;
      final user = authState.valueOrNull;
      final isOnAuthPage = state.matchedLocation == '/login' ||
          state.matchedLocation.startsWith('/password-reset');
      if (user == null && !isOnAuthPage) return '/login';
      if (user != null && isOnAuthPage) return _dashboardRoute(user.role);
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/password-reset', builder: (_, __) => const PasswordResetScreen()),

      // ── Owner ──────────────────────────────────────────────
      GoRoute(
        path: '/owner',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const OwnerDashboardScreen()),
      ),
      GoRoute(
        path: '/owner/performance',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const PerformanceScreen()),
      ),
      GoRoute(
        path: '/owner/branches/:id',
        builder: (_, state) => AppScaffold(
          currentRoute: state.matchedLocation,
          child: BranchDetailScreen(branchId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/owner/reports',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const WorkReportScreen()),
      ),
      GoRoute(
        path: '/owner/profile',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const ProfileScreen()),
      ),

      // ── Kepala Cabang ──────────────────────────────────────
      GoRoute(
        path: '/kepala-cabang',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const KepalaCabangDashboardScreen()),
      ),
      GoRoute(
        path: '/kepala-cabang/tasks',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const TaskScreen()),
      ),
      GoRoute(
        path: '/kepala-cabang/reports',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const WorkReportScreen()),
      ),
      GoRoute(
        path: '/kepala-cabang/profile',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const ProfileScreen()),
      ),

      // ── Admin ──────────────────────────────────────────────
      GoRoute(
        path: '/admin',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const AdminDashboardScreen()),
      ),
      GoRoute(
        path: '/admin/inventory',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const InventoryScreen()),
      ),
      GoRoute(
        path: '/admin/tasks',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const TaskScreen()),
      ),
      GoRoute(
        path: '/admin/profile',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const ProfileScreen()),
      ),

      // ── Sales ──────────────────────────────────────────────
      GoRoute(
        path: '/sales',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const SalesDashboardScreen()),
      ),
      GoRoute(
        path: '/sales/prospects',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const ProspectScreen()),
      ),
      GoRoute(
        path: '/sales/campaigns',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const CampaignScreen()),
      ),
      GoRoute(
        path: '/sales/profile',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const ProfileScreen()),
      ),

      // ── Driver ─────────────────────────────────────────────
      GoRoute(
        path: '/driver',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const DriverDashboardScreen()),
      ),
      GoRoute(
        path: '/driver/deliveries',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const DriverDashboardScreen()),
      ),
      GoRoute(
        path: '/driver/attendance',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const AttendanceScreen()),
      ),
      GoRoute(
        path: '/driver/profile',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const ProfileScreen()),
      ),

      // ── Job Desk ──────────────────────────────────────────
      // Employee routes
      GoRoute(
        path: '/jobdesk',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const MyJobDeskScreen()),
      ),
      GoRoute(
        path: '/jobdesk/history',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const MyJobDeskScreen()), // TODO: Create history screen
      ),
      GoRoute(
        path: '/jobdesk/today',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const MyJobDeskScreen()), // TODO: Create submission screen
      ),
      
      // Owner/Superadmin routes
      GoRoute(
        path: '/jobdesk/templates',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const JobDeskTemplateListScreen()),
      ),
      GoRoute(
        path: '/jobdesk/monitoring',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const JobDeskMonitoringScreen()),
      ),
      
      // PIC/Verification routes
      GoRoute(
        path: '/jobdesk/pic',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const PicDashboardScreen()),
      ),
      GoRoute(
        path: '/jobdesk/verify/:id',
        builder: (_, state) => PhotoReviewScreen(submissionId: state.pathParameters['id']!),
      ),
      
      // Task Submission route (for employees to submit proof)
      GoRoute(
        path: '/jobdesk/submit/:taskId',
        builder: (_, state) => TaskSubmissionScreen(
          taskId: state.pathParameters['taskId']!,
          submissionId: state.uri.queryParameters['submission'],
        ),
      ),
      
      // ── Super Admin ───────────────────────────────────────
      GoRoute(
        path: '/superadmin',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const SuperAdminDashboardScreen()),
      ),
      GoRoute(
        path: '/superadmin/users/create',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const SuperAdminDashboardScreen()), // TODO: Create user form
      ),
      GoRoute(
        path: '/superadmin/users/:id/edit',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const SuperAdminDashboardScreen()), // TODO: Edit user form
      ),
      GoRoute(
        path: '/superadmin/settings',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const SuperAdminDashboardScreen()), // TODO: Settings screen
      ),
      GoRoute(
        path: '/superadmin/security/:id',
        builder: (_, state) => AppScaffold(currentRoute: state.matchedLocation, child: const SuperAdminDashboardScreen()), // TODO: Security detail
      ),

      // ── Job Desk Activity Report ────────────────────────────
      GoRoute(
        path: '/jobdesk/report',
        builder: (_, state) {
          // Get role from query params (for demo purposes)
          final roleStr = state.uri.queryParameters['role'] ?? 'owner';
          final role = _parseRole(roleStr);
          final branchId = state.uri.queryParameters['branch'];
          return JobDeskActivityReportScreen(
            userRole: role,
            branchId: branchId,
          );
        },
      ),

      // ── Shared ─────────────────────────────────────────────
      GoRoute(
        path: '/notifications',
        builder: (_, state) => const NotificationScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Halaman tidak ditemukan: ${state.error}')),
    ),
  );
});

String _dashboardRoute(UserRole role) {
  switch (role) {
    case UserRole.superAdmin:
      return '/superadmin';
    case UserRole.owner:
      return '/owner';
    case UserRole.kepalaCabang:
      return '/kepala-cabang';
    case UserRole.admin:
      return '/admin';
    case UserRole.sales:
      return '/sales';
    case UserRole.driver:
      return '/driver';
  }
}

UserRole _parseRole(String roleStr) {
  switch (roleStr.toLowerCase()) {
    case 'superadmin':
    case 'super_admin':
      return UserRole.superAdmin;
    case 'owner':
      return UserRole.owner;
    case 'kepalacabang':
    case 'kepala_cabang':
      return UserRole.kepalaCabang;
    case 'admin':
      return UserRole.admin;
    case 'sales':
      return UserRole.sales;
    case 'driver':
      return UserRole.driver;
    default:
      return UserRole.owner;
  }
}
