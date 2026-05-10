import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';

/// ============================================================
/// 💰 PAYROLL SCREEN
/// Slip gaji dan riwayat pembayaran
/// ============================================================

class PayrollScreen extends ConsumerStatefulWidget {
  const PayrollScreen({super.key});

  @override
  ConsumerState<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends ConsumerState<PayrollScreen> {
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  // Dummy payroll data
  final List<Map<String, dynamic>> _payrollHistory = [
    {
      'id': '1',
      'month': 5,
      'year': 2024,
      'basicSalary': 5000000,
      'allowances': {
        'transport': 500000,
        'meal': 600000,
        'communication': 200000,
      },
      'deductions': {
        'tax': 250000,
        'bpjs': 150000,
        'loan': 0,
      },
      'overtime': 750000,
      'bonus': 1000000,
      'totalEarnings': 7050000,
      'totalDeductions': 400000,
      'netSalary': 6650000,
      'status': 'paid',
      'paidAt': DateTime.now().subtract(const Duration(days: 5)),
      'paymentMethod': 'Transfer Bank BCA',
    },
    {
      'id': '2',
      'month': 4,
      'year': 2024,
      'basicSalary': 5000000,
      'allowances': {
        'transport': 500000,
        'meal': 600000,
        'communication': 200000,
      },
      'deductions': {
        'tax': 250000,
        'bpjs': 150000,
        'loan': 500000,
      },
      'overtime': 500000,
      'bonus': 0,
      'totalEarnings': 6300000,
      'totalDeductions': 900000,
      'netSalary': 5400000,
      'status': 'paid',
      'paidAt': DateTime.now().subtract(const Duration(days: 35)),
      'paymentMethod': 'Transfer Bank BCA',
    },
    {
      'id': '3',
      'month': 3,
      'year': 2024,
      'basicSalary': 5000000,
      'allowances': {
        'transport': 500000,
        'meal': 600000,
        'communication': 200000,
      },
      'deductions': {
        'tax': 250000,
        'bpjs': 150000,
        'loan': 0,
      },
      'overtime': 300000,
      'bonus': 500000,
      'totalEarnings': 6600000,
      'totalDeductions': 400000,
      'netSalary': 6200000,
      'status': 'paid',
      'paidAt': DateTime.now().subtract(const Duration(days: 65)),
      'paymentMethod': 'Transfer Bank BCA',
    },
  ];

  // Dummy current payroll
  final Map<String, dynamic> _currentPayroll = {
    'month': 6,
    'year': 2024,
    'basicSalary': 5000000,
    'allowances': {
      'transport': 500000,
      'meal': 600000,
      'communication': 200000,
    },
    'deductions': {
      'tax': 250000,
      'bpjs': 150000,
      'loan': 0,
    },
    'overtime': 1000000,
    'bonus': 0,
    'totalEarnings': 7300000,
    'totalDeductions': 400000,
    'netSalary': 6900000,
    'status': 'pending', // pending, processing, paid
    'workingDays': 22,
    'presentDays': 20,
    'leaveDays': 2,
  };

  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Slip Gaji',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _downloadPayslip,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current Month Card
          _buildCurrentMonthCard(),

          const SizedBox(height: 24),

          // Month Selector
          _buildMonthSelector(),

          const SizedBox(height: 16),

          // Payroll History
          _buildSectionTitle('Riwayat Gaji'),
          const SizedBox(height: 12),
          ..._payrollHistory.map((payroll) => _buildPayrollCard(payroll)),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCurrentMonthCard() {
    final status = _currentPayroll['status'] as String;
    final monthName = DateFormat('MMMM yyyy', 'id_ID').format(
      DateTime(_currentPayroll['year'], _currentPayroll['month']),
    );

    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case 'paid':
        statusColor = AppColors.success;
        statusText = 'Sudah Dibayar';
        statusIcon = Icons.check_circle;
        break;
      case 'processing':
        statusColor = AppColors.info;
        statusText = 'Diproses';
        statusIcon = Icons.sync;
        break;
      case 'pending':
      default:
        statusColor = AppColors.warning;
        statusText = 'Menunggu';
        statusIcon = Icons.hourglass_empty;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gaji Bulan Ini',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      monthName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 16, color: statusColor),
                      const SizedBox(width: 6),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Text(
                  currencyFormat.format(_currentPayroll['netSalary']),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Take Home Pay',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'Hari Kerja',
                    value: '${_currentPayroll['workingDays']}',
                    icon: Icons.work,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    label: 'Hadir',
                    value: '${_currentPayroll['presentDays']}',
                    icon: Icons.check_circle,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    label: 'Cuti/Izin',
                    value: '${_currentPayroll['leaveDays']}',
                    icon: Icons.beach_access,
                  ),
                ),
              ],
            ),
          ),

          // View Detail Button
          if (status != 'pending')
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showPayrollDetail(_currentPayroll),
                  icon: const Icon(Icons.visibility),
                  label: const Text('Lihat Detail'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthSelector() {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final month = index + 1;
          final isSelected = month == _selectedMonth;

          return GestureDetector(
            onTap: () => setState(() => _selectedMonth = month),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? AppShadows.md : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    months[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (isSelected)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildPayrollCard(Map<String, dynamic> payroll) {
    final monthName = DateFormat('MMMM yyyy', 'id_ID').format(
      DateTime(payroll['year'], payroll['month']),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: InkWell(
        onTap: () => _showPayrollDetail(payroll),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    monthName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text(
                          'Dibayar',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gaji Bersih',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currencyFormat.format(payroll['netSalary']),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Metode',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payroll['paymentMethod'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Dibayar: ${DateFormat('dd MMM yyyy').format(payroll['paidAt'])}',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPayrollDetail(Map<String, dynamic> payroll) {
    final allowances = payroll['allowances'] as Map<String, dynamic>;
    final deductions = payroll['deductions'] as Map<String, dynamic>;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
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

                // Title
                Text(
                  'Detail Slip Gaji',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),

                Text(
                  DateFormat('MMMM yyyy', 'id_ID').format(
                    DateTime(payroll['year'], payroll['month']),
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Basic Salary
                _buildDetailSection('Gaji Pokok', [
                  _buildDetailRow('Gaji Dasar', payroll['basicSalary']),
                ]),

                // Allowances
                _buildDetailSection('Tunjangan', [
                  _buildDetailRow('Transport', allowances['transport']),
                  _buildDetailRow('Makan', allowances['meal']),
                  _buildDetailRow('Komunikasi', allowances['communication']),
                ]),

                // Additional
                _buildDetailSection('Penambahan', [
                  if (payroll['overtime'] > 0)
                    _buildDetailRow('Lembur', payroll['overtime'], isPositive: true),
                  if (payroll['bonus'] > 0)
                    _buildDetailRow('Bonus', payroll['bonus'], isPositive: true),
                ]),

                // Deductions
                _buildDetailSection('Potongan', [
                  _buildDetailRow('Pajak (PPh 21)', deductions['tax'], isDeduction: true),
                  _buildDetailRow('BPJS Kesehatan', deductions['bpjs'], isDeduction: true),
                  if (deductions['loan'] > 0)
                    _buildDetailRow('Pinjaman', deductions['loan'], isDeduction: true),
                ]),

                const Divider(height: 32),

                // Total
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Penghasilan',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            currencyFormat.format(payroll['totalEarnings']),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Potongan',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '- ${currencyFormat.format(payroll['totalDeductions'])}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'GAJI BERSIH',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            currencyFormat.format(payroll['netSalary']),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Download Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _downloadPayslip();
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    dynamic amount, {
    bool isDeduction = false,
    bool isPositive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            isDeduction
                ? '- ${currencyFormat.format(amount)}'
                : isPositive
                    ? '+ ${currencyFormat.format(amount)}'
                    : currencyFormat.format(amount),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDeduction
                  ? AppColors.error
                  : isPositive
                      ? AppColors.success
                      : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadPayslip() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📥 Download slip gaji dimulai...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
