import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  final List<_Campaign> _campaigns = [
    _Campaign('Promo Aki Lebaran', 'completed', 45, 32, 12, 3, '1 Mei 2025', null),
    _Campaign('Penawaran TV Samsung', 'in_progress', 30, 20, 5, 2, '7 Mei 2025', null),
    _Campaign('Flash Sale HP Xiaomi', 'scheduled', 0, 0, 0, 0, '10 Mei 2025', '14:00'),
    _Campaign('Follow Up Prospek Baru', 'draft', 0, 0, 0, 0, '-', null),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateCampaignSheet(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Kampanye Baru'),
        backgroundColor: AppColors.salesColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.salesColor,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text('Kampanye WhatsApp', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _buildSummaryRow(),
                const SizedBox(height: 20),
                _buildCampaignChart(),
                const SizedBox(height: 20),
                const SectionHeader(title: 'Semua Kampanye'),
                const SizedBox(height: 12),
                ..._campaigns.map((c) => _buildCampaignCard(context, c)),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow() {
    final totalSent = _campaigns.fold(0, (s, c) => s + c.sent);
    final totalRead = _campaigns.fold(0, (s, c) => s + c.read);
    final totalReply = _campaigns.fold(0, (s, c) => s + c.replied);
    return Row(children: [
      Expanded(child: StatCard(title: 'Total Terkirim', value: '$totalSent', icon: Icons.send_rounded, color: AppColors.info)),
      const SizedBox(width: 10),
      Expanded(child: StatCard(title: 'Dibaca', value: '$totalRead', icon: Icons.done_all_rounded, color: AppColors.success)),
      const SizedBox(width: 10),
      Expanded(child: StatCard(title: 'Respon', value: '$totalReply', icon: Icons.reply_rounded, color: AppColors.salesColor)),
    ]);
  }

  Widget _buildCampaignChart() {
    final completed = _campaigns.where((c) => c.status == 'completed' && c.sent > 0).toList();
    if (completed.isEmpty) return const SizedBox.shrink();
    return BarChartCard(
      title: 'Performa Kampanye',
      subtitle: 'Terkirim vs Dibaca vs Respons',
      height: 180,
      data: completed.expand((c) => [
        ChartBarData(label: '${c.name.split(' ').first}\nKirim', value: c.sent.toDouble(), color: AppColors.info),
        ChartBarData(label: '${c.name.split(' ').first}\nBaca', value: c.read.toDouble(), color: AppColors.success),
        ChartBarData(label: '${c.name.split(' ').first}\nRespon', value: c.replied.toDouble(), color: AppColors.salesColor),
      ]).toList(),
    );
  }

  Widget _buildCampaignCard(BuildContext context, _Campaign c) {
    final sc = _statusColor(c.status);
    final sl = _statusLabel(c.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
        border: Border.all(color: sc.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: BoxDecoration(
            color: sc.withOpacity(0.05),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Row(children: [
            Container(width: 36, height: 36,
              decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.campaign_outlined, size: 18, color: AppColors.salesColor)),
            const SizedBox(width: 12),
            Expanded(child: Text(c.name, style: AppTextStyles.subtitle)),
            StatusBadge(label: sl, color: sc),
          ]),
        ),
        // Body
        Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textHint),
            const SizedBox(width: 5),
            Text(c.scheduledDate, style: AppTextStyles.caption),
            if (c.scheduledTime != null) ...[
              Text('  •  ${c.scheduledTime}', style: AppTextStyles.caption),
            ],
          ]),
          if (c.status == 'completed' || c.status == 'in_progress') ...[
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _statCol('Terkirim', c.sent, AppColors.info),
              _divider(),
              _statCol('Dibaca', c.read, AppColors.success),
              _divider(),
              _statCol('Respon', c.replied, AppColors.salesColor),
              _divider(),
              _statCol('Gagal', c.failed, AppColors.error),
            ]),
            if (c.sent > 0) ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: c.read / c.sent,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                      minHeight: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('${((c.read / c.sent) * 100).toStringAsFixed(0)}%',
                    style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
              ]),
            ],
          ],
          const SizedBox(height: 14),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            if (c.status == 'draft')
              OutlinedButton.icon(
                onPressed: () => _showEditCampaignDialog(context, c),
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: const Text('Edit'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  foregroundColor: AppColors.textSecondary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            if (c.status == 'draft') const SizedBox(width: 10),
            if (c.status == 'draft' || c.status == 'scheduled')
              ElevatedButton.icon(
                onPressed: () => _showSendConfirmation(context, c),
                icon: const Icon(Icons.send_rounded, size: 14),
                label: Text(c.status == 'scheduled' ? 'Kirim Sekarang' : 'Mulai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.salesColor,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
          ]),
        ])),
      ]),
    );
  }

  Widget _statCol(String label, int val, Color color) {
    return Column(children: [
      Text('$val', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
      Text(label, style: AppTextStyles.caption),
    ]);
  }

  Widget _divider() => Container(width: 1, height: 30, color: AppColors.divider);

  Color _statusColor(String s) {
    switch (s) {
      case 'completed': return AppColors.success;
      case 'in_progress': return AppColors.info;
      case 'scheduled': return AppColors.warning;
      default: return AppColors.textSecondary;
    }
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'completed': return 'Selesai';
      case 'in_progress': return 'Berjalan';
      case 'scheduled': return 'Terjadwal';
      default: return 'Draft';
    }
  }

  void _showSendConfirmation(BuildContext context, _Campaign c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Kirim'),
        content: Text('Kirim kampanye "${c.name}" ke semua prospek cabang Anda?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Kampanye mulai dikirim'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.salesColor),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  void _showCreateCampaignSheet(BuildContext context) {
    final nameCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    String selectedTemplate = 'Promo Produk';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text('Buat Kampanye Baru', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Kampanye')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedTemplate,
              decoration: const InputDecoration(labelText: 'Template Pesan'),
              items: ['Promo Produk', 'Follow Up Prospek', 'Info Stok Baru', 'Custom']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => selectedTemplate = v!,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: msgCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Isi Pesan',
                hintText: 'Halo {nama}, kami punya penawaran spesial...',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.info.withOpacity(0.25)),
              ),
              child: Row(children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('Hanya prospek dari cabang Anda yang dapat dipilih sebagai penerima.', style: AppTextStyles.caption)),
              ]),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Simpan Draft'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kampanye berhasil dibuat'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.salesColor,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Jadwalkan'),
                ),
              ),
            ]),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  void _showEditCampaignDialog(BuildContext context, _Campaign campaign) {
    final nameController = TextEditingController(text: campaign.name);
    final selectedDateController = TextEditingController(text: campaign.scheduledDate);
    String selectedTemplate = 'Promo Aki Murah';
    String selectedGroup = 'Semua Pelanggan';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Kampanye'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kampanye',
                  prefixIcon: Icon(Icons.campaign_outlined),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Template Pesan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedTemplate,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.message_outlined),
                  border: OutlineInputBorder(),
                ),
                items: ['Promo Aki Murah', 'Diskon 50%', 'Info Produk Baru', 'Reminder Service']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (value) => selectedTemplate = value!,
              ),
              const SizedBox(height: 16),
              const Text('Grup Target', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedGroup,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.people_outline),
                  border: OutlineInputBorder(),
                ),
                items: ['Semua Pelanggan', 'Pelanggan Aktif', 'Pelanggan Baru', 'VIP']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) => selectedGroup = value!,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: selectedDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Jadwal Kirim',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                  suffixIcon: Icon(Icons.edit_calendar),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka kalender...')),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kampanye berhasil diperbarui'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.salesColor),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _Campaign {
  final String name, status, scheduledDate;
  final int sent, read, replied, failed;
  final String? scheduledTime;
  const _Campaign(this.name, this.status, this.sent, this.read, this.replied, this.failed, this.scheduledDate, this.scheduledTime);
}
