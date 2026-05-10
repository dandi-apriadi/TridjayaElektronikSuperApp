import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 📢 CAMPAIGN FORM SCREEN
/// Buat/Edit kampanye marketing
/// ============================================================

class CampaignFormScreen extends ConsumerStatefulWidget {
  final String? campaignId; // null = add, not null = edit

  const CampaignFormScreen({
    super.key,
    this.campaignId,
  });

  @override
  ConsumerState<CampaignFormScreen> createState() => _CampaignFormScreenState();
}

class _CampaignFormScreenState extends ConsumerState<CampaignFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _budgetController = TextEditingController();
  final _targetAudienceController = TextEditingController();

  String _selectedType = 'Discount';
  String _selectedStatus = 'draft';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  final List<String> _selectedChannels = [];
  bool _isLoading = false;
  bool get _isEdit => widget.campaignId != null;

  final List<String> _campaignTypes = [
    'Discount',
    'Promo',
    'Bundle',
    'Flash Sale',
    'Trade-In',
    'Giveaway',
    'Referral',
    'Other',
  ];

  final List<String> _channels = [
    'WhatsApp',
    'Facebook',
    'Instagram',
    'TikTok',
    'Email',
    'SMS',
    'Shopee',
    'Tokopedia',
    'Flyer',
    'Banner',
  ];

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _loadCampaignData();
    }
  }

  void _loadCampaignData() {
    // Load existing campaign data
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _budgetController.dispose();
    _targetAudienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _isEdit ? 'Edit Kampanye' : 'Buat Kampanye Baru',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    _isEdit ? Icons.edit_note : Icons.campaign,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isEdit
                        ? 'Perbarui informasi kampanye'
                        : 'Rancang kampanye marketing yang efektif',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Basic Info
            _buildSectionTitle('Informasi Dasar'),
            const SizedBox(height: 16),

            // Name
            _buildTextField(
              controller: _nameController,
              label: 'Nama Kampanye *',
              hint: 'Contoh: Mega Sale Lebaran 2024',
              icon: Icons.title,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Nama kampanye wajib diisi';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description
            _buildTextField(
              controller: _descriptionController,
              label: 'Deskripsi *',
              hint: 'Jelaskan detail kampanye Anda...',
              icon: Icons.description,
              maxLines: 4,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Deskripsi wajib diisi';
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Campaign Type
            _buildSectionTitle('Tipe Kampanye'),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _campaignTypes.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedType = type);
                  },
                  label: Text(type),
                  selectedColor: AppColors.primary.withOpacity(0.1),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Date Range
            _buildSectionTitle('Periode Kampanye'),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDatePicker(
                    label: 'Tanggal Mulai',
                    date: _startDate,
                    onPick: (date) => setState(() => _startDate = date),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDatePicker(
                    label: 'Tanggal Selesai',
                    date: _endDate,
                    onPick: (date) => setState(() => _endDate = date),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Channels
            _buildSectionTitle('Channel Distribusi'),
            const SizedBox(height: 8),
            Text(
              'Pilih channel untuk menyebarkan kampanye',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _channels.map((channel) {
                final isSelected = _selectedChannels.contains(channel);
                return FilterChip(
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedChannels.add(channel);
                      } else {
                        _selectedChannels.remove(channel);
                      }
                    });
                  },
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getChannelIcon(channel),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(channel),
                    ],
                  ),
                  selectedColor: AppColors.primary.withOpacity(0.1),
                  checkmarkColor: AppColors.primary,
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Budget & Target
            _buildSectionTitle('Budget & Target'),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _budgetController,
              label: 'Budget (Opsional)',
              hint: 'Masukkan anggaran kampanye',
              icon: Icons.account_balance_wallet,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              prefixText: 'Rp ',
            ),

            const SizedBox(height: 16),

            _buildTextField(
              controller: _targetAudienceController,
              label: 'Target Audience (Opsional)',
              hint: 'Contoh: Pelanggan usia 25-40, Karyawan swasta',
              icon: Icons.people,
            ),

            const SizedBox(height: 24),

            // Status
            _buildSectionTitle('Status'),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Draft (Simpan dulu)'),
                    subtitle: const Text('Kampanye belum dipublikasikan'),
                    value: 'draft',
                    groupValue: _selectedStatus,
                    onChanged: (value) => setState(() => _selectedStatus = value!),
                    activeColor: AppColors.primary,
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Aktif (Langsung jalan)'),
                    subtitle: const Text('Kampanye langsung berjalan'),
                    value: 'active',
                    groupValue: _selectedStatus,
                    onChanged: (value) => setState(() => _selectedStatus = value!),
                    activeColor: AppColors.success,
                  ),
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Terjadwal (Jadwal otomatis)'),
                    subtitle: const Text('Kampanye akan berjalan sesuai tanggal mulai'),
                    value: 'scheduled',
                    groupValue: _selectedStatus,
                    onChanged: (value) => setState(() => _selectedStatus = value!),
                    activeColor: AppColors.warning,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tips Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: AppColors.info),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tips Kampanye Efektif',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Tentukan target yang spesifik\n• Pilih channel yang sesuai audience\n• Monitor hasil dan adjust strategy',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(_isEdit ? Icons.save : Icons.campaign),
                label: Text(
                  _isLoading
                      ? 'Menyimpan...'
                      : _isEdit
                          ? 'Simpan Perubahan'
                          : 'Buat Kampanye',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: _isLoading ? null : () => context.pop(),
                child: const Text('Batal'),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        prefixText: prefixText,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime date,
    required Function(DateTime) onPick,
  }) {
    final format = DateFormat('dd MMM yyyy', 'id_ID');

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onPick(picked);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  format.format(date),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getChannelIcon(String channel) {
    switch (channel.toLowerCase()) {
      case 'whatsapp':
        return Icons.chat;
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
      case 'tiktok':
        return Icons.camera_alt;
      case 'email':
        return Icons.email;
      case 'sms':
        return Icons.sms;
      case 'shopee':
      case 'tokopedia':
        return Icons.shopping_bag;
      case 'flyer':
      case 'banner':
        return Icons.print;
      default:
        return Icons.campaign;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedChannels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal satu channel distribusi'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isEdit ? 'Kampanye Diperbarui!' : 'Kampanye Dibuat!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedStatus == 'active'
                    ? 'Kampanye sudah aktif dan berjalan'
                    : _selectedStatus == 'scheduled'
                        ? 'Kampanye akan berjalan otomatis sesuai jadwal'
                        : 'Kampanye tersimpan sebagai draft',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
