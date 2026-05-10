import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/user_model.dart';

/// ============================================================
/// 🏆 PERFORMANCE RANKING SCREEN
/// Peringkat performa karyawan untuk Owner
/// ============================================================

class PerformanceRankingScreen extends ConsumerStatefulWidget {
  const PerformanceRankingScreen({super.key});

  @override
  ConsumerState<PerformanceRankingScreen> createState() => _PerformanceRankingScreenState();
}

class _PerformanceRankingScreenState extends ConsumerState<PerformanceRankingScreen> {
  String _selectedPeriod = 'monthly'; // daily, weekly, monthly, yearly
  String _selectedBranch = 'all';
  String _selectedRole = 'all';
  int _touchedIndex = -1;

  // Dummy data
  final List<Map<String, dynamic>> _branches = [
    {'id': 'all', 'name': 'Semua Cabang'},
    {'id': '1', 'name': 'Cabang Bandung'},
    {'id': '2', 'name': 'Cabang Jakarta'},
    {'id': '3', 'name': 'Cabang Surabaya'},
  ];

  final List<Map<String, dynamic>> _roles = [
    {'id': 'all', 'name': 'Semua Role'},
    {'id': 'sales', 'name': 'Sales'},
    {'id': 'driver', 'name': 'Driver'},
    {'id': 'admin', 'name': 'Admin'},
  ];

  final List<Map<String, dynamic>> _rankings = [
    {
      'rank': 1,
      'name': 'Ahmad Santoso',
      'role': 'Sales',
      'branch': 'Cabang Bandung',
      'avatar': 'AS',
      'score': 98,
      'metrics': {
        'sales': 45,
        'target': 40,
        'revenue': 125000000,
        'visits': 120,
        'conversion': 85.0,
      },
      'trend': 'up',
    },
    {
      'rank': 2,
      'name': 'Siti Dewi',
      'role': 'Sales',
      'branch': 'Cabang Jakarta',
      'avatar': 'SD',
      'score': 94,
      'metrics': {
        'sales': 42,
        'target': 40,
        'revenue': 118000000,
        'visits': 110,
        'conversion': 82.5,
      },
      'trend': 'stable',
    },
    {
      'rank': 3,
      'name': 'Budi Wijaya',
      'role': 'Driver',
      'branch': 'Cabang Bandung',
      'avatar': 'BW',
      'score': 92,
      'metrics': {
        'deliveries': 180,
        'target': 150,
        'ontime': 175,
        'rating': 4.8,
      },
      'trend': 'up',
    },
    {
      'rank': 4,
      'name': 'Citra Lestari',
      'role': 'Admin',
      'branch': 'Cabang Surabaya',
      'avatar': 'CL',
      'score': 89,
      'metrics': {
        'transactions': 450,
        'accuracy': 99.5,
        'reports': 30,
      },
      'trend': 'down',
    },
    {
      'rank': 5,
      'name': 'Dedi Kurniawan',
      'role': 'Sales',
      'branch': 'Cabang Bandung',
      'avatar': 'DK',
      'score': 87,
      'metrics': {
        'sales': 35,
        'target': 40,
        'revenue': 98000000,
        'visits': 95,
        'conversion': 78.0,
      },
      'trend': 'stable',
    },
  ];

