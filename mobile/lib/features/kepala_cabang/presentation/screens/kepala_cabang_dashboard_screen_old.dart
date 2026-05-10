import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/dummy_data/dummy_data.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

class KepalaCabangDashboardScreen extends ConsumerWidget {
  const KepalaCabangDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final branchName = user?.branchName ?? 'Cabang Pusat';
    final inventory = DummyDataProvider.inventories.first;
    final salesData = DummyDataProvider.salesData.first;
    final pendingTasks = DummyDataProvider.tasks.where((t) => t.status == 'Pending' || t.status == 'InProgress').length;
    final now = DateTime.now();
    final days = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final dateStr = '${days[now.weekday]}, ${now.day} ${months[now.month]} ${now.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {},
        color: AppColors.kepalaCabangColor,
        child: CustomScrollView(
          slivers: [
            // ── Modern gradient header ──
            SliverAppBar(
              expandedHeight: 160,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.kepalaCabangColor,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.kepalaCabangGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(children: [
                    Positioned(top: -20, right: -40,
                      child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
                    SafeArea(child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                        Row(children: [
                          Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.store_outlined, color: Colors.white, size: 22),
                          ),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
                        ]),
                        const SizedBox(height: 8),
                        Text('Kepala Cabang', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.7))),
                        Text(branchName, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                        const SizedBox(height: 2),
                        Text(dateStr, style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.6))),
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
                  // Quick Metrics
                  Row(children: [
                    Expanded(child: GradientStatCard(
                      title: 'Penjualan Hari Ini', value: '${salesData.dailySales} unit',
                      icon: Icons.shopping_cart_outlined, gradient: AppColors.kepalaCabangGradient,
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(
                      title: 'Tugas Pending', value: '$pendingTasks',
                      icon: Icons.task_outlined, color: AppColors.warning, onTap: () => context.go('/kepala-cabang/tasks'),
                    )),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: StatCard(title: 'Hadir', value: '${DummyDataProvider.employees.where((e) => e.status == 'Hadir').length}', icon: Icons.people_outline_rounded, color: AppColors.success)),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(title: 'Pengiriman', value: '${DummyDataProvider.deliveries.length}', icon: Icons.local_shipping_outlined, color: AppColors.info)),
                  ]),
                  const SizedBox(height: 20),

                  // Stock
                  _buildStockSection(inventory),
                  const SizedBox(height: 20),
                  _buildStockChart(inventory),
                  const SizedBox(height: 20),

                  // Attendance
                  _buildAttendanceSection(),
                  const SizedBox(height: 20),

                  // Tasks
                  _buildTasksSection(context),
                  const SizedBox(height: 20),

                  // Deliveries
                  _buildDeliverySection(),
                  const SizedBox(height: 20),

                  // Pending Reports
                  _buildPendingReports(context),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockSection(DummyInventorySummary inv) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Stok Cabang'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          _stockItem(Icons.battery_charging_full_rounded, 'Aki', inv.akiStock, AppColors.warning),
          _stockDivider(),
          _stockItem(Icons.tv_outlined, 'TV', inv.tvStock, AppColors.info),
          _stockDivider(),
          _stockItem(Icons.smartphone_outlined, 'HP', inv.hpStock, AppColors.success),
        ]),
      ),
      if (inv.lowStockCount > 0) ...[
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.error.withOpacity(0.2))),
          child: Row(children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 16),
            const SizedBox(width: 8),
            Text('${inv.lowStockCount} item perlu restock segera', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
          ]),
        ),
      ],
    ]);
  }

  Widget _buildStockChart(DummyInventorySummary inv) {
    return BarChartCard(
      title: 'Stok per Kategori',
      subtitle: 'Cabang ini',
      unit: ' unit',
      height: 160,
      data: [
        ChartBarData(label: 'Aki', value: inv.akiStock.toDouble(), color: AppColors.warning),
        ChartBarData(label: 'TV', value: inv.tvStock.toDouble(), color: AppColors.info),
        ChartBarData(label: 'HP', value: inv.hpStock.toDouble(), color: AppColors.success),
      ],
    );
  }

  Widget _stockItem(IconData icon, String label, int val, Color color) {
    return Expanded(child: Column(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 18)),
      const SizedBox(height: 6),
      Text('$val', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: AppTextStyles.caption),
    ]));
  }

  Widget _stockDivider() => Container(width: 1, height: 50, color: AppColors.divider);

  Widget _buildAttendanceSection() {
    final employees = DummyDataProvider.employees.where((e) => e.branchId == 'b1').take(4).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Kehadiran Hari Ini', actionLabel: 'Semua'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: employees.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 62, endIndent: 16),
          itemBuilder: (_, i) {
            final emp = employees[i];
            final statusColor = emp.status == 'Hadir' ? AppColors.success : emp.status == 'Terlambat' ? AppColors.warning : AppColors.error;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.kepalaCabangColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text(emp.name[0], style: AppTextStyles.subtitle.copyWith(color: AppColors.kepalaCabangColor))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(emp.name, style: AppTextStyles.bodyMedium),
                  Text(emp.role, style: AppTextStyles.caption),
                ])),
                StatusBadge(label: emp.status, color: statusColor),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildTasksSection(BuildContext context) {
    final tasks = DummyDataProvider.tasks.take(3).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title: 'Tugas Aktif', actionLabel: 'Semua', onAction: () => context.go('/kepala-cabang/tasks')),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (_, i) {
            final task = tasks[i];
            final pColor = task.priority == 'Urgent' ? AppColors.error : task.priority == 'High' ? AppColors.warning : AppColors.info;
            final sColor = task.status == 'Completed' ? AppColors.success : task.status == 'InProgress' ? AppColors.info : AppColors.textSecondary;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Container(width: 4, height: 36, decoration: BoxDecoration(color: pColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(task.title, style: AppTextStyles.bodyMedium),
                  Text(task.assignee, style: AppTextStyles.caption),
                ])),
                StatusBadge(label: task.status, color: sColor),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildDeliverySection() {
    final deliveries = DummyDataProvider.deliveries.take(3).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Pengiriman Hari Ini', actionLabel: 'Semua'),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: deliveries.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (_, i) {
            final d = deliveries[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.kepalaCabangLight, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.local_shipping_outlined, color: AppColors.kepalaCabangColor, size: 18)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(d.customerName, style: AppTextStyles.bodyMedium),
                  Text(d.address, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                ])),
                Text(d.scheduledTime, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.kepalaCabangColor)),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildPendingReports(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title: 'Laporan Pending', actionLabel: 'Review', onAction: () => context.go('/kepala-cabang/reports')),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => context.go('/kepala-cabang/reports'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.sm,
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(children: [
            Container(width: 44, height: 44,
              decoration: BoxDecoration(color: AppColors.warningBg, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.pending_actions_outlined, color: AppColors.warning, size: 22)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('3 laporan menunggu review', style: AppTextStyles.bodyMedium),
              Text('Terakhir dikirim 2 jam lalu', style: AppTextStyles.caption),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.warningBg, borderRadius: BorderRadius.circular(8)),
              child: Text('Review', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.warning)),
            ),
          ]),
        ),
      ),
    ]);
  }
}
