import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../models/sales_models.dart';
import '../providers/sales_provider.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

class SalesDashboardScreen extends ConsumerWidget {
  const SalesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final days = ['', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final dashboardAsync = ref.watch(salesDashboardProvider);
    final prospectsAsync = ref.watch(prospectsProvider);
    final campaignsAsync = ref.watch(campaignsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/sales/prospects'),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Prospek Baru'),
        backgroundColor: AppColors.salesColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(salesDashboardProvider);
          ref.refresh(prospectsProvider);
          ref.refresh(campaignsProvider);
        },
        color: AppColors.salesColor,
        child: dashboardAsync.when(
          data: (metrics) => CustomScrollView(
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
                          Row(children: [
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Target: ${metrics.monthlyAchieved}/${metrics.monthlyTarget} unit', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: metrics.monthlyTarget > 0 ? metrics.monthlyAchieved / metrics.monthlyTarget : 0,
                                  backgroundColor: Colors.white24,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                  minHeight: 6,
                                ),
                              ),
                            ])),
                            const SizedBox(width: 12),
                            Text('${metrics.conversionRate.toStringAsFixed(0)}%',
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
                    Row(children: [
                      Expanded(child: GradientStatCard(title: 'Total Prospek', value: '${metrics.totalProspects}', icon: Icons.people_outline_rounded, gradient: AppColors.salesGradient)),
                      const SizedBox(width: 12),
                      Expanded(child: StatCard(title: 'Tutup Bulan Ini', value: '${metrics.monthlyAchieved}', icon: Icons.handshake_outlined, color: AppColors.success)),
                    ]),
                    const SizedBox(height: 20),
                    _buildPipelineSection(metrics.prospectsByStatus),
                    const SizedBox(height: 20),
                    prospectsAsync.when(
                      data: (prospects) => _buildFollowUps(context, prospects),
                      loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
                      error: (error, _) => _buildErrorSection(error.toString()),
                    ),
                    const SizedBox(height: 20),
                    prospectsAsync.when(
                      data: (prospects) => _buildProspectList(context, prospects),
                      loading: () => const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
                      error: (error, _) => _buildErrorSection(error.toString()),
                    ),
                    const SizedBox(height: 20),
                    campaignsAsync.when(
                      data: (campaigns) => _buildCampaignSummary(context, campaigns),
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

  Widget _buildPipelineSection(ProspectSummary summary) {
    final total = summary.newCount + summary.contacted + summary.negotiation + summary.closed + summary.lost;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SectionHeader(title: 'Pipeline Prospek'),
      const SizedBox(height: 12),
      FunnelBarChart(
        total: total > 0 ? total : 1,
        stages: [
          ChartBarData(label: 'Baru', value: summary.newCount.toDouble(), color: AppColors.info),
          ChartBarData(label: 'Kontak', value: summary.contacted.toDouble(), color: AppColors.primary),
          ChartBarData(label: 'Nego', value: summary.negotiation.toDouble(), color: AppColors.warning),
          ChartBarData(label: 'Tutup', value: summary.closed.toDouble(), color: AppColors.success),
          ChartBarData(label: 'Tidak Lanjut', value: summary.lost.toDouble(), color: AppColors.error),
        ],
      ),
    ]);
  }

  Widget _buildFollowUps(BuildContext context, List<Prospect> prospects) {
    final followUps = prospects
        .where((p) => p.status == 'negotiation' || p.status == 'contacted')
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
                  Text('Minat: ${p.productInterest ?? '-'}', style: AppTextStyles.caption),
                ])),
                StatusBadge(label: _prettyStatus(p.status), color: p.status == 'negotiation' ? AppColors.warning : AppColors.info),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildProspectList(BuildContext context, List<Prospect> prospects) {
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
                  Text(p.productInterest ?? '-', style: AppTextStyles.caption),
                ])),
                StatusBadge(label: _prettyStatus(p.status), color: sc),
              ]),
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildCampaignSummary(BuildContext context, List<Campaign> campaigns) {
    final campaign = campaigns.isNotEmpty ? campaigns.first : null;
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
              Expanded(child: Text(campaign?.name ?? 'Belum ada kampanye', style: AppTextStyles.bodyMedium)),
              StatusBadge(label: campaign == null ? 'Kosong' : _prettyStatus(campaign.status), color: campaign == null ? AppColors.textHint : _campaignColor(campaign.status)),
            ]),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _campaignStat('Target', '${campaign?.targetAmount ?? 0}', AppColors.info),
              Container(width: 1, height: 30, color: AppColors.divider),
              _campaignStat('Tercapai', '${campaign?.achievedAmount ?? 0}', AppColors.success),
              Container(width: 1, height: 30, color: AppColors.divider),
              _campaignStat('Status', campaign == null ? '-' : _prettyStatus(campaign.status), AppColors.salesColor),
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
    switch (status.toLowerCase()) {
      case 'new': return AppColors.info;
      case 'contacted': return AppColors.primary;
      case 'negotiation': return AppColors.warning;
      case 'closed': return AppColors.success;
      case 'lost': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  Color _campaignColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.info;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _prettyStatus(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return 'Baru';
      case 'contacted':
        return 'Kontak';
      case 'negotiation':
        return 'Nego';
      case 'closed':
        return 'Tutup';
      case 'lost':
        return 'Tidak Lanjut';
      case 'active':
        return 'Aktif';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Batal';
      default:
        return status;
    }
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
