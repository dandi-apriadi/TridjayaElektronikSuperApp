/// ===========================================
/// API Endpoints Configuration
/// ===========================================
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL configured via environment
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.1.19:8080/api', // Local network (physical device)
  );

  // ===========================================
  // AUTHENTICATION
  // ===========================================
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String passwordResetRequest = '/auth/password-reset/request';
  static const String passwordResetVerify = '/auth/password-reset/verify';

  // ===========================================
  // OWNER
  // ===========================================
  static const String ownerDashboard = '/owner/dashboard';
  static const String ownerSalesRanking = '/owner/sales-ranking';
  static const String ownerBranches = '/owner/branches';
  static String ownerBranchDetail(String id) => '/owner/branches/$id';

  // ===========================================
  // KEPALA CABANG
  // ===========================================
  static const String kcDashboard = '/kepala-cabang/dashboard';
  static const String kcEmployees = '/kepala-cabang/employees';
  static const String kcPendingJobdesk = '/kepala-cabang/jobdesk/pending';
  static String kcApproveJobdesk(String id) => '/kepala-cabang/jobdesk/$id/approve';
  static String kcRejectJobdesk(String id) => '/kepala-cabang/jobdesk/$id/reject';
  static const String kcPendingWorkReports = '/kepala-cabang/work-reports/pending';
  static String kcApproveWorkReport(String id) => '/kepala-cabang/work-reports/$id/approve';
  static String kcRejectWorkReport(String id) => '/kepala-cabang/work-reports/$id/reject';
  static const String kcAttendance = '/kepala-cabang/attendance';

  // ===========================================
  // ADMIN
  // ===========================================
  static const String adminDashboard = '/admin/dashboard';
  static const String adminInventory = '/admin/inventory';
  static const String adminUsers = '/admin/users';

  // ===========================================
  // SALES
  // ===========================================
  static const String salesDashboard = '/sales/dashboard';
  static const String salesProspects = '/sales/prospects';
  static const String salesCampaigns = '/sales/campaigns';

  // ===========================================
  // DRIVER
  // ===========================================
  static const String driverDashboard = '/driver/dashboard';

  // ===========================================
  // SHARED
  // ===========================================
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String attendance = '/attendance';
  static const String leaveRequests = '/leave';
  static const String payroll = '/payroll';
  static const String settings = '/settings';

  // ===========================================
  // JOB DESK
  // ===========================================
  static const String jobdeskTemplates = '/jobdesk/templates';
  static const String jobdeskMyTasks = '/jobdesk/my-tasks';
  static const String jobdeskSubmit = '/jobdesk/submit';

  // ===========================================
  // WORK REPORTS (IDG)
  // ===========================================
  static const String workReports = '/work-reports';
  static const String workReportsSubmit = '/work-reports/submit';
  static String workReportsDetail(String id) => '/work-reports/$id';
}
