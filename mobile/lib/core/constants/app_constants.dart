class AppConstants {
  AppConstants._();

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  static const int dashboardRefreshMinutes = 5;
  static const int socialMediaRefreshHours = 6;

  static const double geofenceDefaultRadiusMeters = 100.0;

  static const int otpExpiryMinutes = 15;
  static const int maxOtpAttemptsPerHour = 3;
  static const int maxLoginAttemptsPerWindow = 5;

  static const int whatsappMaxMessagesPerMinute = 20;
  static const int maxFileUploadsPerMinute = 10;
  static const int maxPdfExportsPerMinute = 5;

  static const int signedUrlDirectTtlMinutes = 15;
  static const int signedUrlReportTtlMinutes = 60;

  static const int chatRetentionDays = 90;
  static const int workReportEscalationHours = 48;
}

class ApiEndpoints {
  ApiEndpoints._();

  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String passwordResetRequest = '/auth/password-reset/request';
  static const String passwordResetVerify = '/auth/password-reset/verify';

  static const String ownerDashboard = '/owner/dashboard';
  static const String ownerBranchDetail = '/owner/branches';
  static const String ownerPerformanceRankings = '/owner/performance/rankings';

  static const String kepalaCabangDashboard = '/kepala-cabang/dashboard';
  static const String adminDashboard = '/admin/dashboard';
  static const String salesDashboard = '/sales/dashboard';
  static const String driverDashboard = '/driver/dashboard';

  static const String inventoryItems = '/inventory/items';
  static const String inventoryStockAdd = '/inventory/stock/add';
  static const String inventoryStockRemove = '/inventory/stock/remove';
  static const String inventoryAvailability = '/inventory/availability';

  static const String attendanceCheckIn = '/attendance/check-in';
  static const String attendanceCheckOut = '/attendance/check-out';

  static const String tasks = '/tasks';
  static const String workReports = '/work-reports';
  static const String deliveries = '/deliveries';

  static const String prospects = '/prospects';
  static const String campaigns = '/campaigns';
}
