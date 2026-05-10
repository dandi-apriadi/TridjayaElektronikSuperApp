import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/penalty_model.dart';

/// ============================================================
/// ⚠️ PENALTY / FINES SCREEN
/// Detail denda dan pelanggaran karyawan
/// ============================================================

class PenaltyScreen extends ConsumerStatefulWidget {
  const PenaltyScreen({super.key});

  @override
  ConsumerState<PenaltyScreen> createState() => _PenaltyScreenState();
}

class _PenaltyScreenState extends ConsumerState<PenaltyScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  
  // Dummy data - replace with actual data from provider
  List<Penalty> _penalties = [];
  MonthlyPenaltySummary? _currentMonthSummary;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadPenaltyData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadPenaltyData() {
    // TODO: Load from provider
    setState(() {
      _penalties = _getDummyPenalties();
      _currentMonthSummary = _calculateMonthlySummary();
      _isLoading = false;
    });
  }

  MonthlyPenaltySummary _calculateMonthlySummary() {
    final now = DateTime.now();
    final currentMonthPenalties = _penalties.where((p) => 
      p.createdAt.month == now.month && p.createdAt.year == now.year
    ).toList();

    return MonthlyPenaltySummary(
      month: _getMonthName(now.month),
      year: now.year,
      penalties: currentMonthPenalties,
      totalAmount: currentMonthPenalties.fold(0, (sum, p) => sum + p.amount),
      paidCount: currentMonthPenalties.where((p) => p.isPaid).length,
      pendingCount: currentMonthPenalties.where((p) => p.isPending).length,
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  List<Penalty> _getDummyPenalties() {
    return [
      Penalty(
        id: 'P001',
        userId: 'U001',
        userName: 'Budi Santoso',
        violation: Violation(
          id: 'V001',
          type: ViolationType.lateSubmission,
          description: 'Submit task "Kirim 200 Undangan" terlambat 2 hari dari deadline',
          date: DateTime.now().subtract(const Duration(days: 5)),
          taskId: 'T001',
          taskName: 'Kirim 200 Undangan',
          notes: 'Task harusnya selesai tanggal 3 Mei 2026, baru disubmit tanggal 5 Mei 2026',
        ),
        amount: 50000,
        status: PenaltyStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Penalty(
        id: 'P002',
        userId: 'U001',
        userName: 'Budi Santoso',
        violation: Violation(
          id: 'V002',
          type: ViolationType.noProof,
          description: 'Task "Post Video TikTok" tidak disertai bukti screenshot',
          date: DateTime.now().subtract(const Duration(days: 12)),
          taskId: 'T002',
          taskName: 'Post Video TikTok Harian',
          notes: 'Karyawan mengklaim sudah post tapi tidak ada bukti link atau screenshot',
        ),
        amount: 30000,
        status: PenaltyStatus.confirmed,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      Penalty(
        id: 'P003',
        userId: 'U001',
        userName: 'Budi Santoso',
        violation: Violation(
          id: 'V003',
          type: ViolationType.incompleteTask,
          description: 'Target undangan hanya tercapai 150 dari 200 (75%)',
          date: DateTime.now().subtract(const Duration(days: 20)),
          taskId: 'T003',
          taskName: 'Sebarkan Undangan Event',
          notes: 'Target 200 undangan, yang tercapai hanya 150 undangan',
        ),
        amount: 25000,
        status: PenaltyStatus.paid,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        paidAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
      Penalty(
        id: 'P004',
        userId: 'U001',
        userName: 'Budi Santoso',
        violation: Violation(
          id: 'V004',
          type: ViolationType.fakeProof,
          description: 'Screenshot bukti pengiriman terdeteksi hasil edit/manipulasi',
          date: DateTime.now().subtract(const Duration(days: 28)),
          taskId: 'T004',
          taskName: 'Kirim Broadcast WhatsApp',
          notes: 'Bukti screenshot teridentifikasi sebagai hasil edit Photoshop',
        ),
        amount: 100000,
        status: PenaltyStatus.waived,
        createdAt: DateTime.now().subtract(const Duration(days: 28)),
        verifiedBy: 'Kepala Cabang - Pak Ahmad',
        notes: 'Dibebaskan karena sudah menjelaskan dan melengkapi bukti asli',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Denda & Pelanggaran',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: 'Ringkasan', icon: Icon(Icons.dashboard)),
            Tab(text: 'Riwayat', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards(),
          
          const SizedBox(height: 24),
          
          // Violation Types Info
          _buildViolationTypesInfo(),
          
          const SizedBox(height: 24),
          
          // Recent Penalties
          if (_penalties.isNotEmpty) ...[
            _buildSectionHeader('Pelanggaran Terbaru'),
            const SizedBox(height: 12),
            _buildRecentPenaltiesList(),
          ],
          
          const SizedBox(height: 24),
          
          // Penalty Estimation Info
          _buildPenaltyEstimationInfo(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Denda',
                value: _currentMonthSummary?.formattedAmount ?? 'Rp 0',
                icon: Icons.money_off,
                color: AppColors.error,
                subtitle: 'Bulan ini',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Menunggu',
                value: _currentMonthSummary?.pendingAmount.toStringAsFixed(0) ?? '0',
                prefix: 'Rp ',
                icon: Icons.pending_actions,
                color: AppColors.warning,
                subtitle: '${_currentMonthSummary?.pendingCount ?? 0} kasus',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Sudah Dibayar',
                value: _currentMonthSummary?.paidAmount.toStringAsFixed(0) ?? '0',
                prefix: 'Rp ',
                icon: Icons.check_circle,
                color: AppColors.success,
                subtitle: '${_currentMonthSummary?.paidCount ?? 0} kasus',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Pelanggaran',
                value: '${_currentMonthSummary?.violationCount ?? 0}',
                icon: Icons.warning_amber,
                color: AppColors.info,
                subtitle: 'Kasus bulan ini',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    String? prefix,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${prefix ?? ''}$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationTypesInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jenis Pelanggaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...ViolationType.values.map((type) => _buildViolationTypeItem(type)),
        ],
      ),
    );
  }

  Widget _buildViolationTypeItem(ViolationType type) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: type.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(type.icon, color: type.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  type.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getSeverityColor(type.severity).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _getSeverityLabel(type.severity),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getSeverityColor(type.severity),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(int severity) {
    switch (severity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      case 4:
        return Colors.red.shade700;
      default:
        return Colors.grey;
    }
  }

  String _getSeverityLabel(int severity) {
    switch (severity) {
      case 1:
        return 'Ringan';
      case 2:
        return 'Sedang';
      case 3:
        return 'Berat';
      case 4:
        return 'Sangat Berat';
      default:
        return '-';
    }
  }

  Widget _buildRecentPenaltiesList() {
    final recent = _penalties.take(3).toList();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: recent.asMap().entries.map((entry) {
          final index = entry.key;
          final penalty = entry.value;
          return Column(
            children: [
              _buildPenaltyListItem(penalty),
              if (index < recent.length - 1)
                const Divider(height: 1, indent: 72),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPenaltyListItem(Penalty penalty) {
    return InkWell(
      onTap: () => _showPenaltyDetail(penalty),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: penalty.violation.type.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                penalty.violation.type.icon,
                color: penalty.violation.type.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    penalty.violation.type.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    penalty.formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  penalty.formattedAmount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: penalty.isPaid ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: penalty.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    penalty.status.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: penalty.status.color,
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

  void _showPenaltyDetail(Penalty penalty) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: penalty.violation.type.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              penalty.violation.type.icon,
                              color: penalty.violation.type.color,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  penalty.violation.type.label,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: penalty.status.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    penalty.status.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: penalty.status.color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Amount Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: penalty.isPaid ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: penalty.isPaid ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Jumlah Denda',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              penalty.formattedAmount,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: penalty.isPaid ? AppColors.success : AppColors.error,
                              ),
                            ),
                            if (penalty.paidAt != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Dibayar: ${penalty.paidAt!.day}/${penalty.paidAt!.month}/${penalty.paidAt!.year}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Detail Section
                      _buildDetailSection('Detail Pelanggaran', [
                        _buildDetailItem('Tanggal Kejadian', penalty.violation.formattedDate),
                        if (penalty.violation.taskName != null)
                          _buildDetailItem('Task', penalty.violation.taskName!),
                        _buildDetailItem('Deskripsi', penalty.violation.description),
                        if (penalty.violation.notes != null)
                          _buildDetailItem('Catatan', penalty.violation.notes!),
                      ]),
                      
                      const SizedBox(height: 20),
                      
                      // Severity Badge
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _getSeverityColor(penalty.violation.type.severity).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _getSeverityColor(penalty.violation.type.severity).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: _getSeverityColor(penalty.violation.type.severity),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tingkat Pelanggaran',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getSeverityLabel(penalty.violation.type.severity),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: _getSeverityColor(penalty.violation.type.severity),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      if (penalty.verifiedBy != null) ...[
                        const SizedBox(height: 20),
                        _buildDetailSection('Verifikasi', [
                          _buildDetailItem('Diverifikasi oleh', penalty.verifiedBy!),
                        ]),
                      ],
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPenaltyEstimationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.info, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Informasi Denda',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Besaran denda ditentukan berdasarkan jenis dan tingkat pelanggaran:',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildEstimationRow('Ringan', 'Rp 25.000 - Rp 50.000', Colors.green),
          _buildEstimationRow('Sedang', 'Rp 50.000 - Rp 100.000', Colors.orange),
          _buildEstimationRow('Berat', 'Rp 100.000 - Rp 250.000', Colors.red),
          _buildEstimationRow('Sangat Berat', 'Rp 250.000+', Colors.red.shade700),
        ],
      ),
    );
  }

  Widget _buildEstimationRow(String level, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            level,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const Spacer(),
          Text(
            range,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    if (_penalties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: AppColors.success.withOpacity(0.5)),
            const SizedBox(height: 16),
            const Text(
              'Tidak Ada Pelanggaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Anda tidak memiliki riwayat pelanggaran',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _penalties.length,
      itemBuilder: (context, index) {
        final penalty = _penalties[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPenaltyCard(penalty),
        );
      },
    );
  }

  Widget _buildPenaltyCard(Penalty penalty) {
    return InkWell(
      onTap: () => _showPenaltyDetail(penalty),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.sm,
          border: Border.all(
            color: penalty.status.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: penalty.violation.type.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    penalty.violation.type.icon,
                    color: penalty.violation.type.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        penalty.violation.type.label,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        penalty.formattedDate,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: penalty.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    penalty.status.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: penalty.status.color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              penalty.violation.description,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jumlah Denda:',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  penalty.formattedAmount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: penalty.isPaid ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}
