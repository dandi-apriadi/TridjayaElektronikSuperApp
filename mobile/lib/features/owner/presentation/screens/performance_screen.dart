import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/dummy_data/dummy_data.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Bulanan';
  String _selectedBranch = 'Semua';
  final List<String> _periods = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.ownerColor,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text('Performa Karyawan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(46),
              child: Container(
                color: AppColors.surface,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.ownerColor,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.ownerColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: AppTextStyles.bodyMedium,
                  tabs: const [Tab(text: 'Sales'), Tab(text: 'Non-Sales')],
                ),
              ),
            ),
          ),
        ],
        body: Column(children: [
          _buildFilters(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRankingList(isSales: true),
                _buildRankingList(isSales: false),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildFilters() {
    final branches = ['Semua', ...DummyDataProvider.branches.map((b) => b.name)];
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedPeriod,
            decoration: InputDecoration(
              labelText: 'Periode',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
            items: _periods.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
            onChanged: (v) => setState(() => _selectedPeriod = v!),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _selectedBranch,
            decoration: InputDecoration(
              labelText: 'Cabang',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: AppColors.surfaceVariant,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            ),
            items: branches.map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: (v) => setState(() => _selectedBranch = v!),
          ),
        ),
      ]),
    );
  }

  Widget _buildRankingList({required bool isSales}) {
    final employees = DummyDataProvider.employees
        .where((e) => isSales ? e.role == 'Sales' : e.role != 'Sales')
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));
    final avg = employees.isEmpty ? 0.0 : employees.fold(0.0, (s, e) => s + e.score) / employees.length;
    final top5 = employees.take(5).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(children: [
          Expanded(child: StatCard(title: 'Top Performer', value: employees.isNotEmpty ? employees.first.name.split(' ').first : '-', icon: Icons.emoji_events_rounded, color: const Color(0xFFFFD700))),
          const SizedBox(width: 12),
          Expanded(child: StatCard(title: 'Rata-rata Skor', value: avg.toStringAsFixed(1), icon: Icons.analytics_outlined, color: AppColors.ownerColor)),
        ]),
        const SizedBox(height: 16),
        if (top5.isNotEmpty) ...[  
          BarChartCard(
            title: 'Skor Kinerja Top 5',
            subtitle: 'Skor tertinggi periode ini',
            height: 180,
            data: top5.map((e) => ChartBarData(
              label: e.name.split(' ').first,
              value: e.score.toDouble(),
              color: e.score >= 85 ? AppColors.success : e.score >= 70 ? AppColors.warning : AppColors.error,
            )).toList(),
          ),
          const SizedBox(height: 16),
        ],
        const SectionHeader(title: 'Ranking Teratas'),
        const SizedBox(height: 8),
        ...employees.take(employees.length > 5 ? 5 : employees.length).asMap().entries.map((entry) {
          final index = entry.key;
          final emp = entry.value;
          return _buildRankCard(emp, index + 1);
        }),
        if (employees.length > 5) ...[
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          const SectionHeader(title: 'Perlu Perhatian'),
          const SizedBox(height: 8),
          ...employees.reversed.take(2).map((emp) => _buildRankCard(emp, employees.indexOf(emp) + 1, isBottom: true)),
        ],
      ],
    );
  }

  Widget _buildRankCard(DummyEmployee emp, int rank, {bool isBottom = false}) {
    final trend = emp.score >= 85 ? '↑' : emp.score >= 70 ? '→' : '↓';
    final trendColor = emp.score >= 85 ? AppColors.success : emp.score >= 70 ? AppColors.warning : AppColors.error;
    final scoreColor = emp.score >= 85 ? AppColors.success : emp.score >= 70 ? AppColors.warning : AppColors.error;
    final branchName = emp.branchId == 'b1' ? 'Cabang Pusat' : emp.branchId == 'b2' ? 'Cabang Selatan' : 'Cabang Timur';
    final medalColor = rank == 1 ? const Color(0xFFFFD700) : rank == 2 ? const Color(0xFFC0C0C0) : rank == 3 ? const Color(0xFFCD7F32) : AppColors.surfaceVariant;
    final medalTextColor = rank <= 3 ? Colors.white : AppColors.textSecondary;

    return GestureDetector(
      onTap: () => _showEmployeeDetail(emp, rank),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.sm,
          border: Border.all(
            color: isBottom ? AppColors.error.withOpacity(0.2) : rank <= 3 ? AppColors.ownerColor.withOpacity(0.15) : AppColors.divider,
          ),
        ),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: medalColor, shape: BoxShape.circle),
            child: Center(child: Text('$rank', style: TextStyle(fontWeight: FontWeight.w800, color: medalTextColor, fontSize: 14))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(emp.name, style: AppTextStyles.bodyMedium),
            Text('${emp.role} • $branchName', style: AppTextStyles.caption),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(children: [
              Text(trend, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: trendColor)),
              const SizedBox(width: 4),
              Text(emp.score.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: scoreColor)),
            ]),
            const SizedBox(height: 2),
            StatusBadge(
              label: emp.status,
              color: emp.status == 'Hadir' ? AppColors.success : emp.status == 'Terlambat' ? AppColors.warning : AppColors.error,
            ),
          ]),
        ]),
      ),
    );
  }

  void _showEmployeeDetail(DummyEmployee emp, int rank) {
    final branchName = emp.branchId == 'b1' ? 'Cabang Pusat' : emp.branchId == 'b2' ? 'Cabang Selatan' : 'Cabang Timur';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.ownerGradient),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(emp.name[0], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white))),
          ),
          const SizedBox(height: 12),
          Text(emp.name, style: AppTextStyles.heading3),
          Text('${emp.role} • $branchName', style: AppTextStyles.caption),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(color: AppColors.ownerColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text('Ranking #$rank  •  Skor: ${emp.score}',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.ownerColor, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(14)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _metricCol('Kehadiran', '95%', AppColors.success),
              Container(width: 1, height: 40, color: AppColors.divider),
              _metricCol('Tugas Selesai', '87%', AppColors.info),
              Container(width: 1, height: 40, color: AppColors.divider),
              if (emp.role == 'Sales') _metricCol('Konversi', '32%', AppColors.salesColor)
              else if (emp.role == 'Driver') _metricCol('On-Time', '91%', AppColors.warning)
              else _metricCol('Laporan', '100%', AppColors.adminColor),
            ]),
          ),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }

  Widget _metricCol(String label, String value, Color color) {
    return Column(children: [
      Text(value, style: AppTextStyles.heading3.copyWith(color: color)),
      Text(label, style: AppTextStyles.caption),
    ]);
  }
}