  final List<Map<String, dynamic>> _branchPerformance = [
    {'name': 'Bandung', 'score': 94, 'employees': 12},
    {'name': 'Jakarta', 'score': 89, 'employees': 15},
    {'name': 'Surabaya', 'score': 86, 'employees': 10},
    {'name': 'Medan', 'score': 82, 'employees': 8},
    {'name': 'Makassar', 'score': 78, 'employees': 6},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.ownerColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Peringkat Performa',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.emoji_events), text: 'Individual'),
              Tab(icon: Icon(Icons.business), text: 'Cabang'),
              Tab(icon: Icon(Icons.insights), text: 'Analisis'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildIndividualTab(),
            _buildBranchTab(),
            _buildAnalysisTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildIndividualTab() {
    return Column(
      children: [
        // Filters
        _buildFilters(),

        // Top 3 Podium
        _buildPodium(),

        // Rankings List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _rankings.length,
            itemBuilder: (context, index) {
              return _buildRankingCard(_rankings[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          // Period Selector
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPeriodChip('Harian', 'daily'),
                const SizedBox(width: 8),
                _buildPeriodChip('Mingguan', 'weekly'),
                const SizedBox(width: 8),
                _buildPeriodChip('Bulanan', 'monthly'),
                const SizedBox(width: 8),
                _buildPeriodChip('Tahunan', 'yearly'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Dropdown Filters
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  value: _selectedBranch,
                  items: _branches,
                  icon: Icons.business,
                  onChanged: (value) => setState(() => _selectedBranch = value!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  value: _selectedRole,
                  items: _roles,
                  icon: Icons.work,
                  onChanged: (value) => setState(() => _selectedRole = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return ChoiceChip(
      selected: isSelected,
      onSelected: (selected) {
        if (selected) setState(() => _selectedPeriod = value);
      },
      label: Text(label),
      selectedColor: AppColors.ownerColor.withOpacity(0.1),
      checkmarkColor: AppColors.ownerColor,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.ownerColor : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<Map<String, dynamic>> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item['id'] as String,
              child: Row(
                children: [
                  Icon(icon, size: 16, color: AppColors.textHint),
                  const SizedBox(width: 8),
                  Text(item['name'] as String),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPodium() {
    final top3 = _rankings.take(3).toList();
    if (top3.length < 3) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.ownerColor, AppColors.ownerColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Rank 2
          _buildPodiumItem(
            top3[1],
            height: 100,
            color: const Color(0xFFC0C0C0), // Silver
            emoji: '🥈',
          ),

          // Rank 1
          _buildPodiumItem(
            top3[0],
            height: 130,
            color: const Color(0xFFFFD700), // Gold
            emoji: '🥇',
          ),

          // Rank 3
          _buildPodiumItem(
            top3[2],
            height: 80,
            color: const Color(0xFFCD7F32), // Bronze
            emoji: '🥉',
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    Map<String, dynamic> data, {
    required double height,
    required Color color,
    required String emoji,
  }) {
    return Expanded(
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Text(
              data['avatar'],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.ownerColor,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Name
          Text(
            data['name'].split(' ')[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // Score
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${data['score']}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Podium
          Container(
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingCard(Map<String, dynamic> data) {
    final rank = data['rank'] as int;
    final metrics = data['metrics'] as Map<String, dynamic>;

    Color rankColor;
    if (rank == 1) {
      rankColor = const Color(0xFFFFD700);
    } else if (rank == 2) {
      rankColor = const Color(0xFFC0C0C0);
    } else if (rank == 3) {
      rankColor = const Color(0xFFCD7F32);
    } else {
      rankColor = AppColors.textHint;
    }

    IconData trendIcon;
    Color trendColor;
    switch (data['trend']) {
      case 'up':
        trendIcon = Icons.trending_up;
        trendColor = AppColors.success;
        break;
      case 'down':
        trendIcon = Icons.trending_down;
        trendColor = AppColors.error;
        break;
      default:
        trendIcon = Icons.trending_flat;
        trendColor = AppColors.textHint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: InkWell(
        onTap: () => _showEmployeeDetail(data),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Rank
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: rankColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: rankColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: rankColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.ownerColor.withOpacity(0.1),
                child: Text(
                  data['avatar'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.ownerColor,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['name'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getRoleColor(data['role']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            data['role'],
                            style: TextStyle(
                              fontSize: 11,
                              color: _getRoleColor(data['role']),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            data['branch'],
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Score & Trend
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${data['score']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ownerColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(trendIcon, size: 16, color: trendColor),
                      const SizedBox(width: 2),
                      Text(
                        '${metrics['sales'] ?? metrics['deliveries'] ?? metrics['transactions']} ${data['role'] == 'Sales' ? 'sales' : data['role'] == 'Driver' ? 'kirim' : 'trx'}',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBranchTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Branch Rankings Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.ownerColor, AppColors.ownerColor.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🏆 Cabang Terbaik',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _branchPerformance.first['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Skor: ${_branchPerformance.first['score']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_branchPerformance.first['employees']} Karyawan',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Branch Rankings List
        const Text(
          'Peringkat Cabang',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 16),

        ..._branchPerformance.asMap().entries.map((entry) {
          final index = entry.key;
          final branch = entry.value;
          return _buildBranchCard(branch, index + 1);
        }),
      ],
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? AppColors.ownerColor.withOpacity(0.1)
                  : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: rank <= 3 ? AppColors.ownerColor : AppColors.textHint,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${branch['employees']} Karyawan Aktif',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Score
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: branch['score'] / 100,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    rank == 1
                        ? const Color(0xFFFFD700)
                        : rank == 2
                            ? const Color(0xFFC0C0C0)
                            : rank == 3
                                ? const Color(0xFFCD7F32)
                                : AppColors.ownerColor,
                  ),
                  strokeWidth: 4,
                ),
              ),
              Text(
                '${branch['score']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: rank <= 3
                      ? [
                          const Color(0xFFFFD700),
                          const Color(0xFFC0C0C0),
                          const Color(0xFFCD7F32)
                        ][rank - 1]
                      : AppColors.ownerColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Role Distribution Chart
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Distribusi Performa per Role',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final labels = ['Sales', 'Driver', 'Admin', 'KC'];
                            if (value.toInt() >= 0 &&
                                value.toInt() < labels.length) {
                              return Text(
                                labels[value.toInt()],
                                style: const TextStyle(fontSize: 12),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: const TextStyle(fontSize: 10),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    barGroups: [
                      _buildBarGroup(0, 92, AppColors.salesColor),
                      _buildBarGroup(1, 88, AppColors.driverColor),
                      _buildBarGroup(2, 85, AppColors.adminColor),
                      _buildBarGroup(3, 90, AppColors.primary),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Insights
        Container(
          padding: const EdgeInsets.all(20),
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
                  Icon(Icons.lightbulb, color: AppColors.warning),
                  const SizedBox(width: 8),
                  const Text(
                    'Insight Performa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInsightItem(
                icon: Icons.trending_up,
                color: AppColors.success,
                title: 'Sales Meningkat',
                description:
                    'Performa Sales naik 15% dibanding periode sebelumnya',
              ),
              const Divider(height: 24),
              _buildInsightItem(
                icon: Icons.people,
                color: AppColors.info,
                title: 'Cabang Bandung Terbaik',
                description:
                    'Cabang Bandung memiliki rata-rata skor tertinggi (94)',
              ),
              const Divider(height: 24),
              _buildInsightItem(
                icon: Icons.warning,
                color: AppColors.warning,
                title: 'Perhatian untuk Driver',
                description:
                    '3 Driver memiliki on-time delivery di bawah 80%',
              ),
            ],
          ),
        ),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 30,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Sales':
        return AppColors.salesColor;
      case 'Driver':
        return AppColors.driverColor;
      case 'Admin':
        return AppColors.adminColor;
      case 'Kepala Cabang':
        return AppColors.primary;
      default:
        return AppColors.textHint;
    }
  }

  void _showEmployeeDetail(Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
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

                // Profile Header
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.ownerColor.withOpacity(0.1),
                        child: Text(
                          data['avatar'],
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ownerColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['name'],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${data['role']} • ${data['branch']}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.ownerColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Skor: ${data['score']}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ownerColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Metrics
                const Text(
                  'Metrik Performa',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                ..._buildMetricItems(data['metrics'] as Map<String, dynamic>),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildMetricItems(Map<String, dynamic> metrics) {
    return metrics.entries.map((entry) {
      String label;
      IconData icon;

      switch (entry.key) {
        case 'sales':
          label = 'Unit Terjual';
          icon = Icons.shopping_bag;
          break;
        case 'target':
          label = 'Target';
          icon = Icons.track_changes;
          break;
        case 'revenue':
          label = 'Revenue';
          icon = Icons.monetization_on;
          break;
        case 'visits':
          label = 'Kunjungan';
          icon = Icons.directions_car;
          break;
        case 'conversion':
          label = 'Konversi';
          icon = Icons.trending_up;
          break;
        case 'deliveries':
          label = 'Pengiriman';
          icon = Icons.local_shipping;
          break;
        case 'ontime':
          label = 'On-Time';
          icon = Icons.schedule;
          break;
        case 'rating':
          label = 'Rating';
          icon = Icons.star;
          break;
        case 'transactions':
          label = 'Transaksi';
          icon = Icons.receipt;
          break;
        case 'accuracy':
          label = 'Akurasi';
          icon = Icons.check_circle;
          break;
        case 'reports':
          label = 'Laporan';
          icon = Icons.assignment;
          break;
        default:
          label = entry.key;
          icon = Icons.analytics;
      }

      String value;
      if (entry.key == 'revenue') {
        value = 'Rp ${NumberFormat('#,###').format(entry.value)}';
      } else if (entry.key == 'conversion' ||
          entry.key == 'accuracy' ||
          entry.key == 'rating') {
        value = '${entry.value}%';
      } else {
        value = '${entry.value}';
      }

      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
