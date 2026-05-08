import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../shared/widgets/stat_card.dart';

class WorkReportScreen extends ConsumerStatefulWidget {
  const WorkReportScreen({super.key});

  @override
  ConsumerState<WorkReportScreen> createState() => _WorkReportScreenState();
}

class _WorkReportScreenState extends ConsumerState<WorkReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_WorkReport> _myReports = [
    _WorkReport('WR-001', 'Laporan Kerja Senin', 'Selesaikan input stok Aki GS dan follow up 3 prospek baru.', 'approved', '5 Mei 2025', 'Bagus, lanjutkan!'),
    _WorkReport('WR-002', 'Laporan Kerja Selasa', 'Update data inventori dan koordinasi pengiriman ke Cibubur.', 'pending', '6 Mei 2025', null),
    _WorkReport('WR-003', 'Laporan Kerja Rabu', 'Meeting dengan supplier Aki GS, negosiasi harga bulk.', 'rejected', '7 Mei 2025', 'Kurang detail, mohon dilengkapi.'),
    _WorkReport('WR-004', 'Laporan Kerja Kamis', 'Rekap stok akhir bulan dan persiapan laporan ke KaCab.', 'pending', '8 Mei 2025', null),
  ];

  final List<_WorkReport> _pendingApprovals = [
    _WorkReport('WR-005', 'Laporan Kerja — Budi Santoso', 'Follow up 5 prospek baru, tutup 2 deal Aki GS.', 'pending', '8 Mei 2025', null),
    _WorkReport('WR-006', 'Laporan Kerja — Siti Rahayu', 'Campaign WhatsApp blast 45 prospek, respon 12 orang.', 'pending', '8 Mei 2025', null),
    _WorkReport('WR-007', 'Laporan Kerja — Rudi Hartono', 'Selesaikan 4 pengiriman, 1 gagal karena alamat tidak ditemukan.', 'pending', '7 Mei 2025', null),
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

  Color _statusColor(String s) {
    switch (s) {
      case 'approved': return AppColors.success;
      case 'rejected': return AppColors.error;
      default: return AppColors.warning;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'approved': return 'Disetujui';
      case 'rejected': return 'Ditolak';
      default: return 'Menunggu';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isApprover = user?.role == UserRole.kepalaCabang || user?.role == UserRole.owner;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSubmitDialog(context),
        icon: const Icon(Icons.edit_note_rounded),
        label: const Text('Buat Laporan'),
        backgroundColor: AppColors.primary,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text('Laporan Kerja', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: isApprover
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(46),
                    child: Container(
                      color: AppColors.surface,
                      child: TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSecondary,
                        indicatorColor: AppColors.primary,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: AppTextStyles.bodyMedium,
                        tabs: [
                          const Tab(text: 'Laporan Saya'),
                          Tab(text: 'Approval (${_pendingApprovals.length})'),
                        ],
                      ),
                    ),
                  )
                : null,
          ),
        ],
        body: isApprover
            ? TabBarView(
                controller: _tabController,
                children: [
                  _buildMyReportsList(context),
                  _buildApprovalList(context),
                ],
              )
            : _buildMyReportsList(context),
      ),
    );
  }

  Widget _buildMyReportsList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _myReports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _buildReportCard(context, _myReports[i], isOwn: true),
    );
  }

  Widget _buildApprovalList(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.warningBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(children: [
            const Icon(Icons.pending_actions_outlined, color: AppColors.warning, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text('${_pendingApprovals.length} laporan menunggu review Anda',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.warning))),
          ]),
        ),
      ),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: _pendingApprovals.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _buildReportCard(context, _pendingApprovals[i], isOwn: false),
        ),
      ),
    ]);
  }

  Widget _buildReportCard(BuildContext context, _WorkReport report, {required bool isOwn}) {
    final sc = _statusColor(report.status);
    return GestureDetector(
      onTap: () => _showReportDetail(context, report, isOwn: isOwn),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.sm,
          border: Border.all(color: sc.withOpacity(0.2)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: sc.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(children: [
              Container(width: 3, height: 32, decoration: BoxDecoration(color: sc, borderRadius: BorderRadius.circular(2))),
              const SizedBox(width: 10),
              Expanded(child: Text(report.title, style: AppTextStyles.bodyMedium)),
              StatusBadge(label: _statusLabel(report.status), color: sc),
            ]),
          ),
          Padding(padding: const EdgeInsets.fromLTRB(14, 10, 14, 14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(report.content, style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(report.date, style: AppTextStyles.caption),
              if (report.reviewComment != null) ...[
                const SizedBox(width: 10),
                const Icon(Icons.comment_outlined, size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(child: Text(report.reviewComment!, style: AppTextStyles.caption, overflow: TextOverflow.ellipsis)),
              ],
            ]),
            if (!isOwn && report.status == 'pending') ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleApproval(context, report, false),
                    icon: const Icon(Icons.close_rounded, size: 15),
                    label: const Text('Tolak'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      minimumSize: const Size(0, 38),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleApproval(context, report, true),
                    icon: const Icon(Icons.check_rounded, size: 15),
                    label: const Text('Setujui'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      minimumSize: const Size(0, 38),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
              ]),
            ],
          ])),
        ]),
      ),
    );
  }

  void _handleApproval(BuildContext context, _WorkReport report, bool approved) {
    showDialog(
      context: context,
      builder: (ctx) {
        final commentCtrl = TextEditingController();
        return AlertDialog(
          title: Text(approved ? 'Setujui Laporan' : 'Tolak Laporan'),
          content: TextFormField(
            controller: commentCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: approved ? 'Komentar (opsional)' : 'Alasan penolakan',
              hintText: approved ? 'Bagus, lanjutkan...' : 'Kurang detail...',
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _pendingApprovals.remove(report));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(approved ? 'Laporan disetujui' : 'Laporan ditolak'),
                  backgroundColor: approved ? AppColors.success : AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ));
              },
              style: ElevatedButton.styleFrom(backgroundColor: approved ? AppColors.success : AppColors.error),
              child: Text(approved ? 'Setujui' : 'Tolak'),
            ),
          ],
        );
      },
    );
  }

  void _showReportDetail(BuildContext context, _WorkReport report, {required bool isOwn}) {
    final sc = _statusColor(report.status);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Row(children: [
              StatusBadge(label: _statusLabel(report.status), color: sc),
              const SizedBox(width: 8),
              Text(report.id, style: AppTextStyles.caption),
            ]),
            const SizedBox(height: 10),
            Text(report.title, style: AppTextStyles.heading3),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(report.date, style: AppTextStyles.caption),
            ]),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
              child: Text(report.content, style: AppTextStyles.body),
            ),
            if (report.reviewComment != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: sc.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: sc.withOpacity(0.2)),
                ),
                child: Row(children: [
                  Icon(Icons.comment_outlined, size: 16, color: sc),
                  const SizedBox(width: 8),
                  Expanded(child: Text(report.reviewComment!, style: AppTextStyles.body)),
                ]),
              ),
            ],
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }

  void _showSubmitDialog(BuildContext context) {
    final contentCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buat Laporan Kerja'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: contentCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Laporan',
                hintText: 'Ceritakan pekerjaan yang sudah Anda lakukan hari ini...',
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lampirkan foto — Coming Soon'), behavior: SnackBarBehavior.floating)),
              child: Container(
                height: 60, width: double.infinity,
                decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.attach_file_rounded, color: AppColors.textHint),
                  SizedBox(width: 8),
                  Text('Lampirkan Foto/Dokumen', style: AppTextStyles.caption),
                ]),
              ),
            ),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Laporan berhasil dikirim'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }
}

class _WorkReport {
  final String id, title, content, status, date;
  final String? reviewComment;
  const _WorkReport(this.id, this.title, this.content, this.status, this.date, this.reviewComment);
}
