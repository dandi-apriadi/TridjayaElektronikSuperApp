import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/dummy_data/dummy_data.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final inv = DummyDataProvider.inventories.first;

    final now = DateTime.now();
    final days = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final branchName = user?.branchName ?? 'Cabang Pusat';
    final pendingCount = DummyDataProvider.tasks.where((t) => t.status == 'Pending').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {},
        color: AppColors.adminColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.adminColor,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.adminGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: Stack(children: [
                    Positioned(top: -20, right: -40,
                      child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
                    SafeArea(child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                        Row(children: [
                          Container(width: 42, height: 42,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 22)),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
                        ]),
                        const SizedBox(height: 8),
                        Text('Admin Inventori', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.7))),
                        Text(branchName, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                        const SizedBox(height: 2),
                        Text('${days[now.weekday]}, ${now.day} ${months[now.month]} ${now.year}', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.6))),
                      ]),
                    )),
                  ]),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: GradientStatCard(title: 'Total Stok', value: '${inv.akiStock + inv.tvStock + inv.hpStock}', icon: Icons.inventory_2_outlined, gradient: AppColors.adminGradient)),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(title: 'Stok Rendah', value: '${inv.lowStockCount}', icon: Icons.warning_amber_outlined, color: AppColors.error, onTap: () => context.go('/admin/inventory'))),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: StatCard(title: 'Tugas Pending', value: '$pendingCount', icon: Icons.task_outlined, color: AppColors.warning)),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(title: 'Pergerakan Hari Ini', value: '3', icon: Icons.swap_vert_rounded, color: AppColors.info)),
                  ]),
                  const SizedBox(height: 20),
                  _buildStockOverview(inv, context),
                  const SizedBox(height: 20),
                  _buildStockBarChart(inv),
                  const SizedBox(height: 20),
                  _buildQuickActions(context),
                  const SizedBox(height: 20),
                  _buildRecentMovements(),
                  const SizedBox(height: 20),
                  _buildAuditLog(),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockOverview(DummyInventorySummary inv, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Stok Saat Ini', actionLabel: 'Kelola', onAction: () => context.go('/admin/inventory')),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
          child: Row(children: [
            _stockCol(Icons.battery_charging_full_rounded, 'Aki', inv.akiStock, AppColors.warning),
            Container(width: 1, height: 50, color: AppColors.divider),
            _stockCol(Icons.tv_outlined, 'TV', inv.tvStock, AppColors.info),
            Container(width: 1, height: 50, color: AppColors.divider),
            _stockCol(Icons.smartphone_outlined, 'HP', inv.hpStock, AppColors.success),
          ]),
        ),
        if (inv.lowStockCount > 0) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => context.go('/admin/inventory'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.error.withOpacity(0.2))),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('${inv.lowStockCount} item perlu restock segera', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w600))),
                Text('Input →', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ],
      ],
    );
  }

  Widget _stockCol(IconData icon, String label, int val, Color color) {
    return Expanded(child: Column(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18)),
      const SizedBox(height: 6),
      Text('$val', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: AppTextStyles.caption),
    ]));
  }

  Widget _buildStockBarChart(DummyInventorySummary inv) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Distribusi Stok per Kategori'),
      const SizedBox(height: 12),
      BarChartCard(
        title: 'Jumlah Stok',
        subtitle: 'Update terakhir: hari ini',
        unit: ' unit',
        height: 180,
        data: [
          ChartBarData(label: 'Aki', value: inv.akiStock.toDouble(), color: AppColors.warning),
          ChartBarData(label: 'TV', value: inv.tvStock.toDouble(), color: AppColors.info),
          ChartBarData(label: 'HP', value: inv.hpStock.toDouble(), color: AppColors.success),
        ],
      ),
    ]);
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      ('Tambah Stok', Icons.add_circle_outline_rounded, AppColors.success),
      ('Kurangi Stok', Icons.remove_circle_outline_rounded, AppColors.error),
      ('Scan Barcode', Icons.qr_code_scanner_rounded, AppColors.adminColor),
      ('Lihat Semua', Icons.inventory_2_outlined, AppColors.info),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Aksi Cepat'),
      const SizedBox(height: 12),
      Row(children: actions.map((a) => Expanded(
        child: GestureDetector(
          onTap: () {
            if (a.$1 == 'Lihat Semua') context.go('/admin/inventory');
            else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${a.$1} — Coming Soon'), behavior: SnackBarBehavior.floating));
          },
          child: Container(
            margin: EdgeInsets.only(right: actions.indexOf(a) < actions.length - 1 ? 10 : 0),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppShadows.sm,
              border: Border.all(color: a.$3.withOpacity(0.2)),
            ),
            child: Column(children: [
              Container(width: 36, height: 36,
                decoration: BoxDecoration(color: a.$3.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(a.$2, color: a.$3, size: 18)),
              const SizedBox(height: 6),
              Text(a.$1, style: AppTextStyles.caption.copyWith(color: a.$3, fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ),
      )).toList()),
    ]);
  }

  Widget _buildRecentMovements() {
    final movements = [
      ('Aki GS NS40', '+50 unit', AppColors.success, '09:15', Icons.arrow_upward_rounded),
      ('TV Samsung 43"', '-2 unit', AppColors.error, '08:42', Icons.arrow_downward_rounded),
      ('HP Xiaomi Note 13', '+30 unit', AppColors.success, '08:00', Icons.arrow_upward_rounded),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Pergerakan Stok', actionLabel: 'Riwayat'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: movements.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 62, endIndent: 16),
          itemBuilder: (_, i) {
            final (item, qty, color, time, icon) = movements[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 18)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item, style: AppTextStyles.bodyMedium),
                  Text(time, style: AppTextStyles.caption),
                ])),
                Text(qty, style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w700)),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildAuditLog() {
    final logs = [
      ('Stok Aki GS +50 unit', 'Admin Dewi', '09:15'),
      ('TV Samsung -2 unit (penjualan)', 'Admin Dewi', '08:42'),
      ('HP Xiaomi +30 unit', 'Admin Dewi', '08:00'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Log Audit Terbaru'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: logs.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 62, endIndent: 16),
          itemBuilder: (_, i) {
            final (action, user, time) = logs[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.adminLight, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.history_rounded, color: AppColors.adminColor, size: 18)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(action, style: AppTextStyles.bodyMedium),
                  Text('$user • $time', style: AppTextStyles.caption),
                ])),
              ]),
            );
          },
        ),
      ),
    ]);
  }
}
