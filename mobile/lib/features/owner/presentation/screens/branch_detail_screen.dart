import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/dummy_data/dummy_data.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

class BranchDetailScreen extends ConsumerStatefulWidget {
  final String branchId;
  const BranchDetailScreen({super.key, required this.branchId});

  @override
  ConsumerState<BranchDetailScreen> createState() => _BranchDetailScreenState();
}

class _BranchDetailScreenState extends ConsumerState<BranchDetailScreen> {
  int _selectedTimeRange = 0;
  final List<String> _timeRanges = ['7 Hari', '30 Hari', '3 Bulan', '1 Tahun'];

  @override
  Widget build(BuildContext context) {
    final branch = DummyDataProvider.branches.firstWhere(
      (b) => b.id == widget.branchId,
      orElse: () => DummyDataProvider.branches.first,
    );

    final branchInventory = DummyDataProvider.inventories
        .where((i) => i.branchId == widget.branchId)
        .toList();

    final branchSales = DummyDataProvider.salesData
        .where((s) => s.branchId == widget.branchId)
        .toList();

    final totalSales = branchSales.fold(0, (s, d) => s + d.dailySales);
    final totalRevenue = branchSales.fold(0.0, (s, d) => s + d.dailyRevenue);
    final lowStockCount = branchInventory.fold(0, (s, i) => s + i.lowStockCount);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        color: AppColors.ownerColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.ownerColor,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.ownerGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.store_rounded, color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text('Detail Cabang', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(branch.name, style: AppTextStyles.heading2.copyWith(color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(branch.address, style: AppTextStyles.caption.copyWith(color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildTimeFilter(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMetricsRow(totalSales, totalRevenue, lowStockCount),
                        const SizedBox(height: 20),
                        _buildSalesChart(branchSales),
                        const SizedBox(height: 20),
                        _buildInventorySection(branchInventory),
                        const SizedBox(height: 20),
                        _buildStaffSection(),
                        const SizedBox(height: 20),
                        _buildRecentActivity(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilter() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _timeRanges.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final isSelected = _selectedTimeRange == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedTimeRange = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ownerColor : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(_timeRanges[i],
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricsRow(int sales, double revenue, int lowStock) {
    return Row(children: [
      Expanded(child: GradientStatCard(
        title: 'Total Penjualan',
        value: '$sales',
        icon: Icons.shopping_cart_outlined,
        gradient: AppColors.ownerGradient,
      )),
      const SizedBox(width: 12),
      Expanded(child: StatCard(
        title: 'Pendapatan',
        value: 'Rp ${(revenue / 1000000).toStringAsFixed(1)}Jt',
        icon: Icons.attach_money_rounded,
        color: AppColors.success,
      )),
      const SizedBox(width: 12),
      Expanded(child: StatCard(
        title: 'Stok Rendah',
        value: '$lowStock',
        icon: Icons.warning_amber_rounded,
        color: lowStock > 0 ? AppColors.warning : AppColors.success,
      )),
    ]);
  }

  Widget _buildSalesChart(List<DummySalesData> salesData) {
    if (salesData.isEmpty) {
      return _buildEmptyCard('Data penjualan tidak tersedia');
    }

    return BarChartCard(
      title: 'Trend Penjualan',
      subtitle: 'Perkembangan penjualan ${_timeRanges[_selectedTimeRange]}',
      height: 200,
      data: salesData.take(7).map((s) => ChartBarData(
        label: 'Day', // DummySalesData doesn't have a date field
        value: s.dailySales.toDouble(),
        color: AppColors.ownerColor,
      )).toList(),
    );
  }

  Widget _buildInventorySection(List<DummyInventorySummary> inventory) {
    final lowStockItems = inventory.where((i) => i.lowStockCount > 0).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Status Inventori',
          actionLabel: 'Lihat Semua',
          onAction: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('📦 Menuju halaman inventori lengkap...')),
          ),
        ),
        const SizedBox(height: 12),
        if (lowStockItems.isEmpty)
          _buildStatusCard(
            Icons.check_circle_outline,
            'Semua stok aman',
            'Tidak ada item dengan stok rendah',
            AppColors.success,
          )
        else
          ...lowStockItems.map((item) => _buildInventoryAlertCard(item)),
      ],
    );
  }

  Widget _buildInventoryAlertCard(DummyInventorySummary item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.inventory_2_outlined, color: AppColors.warning),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produk dengan Stok Rendah', style: AppTextStyles.bodyMedium),
            Text('Cabang ini memiliki ${item.lowStockCount} item bermasalah',
                style: AppTextStyles.caption.copyWith(color: AppColors.warning)),
          ],
        )),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('${item.lowStockCount} item',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.warning)),
        ),
      ]),
    );
  }

  Widget _buildStaffSection() {
    final staff = [
      ('Ahmad S', 'Kepala Cabang', 'online'),
      ('Budi W', 'Admin', 'offline'),
      ('Citra D', 'Sales', 'online'),
      ('Dedi K', 'Driver', 'offline'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Staff Cabang'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: staff.length,
            separatorBuilder: (_, __) => const Divider(height: 1, indent: 62),
            itemBuilder: (_, i) {
              final (name, role, status) = staff[i];
              final isOnline = status == 'online';
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(name[0], style: TextStyle(color: AppColors.primary)),
                ),
                title: Text(name, style: AppTextStyles.bodyMedium),
                subtitle: Text(role, style: AppTextStyles.caption),
                trailing: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isOnline ? AppColors.success : AppColors.textHint,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('👤 Detail $name - Coming Soon')),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    final activities = [
      ('Penjualan baru', 'TV Samsung 43" - Rp 4.500.000', '10 menit lalu', Icons.shopping_bag_outlined, AppColors.success),
      ('Stok masuk', 'Aki GS NS40 - 20 unit', '1 jam lalu', Icons.inventory_2_outlined, AppColors.info),
      ('Prospek baru', 'Budi Santoso - HP Xiaomi', '2 jam lalu', Icons.person_add_outlined, AppColors.primary),
      ('Pengiriman', '3 unit ke Jl. Sudirman', '3 jam lalu', Icons.local_shipping_outlined, AppColors.warning),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Aktivitas Terbaru'),
        const SizedBox(height: 12),
        ...activities.map((a) => _buildActivityItem(a.$1, a.$2, a.$3, a.$4, a.$5)),
      ],
    );
  }

  Widget _buildActivityItem(String title, String desc, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodyMedium),
            Text(desc, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        )),
        Text(time, style: AppTextStyles.caption.copyWith(fontSize: 11)),
      ]),
    );
  }

  Widget _buildStatusCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodyMedium),
            Text(subtitle, style: AppTextStyles.caption),
          ],
        )),
      ]),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(message, style: AppTextStyles.body.copyWith(color: AppColors.textHint)),
      ),
    );
  }
}
