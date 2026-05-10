import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/jobdesk_dummy_data.dart';
import '../../models/jobdesk_models.dart';

/// ============================================================
/// 📜 JOB DESK HISTORY SCREEN
/// Riwayat pengisian Job Desk karyawan
/// ============================================================

class JobDeskHistoryScreen extends ConsumerStatefulWidget {
  const JobDeskHistoryScreen({super.key});

  @override
  ConsumerState<JobDeskHistoryScreen> createState() => _JobDeskHistoryScreenState();
}

class _JobDeskHistoryScreenState extends ConsumerState<JobDeskHistoryScreen> {
  String _selectedFilter = 'all'; // all, completed, pending, rejected
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    final submissions = JobDeskDummyData.getDummySubmissionsHistory();
    final filteredSubmissions = _filterSubmissions(submissions);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Riwayat Job Desk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
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
          // Summary Header
          _buildSummaryHeader(submissions),

          // Filter Chips
          _buildFilterChips(),

          // Date Range Indicator
          if (_dateRange != null)
            _buildDateRangeChip(),

          // History List
          Expanded(
            child: filteredSubmissions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredSubmissions.length,
                    itemBuilder: (context, index) {
                      return _buildHistoryCard(filteredSubmissions[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryHeader(List<JobDeskSubmission> submissions) {
    final completed = submissions.where((s) => s.isCompleted || s.isVerified).length;
    final pending = submissions.where((s) => s.isPending).length;
    final rejected = submissions.where((s) => s.isRejected).length;
    final total = submissions.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          _buildSummaryItem(
            label: 'Total',
            value: '$total',
            color: Colors.white,
          ),
          _buildSummaryDivider(),
          _buildSummaryItem(
            label: 'Selesai',
            value: '$completed',
            color: AppColors.success,
          ),
          _buildSummaryDivider(),
          _buildSummaryItem(
            label: 'Pending',
            value: '$pending',
            color: AppColors.warning,
          ),
          _buildSummaryDivider(),
          _buildSummaryItem(
            label: 'Ditolak',
            value: '$rejected',
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Semua', 'all', Icons.format_list_bulleted),
            const SizedBox(width: 8),
            _buildFilterChip('Selesai', 'completed', Icons.check_circle),
            const SizedBox(width: 8),
            _buildFilterChip('Pending', 'pending', Icons.pending_outlined),
            const SizedBox(width: 8),
            _buildFilterChip('Ditolak', 'rejected', Icons.cancel_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: AppColors.primary.withOpacity(0.1),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildDateRangeChip() {
    final format = DateFormat('dd/MM/yyyy');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.date_range, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            '${format.format(_dateRange!.start)} - ${format.format(_dateRange!.end)}',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => setState(() => _dateRange = null),
            child: const Icon(Icons.close, size: 16, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_outlined,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada riwayat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Belum ada pengisian Job Desk\ndengan filter yang dipilih',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(JobDeskSubmission submission) {
    final task = submission.taskItem!;
    final dateFormat = DateFormat('EEEE, dd MMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm');

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (submission.isVerified) {
      statusColor = AppColors.success;
      statusText = 'Terverifikasi';
      statusIcon = Icons.verified;
    } else if (submission.isCompleted) {
      statusColor = AppColors.info;
      statusText = 'Selesai';
      statusIcon = Icons.check_circle;
    } else if (submission.isRejected) {
      statusColor = AppColors.error;
      statusText = 'Ditolak';
      statusIcon = Icons.cancel;
    } else {
      statusColor = AppColors.warning;
      statusText = 'Pending';
      statusIcon = Icons.pending;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: InkWell(
        onTap: () => _showSubmissionDetail(submission),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date & Status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    dateFormat.format(submission.submittedAt!),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Task Info
              Text(
                task.taskName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              if (task.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  task.description!,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Submission Details
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Dikirim: ${timeFormat.format(submission.submittedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                  if (submission.reviewedAt != null) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Reviewer: ${submission.reviewerName ?? 'Admin'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ],
              ),

              // Value Display
              if (submission.actualValue != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Nilai: ${submission.actualValue}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ],

              // Rejection Reason
              if (submission.isRejected && submission.rejectionReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 16,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          submission.rejectionReason!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Photo Indicator
              if (submission.proofPhotoUrl != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.photo_camera,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Ada foto bukti',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _viewPhoto(submission.proofPhotoUrl!),
                      child: const Text('Lihat'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Periode',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Pilih Rentang Tanggal'),
                onTap: () async {
                  Navigator.pop(context);
                  final range = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (range != null) {
                    setState(() => _dateRange = range);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.today),
                title: const Text('Hari Ini'),
                onTap: () {
                  final now = DateTime.now();
                  setState(() => _dateRange = DateTimeRange(
                    start: now,
                    end: now,
                  ));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.date_range),
                title: const Text('7 Hari Terakhir'),
                onTap: () {
                  final now = DateTime.now();
                  setState(() => _dateRange = DateTimeRange(
                    start: now.subtract(const Duration(days: 7)),
                    end: now,
                  ));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month),
                title: const Text('30 Hari Terakhir'),
                onTap: () {
                  final now = DateTime.now();
                  setState(() => _dateRange = DateTimeRange(
                    start: now.subtract(const Duration(days: 30)),
                    end: now,
                  ));
                  Navigator.pop(context);
                },
              ),
              if (_dateRange != null)
                ListTile(
                  leading: const Icon(Icons.clear, color: AppColors.error),
                  title: const Text(
                    'Hapus Filter Tanggal',
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () {
                    setState(() => _dateRange = null);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showSubmissionDetail(JobDeskSubmission submission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollController,
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
                  const SizedBox(height: 24),

                  // Status Badge
                  Center(
                    child: _buildDetailStatusBadge(submission),
                  ),

                  const SizedBox(height: 24),

                  // Task Name
                  Text(
                    submission.taskItem!.taskName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Detail Info
                  _buildDetailItem(
                    icon: Icons.calendar_today,
                    label: 'Tanggal',
                    value: DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                        .format(submission.submittedAt!),
                  ),
                  _buildDetailItem(
                    icon: Icons.access_time,
                    label: 'Waktu Pengiriman',
                    value: DateFormat('HH:mm:ss')
                        .format(submission.submittedAt!),
                  ),
                  if (submission.actualValue != null)
                    _buildDetailItem(
                      icon: Icons.confirmation_number,
                      label: 'Nilai Input',
                      value: submission.actualValue.toString(),
                    ),
                  if (submission.notes != null && submission.notes!.isNotEmpty)
                    _buildDetailItem(
                      icon: Icons.notes,
                      label: 'Catatan',
                      value: submission.notes!,
                    ),
                  if (submission.reviewerName != null)
                    _buildDetailItem(
                      icon: Icons.person_outline,
                      label: 'Diverifikasi Oleh',
                      value: submission.reviewerName!,
                    ),
                  if (submission.reviewedAt != null)
                    _buildDetailItem(
                      icon: Icons.check_circle_outline,
                      label: 'Waktu Verifikasi',
                      value: DateFormat('dd/MM/yyyy HH:mm')
                          .format(submission.reviewedAt!),
                    ),
                  if (submission.rejectionReason != null)
                    _buildDetailItem(
                      icon: Icons.error_outline,
                      label: 'Alasan Penolakan',
                      value: submission.rejectionReason!,
                      isError: true,
                    ),

                  const SizedBox(height: 24),

                  // Close Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailStatusBadge(JobDeskSubmission submission) {
    Color color;
    String text;
    IconData icon;

    if (submission.isVerified) {
      color = AppColors.success;
      text = 'Terverifikasi';
      icon = Icons.verified;
    } else if (submission.isCompleted) {
      color = AppColors.info;
      text = 'Selesai';
      icon = Icons.check_circle;
    } else if (submission.isRejected) {
      color = AppColors.error;
      text = 'Ditolak';
      icon = Icons.cancel;
    } else {
      color = AppColors.warning;
      text = 'Pending';
      icon = Icons.pending;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isError = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isError
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isError ? AppColors.error : AppColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isError ? AppColors.error : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _viewPhoto(String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            url,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    SizedBox(height: 8),
                    Text('Gagal memuat gambar'),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<JobDeskSubmission> _filterSubmissions(List<JobDeskSubmission> submissions) {
    return submissions.where((s) {
      // Status filter
      if (_selectedFilter == 'completed' && !s.isCompleted && !s.isVerified) {
        return false;
      }
      if (_selectedFilter == 'pending' && !s.isPending) {
        return false;
      }
      if (_selectedFilter == 'rejected' && !s.isRejected) {
        return false;
      }

      // Date range filter
      if (_dateRange != null && s.submittedAt != null) {
        final submitted = s.submittedAt!;
        if (submitted.isBefore(_dateRange!.start) ||
            submitted.isAfter(_dateRange!.end.add(const Duration(days: 1)))) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
