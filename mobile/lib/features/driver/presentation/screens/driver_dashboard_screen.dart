import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../models/driver_models.dart';
import '../providers/driver_provider.dart';
import '../../../../shared/widgets/stat_card.dart';

class DriverDashboardScreen extends ConsumerWidget {
  const DriverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final days = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final dashboardAsync = ref.watch(driverDashboardProvider);
    final deliveriesAsync = ref.watch(deliveriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(driverDashboardProvider);
          ref.refresh(deliveriesProvider);
        },
        color: AppColors.driverColor,
        child: dashboardAsync.when(
          data: (metrics) => CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.driverColor,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.driverGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
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
                              child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 22)),
                            const Spacer(),
                            IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
                          ]),
                          const SizedBox(height: 8),
                          Text('Halo, ${user?.username ?? 'Driver'} 👋', style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('${days[now.weekday]}, ${now.day} ${months[now.month]} ${now.year}', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.7))),
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
                      Expanded(child: GradientStatCard(title: 'Dalam Proses', value: '${metrics.inProgressDeliveries}', icon: Icons.local_shipping_rounded, gradient: AppColors.driverGradient)),
                      const SizedBox(width: 12),
                      Expanded(child: StatCard(title: 'Menunggu', value: '${metrics.pendingDeliveries}', icon: Icons.schedule_rounded, color: AppColors.warning)),
                      const SizedBox(width: 12),
                      Expanded(child: StatCard(title: 'Selesai', value: '${metrics.completedDeliveries}', icon: Icons.check_circle_rounded, color: AppColors.success)),
                    ]),
                    const SizedBox(height: 16),
                    _buildAttendanceCard(context),
                    const SizedBox(height: 20),
                    deliveriesAsync.when(
                      data: (deliveries) => _buildDeliveryList(context, deliveries),
                      loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
                      error: (error, _) => _buildErrorSection(error.toString()),
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Gagal memuat dashboard: $error')),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/driver/attendance'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.sm,
          border: Border.all(color: AppColors.driverColor.withOpacity(0.2)),
        ),
        child: Row(children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.driverGradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fingerprint_rounded, color: Colors.white, size: 24)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Absensi Hari Ini', style: AppTextStyles.bodyMedium),
            Text('Belum Check-In', style: AppTextStyles.caption),
          ])),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.driverColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: AppShadows.colored(AppColors.driverColor),
            ),
            child: const Text('Check-In', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ]),
      ),
    );
  }

  Widget _buildDeliveryList(BuildContext context, List<Delivery> deliveries) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title: 'Jadwal Pengiriman (${deliveries.length})'),
      const SizedBox(height: 12),
      ...deliveries.asMap().entries.map((e) => _buildDeliveryCard(context, e.value, e.key)),
    ]);
  }

  Widget _buildDeliveryCard(BuildContext context, Delivery delivery, int index) {
    final normalizedStatus = delivery.status.toLowerCase();
    final statusColor = normalizedStatus == 'completed'
        ? AppColors.success
        : normalizedStatus == 'in_progress'
            ? AppColors.driverColor
            : normalizedStatus == 'failed'
                ? AppColors.error
                : AppColors.warning;
    final statusLabel = normalizedStatus == 'in_progress'
        ? 'Proses'
        : normalizedStatus == 'completed'
            ? 'Selesai'
            : normalizedStatus == 'failed'
                ? 'Gagal'
                : 'Menunggu';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.06),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(children: [
            Container(width: 32, height: 32,
              decoration: BoxDecoration(color: statusColor.withOpacity(0.15), shape: BoxShape.circle),
              child: Center(child: Text('${index + 1}', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: statusColor)))),
            const SizedBox(width: 10),
            Expanded(child: Text(delivery.customerName, style: AppTextStyles.subtitle)),
            StatusBadge(label: statusLabel, color: statusColor),
          ]),
        ),
        // Body
        Padding(padding: const EdgeInsets.all(16), child: Column(children: [
          Row(children: [
            const Icon(Icons.location_on_outlined, color: AppColors.textHint, size: 16),
            const SizedBox(width: 8),
            Expanded(child: Text(delivery.address, style: AppTextStyles.body, maxLines: 2, overflow: TextOverflow.ellipsis)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.access_time_outlined, color: AppColors.textHint, size: 16),
            const SizedBox(width: 8),
            Text('Jadwal: ${delivery.scheduledTime ?? '-'}', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () async {
                  final uri = Uri.parse('https://maps.google.com/?q=${Uri.encodeComponent(delivery.address)}');
                  if (await canLaunchUrl(uri)) launchUrl(uri);
                },
                icon: const Icon(Icons.map_outlined, size: 16),
                label: const Text('Navigasi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.driverColor,
                  side: const BorderSide(color: AppColors.driverColor),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            if (normalizedStatus != 'completed') ...[
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUpdateStatusDialog(context, delivery),
                  icon: const Icon(Icons.check_rounded, size: 16),
                  label: const Text('Selesai'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ]),
        ])),
      ]),
    );
  }

  void _showUpdateStatusDialog(BuildContext context, dynamic delivery) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Status Pengiriman'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kiriman: ${delivery.customerName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            const Text('Pilih status baru:', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 12),
            _buildStatusOption(
              ctx,
              'Dalam Perjalanan',
              Icons.local_shipping,
              Colors.blue,
              delivery,
            ),
            _buildStatusOption(
              ctx,
              'Tiba di Tujuan',
              Icons.location_on,
              Colors.orange,
              delivery,
            ),
            _buildStatusOption(
              ctx,
              'Selesai',
              Icons.check_circle,
              AppColors.success,
              delivery,
            ),
            _buildStatusOption(
              ctx,
              'Gagal',
              Icons.cancel,
              AppColors.error,
              delivery,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusOption(
    BuildContext context,
    String status,
    IconData icon,
    Color color,
    dynamic delivery,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status diupdate: $status'),
            backgroundColor: color,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              status,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Text(message, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
    );
  }
}
