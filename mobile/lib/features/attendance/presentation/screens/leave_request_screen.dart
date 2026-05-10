import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 🏖️ LEAVE REQUEST SCREEN
/// Pengajuan cuti, izin, dan sakit
/// ============================================================

class LeaveRequestScreen extends ConsumerStatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  ConsumerState<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends ConsumerState<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String _selectedType = 'annual'; // annual, sick, permission, emergency, unpaid
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  DateTime _endDate = DateTime.now().add(const Duration(days: 1));
  int _durationDays = 1;
  bool _isHalfDay = false;
  bool _isSubmitting = false;

  // Dummy leave balance
  final Map<String, dynamic> _leaveBalance = {
    'annual': {'total': 12, 'used': 5, 'remaining': 7},
    'sick': {'total': 10, 'used': 2, 'remaining': 8},
    'permission': {'total': 6, 'used': 1, 'remaining': 5},
    'emergency': {'total': 3, 'used': 0, 'remaining': 3},
  };

  // Dummy leave history
  final List<Map<String, dynamic>> _leaveHistory = [
    {
      'id': '1',
      'type': 'annual',
      'startDate': DateTime.now().subtract(const Duration(days: 30)),
      'endDate': DateTime.now().subtract(const Duration(days: 25)),
      'duration': 5,
      'reason': 'Liburan keluarga',
      'status': 'approved',
      'approvedBy': 'Pak Iwan',
      'approvedAt': DateTime.now().subtract(const Duration(days: 32)),
    },
    {
      'id': '2',
      'type': 'sick',
      'startDate': DateTime.now().subtract(const Duration(days: 10)),
      'endDate': DateTime.now().subtract(const Duration(days: 10)),
      'duration': 1,
      'reason': 'Demam dan flu',
      'status': 'approved',
      'approvedBy': 'Budi Wijaya',
      'approvedAt': DateTime.now().subtract(const Duration(days: 11)),
    },
    {
      'id': '3',
      'type': 'permission',
      'startDate': DateTime.now().subtract(const Duration(days: 5)),
      'endDate': DateTime.now().subtract(const Duration(days: 5)),
      'duration': 1,
      'reason': 'Urusan keluarga',
      'status': 'pending',
      'approvedBy': null,
      'approvedAt': null,
    },
  ];

  final List<Map<String, dynamic>> _leaveTypes = [
    {'id': 'annual', 'name': 'Cuti Tahunan', 'icon': Icons.beach_access, 'color': Colors.blue},
    {'id': 'sick', 'name': 'Cuti Sakit', 'icon': Icons.local_hospital, 'color': Colors.red},
    {'id': 'permission', 'name': 'Izin', 'icon': Icons.assignment, 'color': Colors.orange},
    {'id': 'emergency', 'name': 'Cuti Darurat', 'icon': Icons.warning, 'color': Colors.purple},
    {'id': 'unpaid', 'name': 'Cuti Tanpa Gaji', 'icon': Icons.money_off, 'color': Colors.grey},
  ];

  void _updateDuration() {
    setState(() {
      if (_isHalfDay) {
        _durationDays = 0;
      } else {
        _durationDays = _endDate.difference(_startDate).inDays + 1;
        if (_durationDays < 1) _durationDays = 1;
      }
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Pengajuan Cuti & Izin',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.add_circle), text: 'Ajukan'),
              Tab(icon: Icon(Icons.history), text: 'Riwayat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRequestTab(),
            _buildHistoryTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestTab() {
    final balance = _leaveBalance[_selectedType];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leave Balance Card
            if (balance != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sisa Cuti',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${balance['remaining']} hari',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Total: ${balance['total']} | Terpakai: ${balance['used']}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Leave Type
            _buildSectionTitle('Jenis Cuti/Izin *'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _leaveTypes.map((type) {
                final isSelected = _selectedType == type['id'];
                final color = type['color'] as Color;

                return ChoiceChip(
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedType = type['id']);
                    }
                  },
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(type['icon'], size: 16, color: isSelected ? color : AppColors.textHint),
                      const SizedBox(width: 6),
                      Text(type['name']),
                    ],
                  ),
                  selectedColor: color.withOpacity(0.1),
                  checkmarkColor: color,
                  labelStyle: TextStyle(
                    color: isSelected ? color : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Date Selection
            _buildSectionTitle('Tanggal *'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildDateCard(
                    label: 'Mulai',
                    date: _startDate,
                    onTap: () => _selectStartDate(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateCard(
                    label: 'Selesai',
                    date: _endDate,
                    onTap: () => _selectEndDate(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Half Day Toggle
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Icon(Icons.wb_twilight, color: AppColors.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Setengah Hari',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Hanya 0.5 hari (pagi/siang)',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isHalfDay,
                    onChanged: (value) {
                      setState(() {
                        _isHalfDay = value;
                        _updateDuration();
                      });
                    },
                    activeColor: AppColors.warning,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Duration Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.timelapse, color: AppColors.info),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Durasi Pengajuan',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        _isHalfDay
                            ? '0.5 hari (Setengah Hari)'
                            : '$_durationDays hari ${_durationDays > 1 ? 'kerja' : ''}',
                        style: TextStyle(
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Reason
            _buildSectionTitle('Alasan/Keterangan *'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Jelaskan alasan pengajuan cuti/izin...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Alasan wajib diisi';
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isSubmitting ? 'Mengirim...' : 'Ajukan Cuti/Izin',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Info Text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pengajuan cuti membutuhkan approval dari Kepala Cabang atau Owner.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _leaveHistory.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(_leaveHistory[index]);
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildDateCard({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  dateFormat.format(date),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> leave) {
    final typeInfo = _leaveTypes.firstWhere((t) => t['id'] == leave['type']);
    final dateFormat = DateFormat('dd MMM yyyy');

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (leave['status']) {
      case 'approved':
        statusColor = AppColors.success;
        statusText = 'Disetujui';
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'Ditolak';
        statusIcon = Icons.cancel;
        break;
      case 'pending':
        statusColor = AppColors.warning;
        statusText = 'Menunggu';
        statusIcon = Icons.hourglass_empty;
        break;
      default:
        statusColor = AppColors.textHint;
        statusText = leave['status'];
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (typeInfo['color'] as Color).withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (typeInfo['color'] as Color).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    typeInfo['icon'],
                    color: typeInfo['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeInfo['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${leave['duration']} hari',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
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
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.date_range, size: 16, color: AppColors.textHint),
                    const SizedBox(width: 8),
                    Text(
                      '${dateFormat.format(leave['startDate'])} - ${dateFormat.format(leave['endDate'])}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.notes, size: 16, color: AppColors.textHint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        leave['reason'],
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (leave['approvedBy'] != null) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.check, size: 16, color: AppColors.success),
                      const SizedBox(width: 8),
                      Text(
                        'Disetujui oleh: ${leave['approvedBy']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate;
        }
        _updateDuration();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _updateDuration();
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Check balance
    final balance = _leaveBalance[_selectedType];
    if (balance != null && _durationDays > balance['remaining']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sisa cuti tidak mencukupi (${balance['remaining']} hari tersedia)'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isSubmitting = false);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Pengajuan Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Menunggu approval dari atasan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Switch to history tab
                    DefaultTabController.of(context).animateTo(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Lihat Riwayat'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
