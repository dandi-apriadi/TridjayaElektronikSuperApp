import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../shared/dummy_data/dummy_data.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

class SalesDashboardScreen extends ConsumerWidget {
  const SalesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final prospects = DummyDataProvider.prospects;
    final newCount = prospects.where((p) => p.status == 'New').length;
    final contactedCount = prospects.where((p) => p.status == 'Contacted').length;
    final negotiationCount = prospects.where((p) => p.status == 'Negotiation').length;
    final closedCount = prospects.where((p) => p.status == 'Closed').length;
    final lostCount = prospects.where((p) => p.status == 'Lost').length;

    final now = DateTime.now();
    final days = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    const achieved = 8;
    const target = 15;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/sales/prospects'),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Prospek Baru'),
        backgroundColor: AppColors.salesColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        color: AppColors.salesColor,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 190,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.salesColor,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: AppColors.salesGradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: Stack(children: [
                    Positioned(top: -20, right: -40,
                      child: Container(width: 160, height: 160,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
                    SafeArea(child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                        Row(children: [
                          Container(width: 42, height: 42,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 22)),
                          const Spacer(),
                          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
                        ]),
                        const SizedBox(height: 8),
                        Text('Halo, ${user?.username ?? 'Sales'} 👋', style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                        const SizedBox(height: 2),
                        Text('${days[now.weekday]}, ${now.day} ${months[now.month]}', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.7))),
                        const SizedBox(height: 14),
                        // Inline target bar
                        Row(children: [
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Target: $achieved/$target unit', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: achieved / target,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                minHeight: 6,
                              ),
                            ),
                          ])),
                          const SizedBox(width: 12),
                          Text('${((achieved / target) * 100).toStringAsFixed(0)}%',
                              style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                        ]),
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
                  // Quick stats
                  Row(children: [
                    Expanded(child: GradientStatCard(title: 'Total Prospek', value: '${prospects.length}', icon: Icons.people_outline_rounded, gradient: AppColors.salesGradient)),
                    const SizedBox(width: 12),
                    Expanded(child: StatCard(title: 'Tutup Bulan Ini', value: '$closedCount', icon: Icons.handshake_outlined, color: AppColors.success)),
                  ]),
                  const SizedBox(height: 20),
                  _buildPipelineSection(newCount, contactedCount, negotiationCount, closedCount, lostCount),
                  const SizedBox(height: 20),
                  _buildFollowUps(context),
                  const SizedBox(height: 20),
                  _buildProspectList(context, prospects),
                  const SizedBox(height: 20),
                  _buildCampaignSummary(context),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPipelineSection(int newC, int contacted, int nego, int closed, int lost) {
    final total = newC + contacted + nego + closed + lost;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Pipeline Prospek'),
      const SizedBox(height: 12),
      FunnelBarChart(
        total: total > 0 ? total : 1,
        stages: [
          ChartBarData(label: 'Baru', value: newC.toDouble(), color: AppColors.info),
          ChartBarData(label: 'Kontak', value: contacted.toDouble(), color: AppColors.primary),
          ChartBarData(label: 'Nego', value: nego.toDouble(), color: AppColors.warning),
          ChartBarData(label: 'Tutup', value: closed.toDouble(), color: AppColors.success),
          ChartBarData(label: 'Tidak Lanjut', value: lost.toDouble(), color: AppColors.error),
        ],
      ),
    ]);
  }

  Widget _buildFollowUps(BuildContext context) {
    final followUps = DummyDataProvider.prospects
        .where((p) => p.status == 'Negotiation' || p.status == 'Contacted')
        .take(3)
        .toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title: 'Follow-Up Hari Ini', actionLabel: 'Semua', onAction: () => context.go('/sales/prospects')),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: followUps.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 62, endIndent: 16),
          itemBuilder: (_, i) {
            final p = followUps[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.salesLight, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.phone_outlined, color: AppColors.salesColor, size: 18)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: AppTextStyles.bodyMedium),
                  Text('Minat: ${p.productInterest}', style: AppTextStyles.caption),
                ])),
                StatusBadge(label: p.status, color: p.status == 'Negotiation' ? AppColors.warning : AppColors.info),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildProspectList(BuildContext context, List<DummyProspect> prospects) {
    final shown = prospects.take(4).toList();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title: 'Prospek Terbaru', actionLabel: 'Semua', onAction: () => context.go('/sales/prospects')),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: shown.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 62, endIndent: 16),
          itemBuilder: (_, i) {
            final p = shown[i];
            final sc = _statusColor(p.status);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(children: [
                Container(width: 36, height: 36,
                  decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(p.name[0], style: TextStyle(fontWeight: FontWeight.w700, color: sc)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(p.name, style: AppTextStyles.bodyMedium),
                  Text(p.productInterest, style: AppTextStyles.caption),
                ])),
                StatusBadge(label: p.status, color: sc),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildCampaignSummary(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SectionHeader(title: 'Kampanye Terbaru', actionLabel: 'Semua', onAction: () => context.go('/sales/campaigns')),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => context.go('/sales/campaigns'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), boxShadow: AppShadows.sm),
          child: Column(children: [
            Row(children: [
              Container(width: 36, height: 36,
                decoration: BoxDecoration(color: AppColors.salesLight, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.campaign_outlined, color: AppColors.salesColor, size: 18)),
              const SizedBox(width: 12),
              Expanded(child: Text('Promo Aki Lebaran', style: AppTextStyles.bodyMedium)),
              const StatusBadge(label: 'Selesai', color: AppColors.success),
            ]),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _campaignStat('Terkirim', '45', AppColors.info),
              Container(width: 1, height: 30, color: AppColors.divider),
              _campaignStat('Dibaca', '32', AppColors.success),
              Container(width: 1, height: 30, color: AppColors.divider),
              _campaignStat('Respons', '12', AppColors.salesColor),
              Container(width: 1, height: 30, color: AppColors.divider),
              _campaignStat('Gagal', '3', AppColors.error),
            ]),
          ]),
        ),
      ),
    ]);
  }

  Widget _campaignStat(String label, String val, Color color) {
    return Column(children: [
      Text(val, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
      const SizedBox(height: 2),
      Text(label, style: AppTextStyles.caption),
    ]);
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'New': return AppColors.info;
      case 'Contacted': return AppColors.primary;
      case 'Negotiation': return AppColors.warning;
      case 'Closed': return AppColors.success;
      case 'Lost': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }
}
