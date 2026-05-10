import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/shared/widgets/app_scaffold.dart';
import '../../work/models/work_report_models.dart';

/// ============================================================
/// ✅ WORK REPORT APPROVAL SCREEN
/// Kepala Cabang - Review dan Approval Laporan Kerja Staff
/// ============================================================

class WorkReportApprovalScreen extends ConsumerStatefulWidget {
  const WorkReportApprovalScreen({super.key});

  @override
  ConsumerState<WorkReportApprovalScreen> createState() => _WorkReportApprovalScreenState();
}

class _WorkReportApprovalScreenState extends ConsumerState<WorkReportApprovalScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedBranch = 'Semua Cabang';
  
  final List<String> _branches = [
    'Semua Cabang',
    'Sam Ratulangi',
    'Bahu',
    'Malahayati',
    'Tondano',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/work-reports/approval',
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Approval Laporan Kerja',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Review laporan dari staff',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.7),
            tabs: const [
              Tab(text: 'Menunggu'),
              Tab(text: 'Sudah Direview'),
            ],
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              itemBuilder: (context) => _branches.map((branch) {
                return PopupMenuItem(
                  value: branch,
                  child: Row(
                    children: [
                      if (_selectedBranch == branch)
                        const Icon(Icons.check, size: 18, color: AppColors.primary),
                      if (_selectedBranch == branch)
                        const SizedBox(width: 8),
                      Text(branch),
                    ],
                  ),
                );
              }).toList(),
              onSelected: (value) {
                setState(() => _selectedBranch = value);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Stats Summary
            _buildStatsSection(),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPendingTab(),
                  _buildReviewedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B8EEF), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Menunggu', '12', Icons.pending_actions),
          ),
          Expanded(
            child: _buildStatItem('Disetujui', '48', Icons.check_circle),
          ),
          Expanded(
            child: _buildStatItem('Ditolak', '3', Icons.cancel),
          ),
          Expanded(
            child: _buildStatItem('Total Hari Ini', '63', Icons.assignment),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPendingTab() {
    final pendingReports = _getDummyPendingReports();
    
    if (pendingReports.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline,
        title: 'Semua Laporan Sudah Direview',
        subtitle: 'Tidak ada laporan yang menunggu approval',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingReports.length,
      itemBuilder: (context, index) {
        final report = pendingReports[index];
        return _buildPendingReportCard(report);
      },
    );
  }

  Widget _buildReviewedTab() {
    final reviewedReports = _getDummyReviewedReports();
    
    if (reviewedReports.isEmpty) {
      return _buildEmptyState(
        icon: Icons.folder_open,
        title: 'Belum Ada Laporan',
        subtitle: 'Laporan yang sudah direview akan muncul di sini',
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviewedReports.length,
      itemBuilder: (context, index) {
        final report = reviewedReports[index];
        return _buildReviewedReportCard(report);
      },
    );
  }

  Widget _buildPendingReportCard(WorkReport report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    report.userName.substring(0, 1),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        '${report.role} • ${report.branchName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Menunggu',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Report Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(report.reportDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Content Preview
            Text(
              report.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            
            // Photo indicator
            if (report.photoUrls != null && report.photoUrls!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.photo, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    '${report.photoUrls!.length} foto dilampirkan',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewReportDetail(report),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('Lihat Detail'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showApprovalDialog(report),
                    icon: const Icon(Icons.rate_review, size: 18),
                    label: const Text('Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewedReportCard(WorkReport report) {
    final isApproved = report.status == WorkReportStatus.approved;
    final statusColor = isApproved ? AppColors.success : AppColors.error;
    final statusIcon = isApproved ? Icons.check_circle : Icons.cancel;
    final statusText = isApproved ? 'Disetujui' : 'Ditolak';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.divider),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(statusIcon, color: statusColor, size: 20),
        ),
        title: Text(
          report.userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              DateFormat('dd MMM yyyy', 'id_ID').format(report.reportDate),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              report.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13),
            ),
            if (report.rejectionReason != null) ...[
              const SizedBox(height: 4),
              Text(
                'Alasan: ${report.rejectionReason}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ],
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              fontSize: 11,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        onTap: () => _viewReportDetail(report),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  List<WorkReport> _getDummyPendingReports() {
    final now = DateTime.now();
    return [
      WorkReport(
        id: 'wr001',
        userId: 'u001',
        userName: 'Budi Santoso',
        branchId: 'b001',
        branchName: 'Sam Ratulangi',
        role: 'Sales',
        content: 'Hari ini berhasil melakukan kunjungan ke 5 toko di area Bahu. Mendapatkan 2 prospek baru yang potensial. Melakukan follow-up pada 3 calon konsumen existing.',
        photoUrls: ['https://picsum.photos/400/300', 'https://picsum.photos/400/301'],
        status: WorkReportStatus.pending,
        reportDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      WorkReport(
        id: 'wr002',
        userId: 'u002',
        userName: 'Siti Aminah',
        branchId: 'b001',
        branchName: 'Sam Ratulangi',
        role: 'Driver',
        content: 'Mengantar 8 pesanan hari ini dengan jarak total 45 km. Semua pengiriman tepat waktu dan tidak ada kendala. Melakukan perawatan rutin kendaraan sore ini.',
        status: WorkReportStatus.pending,
        reportDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      WorkReport(
        id: 'wr003',
        userId: 'u003',
        userName: 'Ahmad Fauzi',
        branchId: 'b002',
        branchName: 'Bahu',
        role: 'Admin',
        content: 'Melakukan stock opname pagi dan sore. Input 25 transaksi hari ini. Membuat laporan penjualan harian dan mengirim ke pusat. Tidak ada masalah dengan kas.',
        photoUrls: ['https://picsum.photos/400/302'],
        status: WorkReportStatus.pending,
        reportDate: now,
        createdAt: now,
      ),
    ];
  }

  List<WorkReport> _getDummyReviewedReports() {
    final now = DateTime.now();
    return [
      WorkReport(
        id: 'wr004',
        userId: 'u004',
        userName: 'Dewi Lestari',
        branchId: 'b001',
        branchName: 'Sam Ratulangi',
        role: 'Sales',
        content: 'Berhasil closing 3 transaksi hari ini dengan total nilai Rp 45 juta. Kunjungan ke 4 prospek baru di area Tondano.',
        status: WorkReportStatus.approved,
        reviewedBy: 'kc001',
        reviewerName: 'Pak Hendra',
        reportDate: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 2)),
        reviewedAt: now.subtract(const Duration(days: 1)),
      ),
      WorkReport(
        id: 'wr005',
        userId: 'u005',
        userName: 'Eko Prasetyo',
        branchId: 'b001',
        branchName: 'Sam Ratulangi',
        role: 'Driver',
        content: 'Hanya mengantar 3 pesanan hari ini. Alasan tidak jelas kenapa produktivitas rendah.',
        status: WorkReportStatus.rejected,
        reviewedBy: 'kc001',
        reviewerName: 'Pak Hendra',
        rejectionReason: 'Penjelasan terlalu singkat, mohon berikan detail lebih lengkap',
        reportDate: now.subtract(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 3)),
        reviewedAt: now.subtract(const Duration(days: 2)),
      ),
    ];
  }

  void _viewReportDetail(WorkReport report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Header
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Text(
                          report.userName.substring(0, 1),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              report.userName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${report.role} • ${report.branchName}',
                              style: TextStyle(
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Date
                  _buildDetailSection(
                    'Tanggal Laporan',
                    DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(report.reportDate),
                  ),
                  
                  // Content
                  _buildDetailSection('Kegiatan', report.content),
                  
                  // Achievements
                  if (report.achievements != null)
                    _buildDetailSection('Pencapaian', report.achievements!),
                  
                  // Challenges
                  if (report.challenges != null)
                    _buildDetailSection('Kendala', report.challenges!),
                  
                  // Next Plan
                  if (report.nextPlan != null)
                    _buildDetailSection('Rencana Selanjutnya', report.nextPlan!),
                  
                  // Photos
                  if (report.photoUrls != null && report.photoUrls!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Foto Bukti',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHint,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: report.photoUrls!.map((url) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons for pending reports
                  if (report.status == WorkReportStatus.pending) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showApprovalDialog(report);
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Setujui'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _showRejectionDialog(report);
                            },
                            icon: const Icon(Icons.close),
                            label: const Text('Tolak'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textHint,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showApprovalDialog(WorkReport report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setujui Laporan'),
        content: Text(
          'Setujui laporan kerja dari ${report.userName} untuk tanggal ${DateFormat('dd MMMM yyyy', 'id_ID').format(report.reportDate)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _approveReport(report.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: Colors.white,
            ),
            child: const Text('Setujui'),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog(WorkReport report) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Laporan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Berikan alasan penolakan untuk laporan ${report.userName}:',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Contoh: Laporan kurang detail, mohon lengkapi...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alasan penolakan harus diisi'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              _rejectReport(report.id, reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );
  }

  void _approveReport(String reportId) {
    // TODO: Call API to approve report
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan berhasil disetujui'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {}); // Refresh UI
  }

  void _rejectReport(String reportId, String reason) {
    // TODO: Call API to reject report
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Laporan ditolak. Alasan: $reason'),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {}); // Refresh UI
  }
}
