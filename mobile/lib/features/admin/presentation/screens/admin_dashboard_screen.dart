import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../models/inventory_models.dart';
import '../providers/inventory_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(inventoryStatsProvider);
    final itemsAsync = ref.watch(inventoryItemsProvider(null));
    final transactionsAsync = ref.watch(stockTransactionsProvider(null));

    final now = DateTime.now();
    final days = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final branchName = user?.branchName ?? 'Cabang';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(inventoryStatsProvider);
          ref.invalidate(inventoryItemsProvider);
          ref.invalidate(stockTransactionsProvider);
        },
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
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                            onPressed: () => context.push('/notifications'),
                          ),
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
                  // Stats Cards
                  statsAsync.when(
                    loading: () => const Center(child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    )),
                    error: (error, _) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.errorBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('Gagal memuat statistik: $error', style: const TextStyle(color: AppColors.error)),
                    ),
                    data: (stats) => Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: GradientStatCard(
                            title: 'Total Item',
                            value: '${stats.totalItems}',
                            icon: Icons.inventory_2_outlined,
                            gradient: AppColors.adminGradient,
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: StatCard(
                            title: 'Stok Rendah',
                            value: '${stats.lowStockItems}',
                            icon: Icons.warning_amber_outlined,
                            color: AppColors.error,
                            onTap: () => context.go('/admin/inventory'),
                          )),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: StatCard(
                            title: 'Habis Stok',
                            value: '${stats.outOfStockItems}',
                            icon: Icons.remove_shopping_cart_outlined,
                            color: AppColors.warning,
                          )),
                          const SizedBox(width: 12),
                          Expanded(child: StatCard(
                            title: 'Alert Aktif',
                            value: '${stats.alertsCount}',
                            icon: Icons.notification_important_outlined,
                            color: AppColors.info,
                          )),
                        ],
                      ),
                    ]),
                  ),

                  const SizedBox(height: 20),

                  // Stock Overview by Category
                  itemsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (items) => _buildStockOverview(items, context),
                  ),

                  const SizedBox(height: 20),

                  // Stock Distribution Chart
                  itemsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (items) => _buildStockBarChart(items),
                  ),

                  const SizedBox(height: 20),
                  _buildQuickActions(context),
                  const SizedBox(height: 20),

                  // Recent Transactions
                  transactionsAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (transactions) => _buildRecentMovements(transactions),
                  ),

                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockOverview(List<InventoryItem> items, BuildContext context) {
    final categories = <String, int>{};
    for (final item in items) {
      categories[item.category] = (categories[item.category] ?? 0) + item.currentStock;
    }
    final lowStockCount = items.where((i) => i.currentStock <= i.minimumStock).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Stok per Kategori', actionLabel: 'Kelola', onAction: () => context.go('/admin/inventory')),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
          child: Row(
            children: categories.entries.take(3).map((entry) {
              final color = _categoryColor(entry.key);
              final icon = _categoryIcon(entry.key);
              return Expanded(child: Column(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 18)),
                const SizedBox(height: 6),
                Text('${entry.value}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
                Text(entry.key, style: AppTextStyles.caption),
              ]));
            }).toList(),
          ),
        ),
        if (lowStockCount > 0) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => context.go('/admin/inventory'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.error.withOpacity(0.2))),
              child: Row(children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('$lowStockCount item perlu restock segera', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w600))),
                Text('Lihat →', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w700)),
              ]),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStockBarChart(List<InventoryItem> items) {
    final categories = <String, int>{};
    for (final item in items) {
      categories[item.category] = (categories[item.category] ?? 0) + item.currentStock;
    }

    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Distribusi Stok per Kategori'),
      const SizedBox(height: 12),
      BarChartCard(
        title: 'Jumlah Stok',
        subtitle: 'Update terakhir: hari ini',
        unit: ' unit',
        height: 180,
        data: categories.entries.map((e) => ChartBarData(
          label: e.key,
          value: e.value.toDouble(),
          color: _categoryColor(e.key),
        )).toList(),
      ),
    ]);
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      ('Tambah Stok', Icons.add_circle_outline_rounded, AppColors.success, '/admin/stock-in'),
      ('Kurangi Stok', Icons.remove_circle_outline_rounded, AppColors.error, '/admin/stock-out'),
      ('Lihat Semua', Icons.inventory_2_outlined, AppColors.info, '/admin/inventory'),
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Aksi Cepat'),
      const SizedBox(height: 12),
      Row(children: actions.map((a) => Expanded(
        child: GestureDetector(
          onTap: () => context.push(a.$4),
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

  Widget _buildRecentMovements(List<StockTransaction> transactions) {
    if (transactions.isEmpty) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionHeader(title: 'Pergerakan Stok Terbaru'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
          child: const Center(child: Text('Belum ada pergerakan stok')),
        ),
      ]);
    }

    final recentTransactions = transactions.take(5).toList();

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Pergerakan Stok Terbaru'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentTransactions.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 62, endIndent: 16),
          itemBuilder: (_, i) {
            final tx = recentTransactions[i];
            final isAdd = tx.type == 'add';
            final color = isAdd ? AppColors.success : AppColors.error;
            final icon = isAdd ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
            final qtyStr = isAdd ? '+${tx.quantity}' : '-${tx.quantity}';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: color, size: 18)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(tx.reason, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(_formatTime(tx.createdAt), style: AppTextStyles.caption),
                ])),
                Text('$qtyStr unit', style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w700)),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Color _categoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'aki': return AppColors.warning;
      case 'tv': return AppColors.info;
      case 'hp': return AppColors.success;
      default: return AppColors.primary;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'aki': return Icons.battery_charging_full_rounded;
      case 'tv': return Icons.tv_outlined;
      case 'hp': return Icons.smartphone_outlined;
      default: return Icons.inventory_2_outlined;
    }
  }

  String _formatTime(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
      if (diff.inHours < 24) return '${diff.inHours} jam lalu';
      return '${diff.inDays} hari lalu';
    } catch (_) {
      return dateStr;
    }
  }
}
