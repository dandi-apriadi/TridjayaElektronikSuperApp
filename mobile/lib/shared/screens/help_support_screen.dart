import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

/// ============================================================
/// ❓ HELP & SUPPORT SCREEN
/// Pusat bantuan dan dukungan pengguna yang diperbaiki
/// ============================================================

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> {
  final _searchController = TextEditingController();

  Future<void> _launchWhatsApp() async {
    final Uri url = Uri.parse('https://wa.me/6285161542103?text=Halo%20Admin%20Tridjaya,%20saya%20butuh%20bantuan...');
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka WhatsApp. Pastikan aplikasi terinstal.')),
        );
      }
    }
  }

  Future<void> _launchEmail() async {
    final Uri url = Uri.parse('mailto:dandimamonto.tridjaya03@gmail.com?subject=Bantuan%20Tridjaya%20SuperApp&body=Halo%20Admin,%0A%0ASaya%20mengalami%20kendala%20pada...');
    try {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch Email');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuka aplikasi Email.')),
        );
      }
    }
  }
  
  final List<FAQItem> _faqs = [
    FAQItem(
      question: 'Bagaimana cara submit task?',
      answer: 'Untuk submit task, buka menu Job Desk, pilih task yang ingin dikerjakan, klik tombol "Kerjakan Task", upload bukti yang diminta (foto/link/counter), lalu klik "Submit Task".',
      category: 'Task',
    ),
    FAQItem(
      question: 'Apa yang terjadi jika terlambat submit?',
      answer: 'Jika terlambat submit task melebihi deadline, sistem akan mencatat pelanggaran dan mungkin dikenakan denda sesuai kebijakan perusahaan.',
      category: 'Denda',
    ),
    FAQItem(
      question: 'Bagaimana cara mengubah password?',
      answer: 'Buka menu Profile > Keamanan > Ubah Password. Masukkan password saat ini dan password baru Anda.',
      category: 'Akun',
    ),
    FAQItem(
      question: 'Bagaimana cara menghubungi admin?',
      answer: 'Anda dapat menghubungi admin melalui menu "Hubungi Kami" atau melalui WhatsApp yang tersedia di bagian bawah halaman ini.',
      category: 'Kontak',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Bantuan & Dukungan'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Illustration / Icon
          const Center(
            child: Column(
              children: [
                Icon(Icons.help_center_outlined, size: 80, color: AppColors.primary),
                SizedBox(height: 16),
                Text(
                  'Ada yang bisa kami bantu?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Temukan jawaban dari pertanyaan Anda di bawah ini',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),

          // FAQ Section
          const Text(
            'Pertanyaan Populer',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ..._faqs.map((faq) => _buildFAQTile(faq)),

          const SizedBox(height: 32),

          // Contact Options
          const Text(
            'Hubungi Kami',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.chat_outlined,
            title: 'WhatsApp Support',
            subtitle: 'Respon cepat via WhatsApp',
            color: const Color(0xFF25D366),
            onTap: _launchWhatsApp,
          ),
          const SizedBox(height: 12),
          _buildContactCard(
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'dandimamonto.tridjaya03@gmail.com',
            color: AppColors.info,
            onTap: _launchEmail,
          ),

          const SizedBox(height: 40),
          
          // Version info
          Center(
            child: Text(
              'Tridjaya SuperApp v1.0.0',
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQTile(FAQItem faq) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.sm,
      ),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              faq.answer,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.sm,
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.question,
    required this.answer,
    required this.category,
  });
}
