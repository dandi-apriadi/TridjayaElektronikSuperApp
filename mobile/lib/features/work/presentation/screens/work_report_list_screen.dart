import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../models/work_report_models.dart';

/// ============================================================
/// 📋 WORK REPORT LIST SCREEN
/// Riwayat Laporan Kerja Harian (IDG)
/// ============================================================

class WorkReportListScreen extends ConsumerStatefulWidget {
  const WorkReportListScreen({super.key});

  @override
  ConsumerState<WorkReportListScreen> createState() => _WorkReportListScreenState();
}

class _WorkReportListScreenState extends ConsumerState<WorkReportListScreen> {
  String _selectedFilter = 'Semua';
  String _selectedMonth = 'Bulan Ini';
  
  final List<String> _filters = ['Semua', 'Draft', 'Menunggu', 'Disetujui', 'Ditolak'];
  final List<String> _months = ['Bulan Ini', 'Bulan Lalu', '2 Bulan Lalu'];
  
  // Dummy data
  List<WorkReport> get _dummyReports {
    final now = DateTime.now();
    return [
      WorkReport(
        id: 'wr001',
        userId: 'u001',
        userName: 'Ahmad Santoso',
        branchId: 'b001',
        branchName: 'Cabang Pusat',
        role: 'Sales',
        content: 'Hari ini saya berhasil melakukan kunjungan ke 5 prospek dan mendapatkan 3 calon konsumen potensial. Melakukan follow-up pada 10 prospek yang sudah ada.',
        achievements: 'Mendapatkan 3 prospek baru',
        challenges: 'Cuaca hujan menyulitkan perjalanan',
        nextPlan: 'Besok akan fokus pada closing 2 prospek prioritas',
        photoUrls: ['https://picsum.photos/400/300'],
        status: WorkReportStatus.approved,
        reviewedBy: 'kc001',
        reviewerName: 'Pak Hendra',
        reportDate: now.subtract(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 1)),
        reviewedAt: now.subtract(const Duration(hours: 20)),
      ),
      WorkReport(
        id: 'wr002',
        userId: 'u001',
        userName: 'Ahmad Santoso',
        branchId: 'b001',
        branchName: 'Cabang Pusat',
        role: 'Sales',
        content: 'Mengikuti training produk baru dari tim marketing. Membuat laporan penjualan mingguan.',
        status: WorkReportStatus.submitted,
        reportDate: now,
        createdAt: now,
      ),
      WorkReport(
        id: 'wr003',
        userId: 'u001',
        userName: 'Ahmad Santoso',
        branchId: 'b001',
        branchName: 'Cabang Pusat',
        role: 'Sales',
        content: 'Libur cuti tahunan.',
        status: WorkReportStatus.draft,
        reportDate: now.subtract(const Duration(days: 5)),
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/work-reports',
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Riwayat Laporan Kerja',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'IDG - Input Data Giat',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: _showFilterBottomSheet,
            ),
          ],
        ),
        body: Column(
          children: [
            // Stats Section
            _buildStatsSection(),
            
            // Filter Chips
            _buildFilterChips(),
            
            // List
            Expanded(
              child: _buildReportList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/work-reports/new'),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add),
          label: const Text('Buat Laporan'),
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Total', '12', Icons.assignment),
              ),
              Expanded(
                child: _buildStatItem('Disetujui', '8', Icons.check_circle),
              ),
              Expanded(
                child: _buildStatItem('Pending', '3', Icons.pending),
              ),
              Expanded(
                child: _buildStatItem('Ditolak', '1', Icons.cancel),
              ),
            ],
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
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(filter),
                onSelected: (selected) {
                  setState(() => _selectedFilter = filter);
                },
                backgroundColor: Colors.white,
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReportList() {
    final reports = _dummyReports;
    
    if (reports.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(WorkReport report) {
    Color statusColor;
    IconData statusIcon;
    
    switch (report.status) {
      case WorkReportStatus.approved:
        statusColor = AppColors.success;
        statusIcon = Icons.verified;
        break;
      case WorkReportStatus.submitted:
      case WorkReportStatus.underReview:
        statusColor = AppColors.warning;
        statusIcon = Icons.pending;
        break;
      case WorkReportStatus.rejected:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        break;
      case WorkReportStatus.draft:
        statusColor = Colors.grey;
        statusIcon = Icons.edit;
        break;
      default:
        statusColor = AppColors.primary;
        statusIcon = Icons.info;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.divider),
      ),
      child: InkWell(
        onTap: () => _showReportDetail(report),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(statusIcon, size: 16, color: statusColor),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      report.statusLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy', 'id_ID').format(report.reportDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Content
              Text(
                report.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              
              if (report.photoUrls != null && report.photoUrls!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.photo, size: 16, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(
                      '${report.photoUrls!.length} foto',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 12),
              
              // Reviewer info (if approved/rejected)
              if (report.reviewerName != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        report.status == WorkReportStatus.approved 
                            ? Icons.check_circle 
                            : Icons.cancel,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${report.status == WorkReportStatus.approved ? 'Disetujui' : 'Ditolak'} oleh ${report.reviewerName}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                            if (report.rejectionReason != null)
                              Text(
                                'Alasan: ${report.rejectionReason}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textHint,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Laporan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Buat laporan kerja harian pertama Anda',
            style: TextStyle(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Periode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ..._months.map((month) => RadioListTile(
                title: Text(month),
                value: month,
                groupValue: _selectedMonth,
                onChanged: (value) {
                  setState(() => _selectedMonth = value!);
                  Navigator.pop(context);
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _showReportDetail(WorkReport report) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
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
                  
                  // Title
                  Text(
                    'Detail Laporan',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(report.reportDate),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Content
                  _buildDetailSection('Kegiatan', report.content),
                  
                  if (report.achievements != null)
                    _buildDetailSection('Pencapaian', report.achievements!),
                  
                  if (report.challenges != null)
                    _buildDetailSection('Kendala', report.challenges!),
                  
                  if (report.nextPlan != null)
                    _buildDetailSection('Rencana Besok', report.nextPlan!),
                  
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
