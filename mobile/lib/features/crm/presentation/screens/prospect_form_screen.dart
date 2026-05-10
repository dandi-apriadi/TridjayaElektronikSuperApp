import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 👤 PROSPECT FORM SCREEN
/// Tambah/Edit data prospek
/// ============================================================

class ProspectFormScreen extends ConsumerStatefulWidget {
  final String? prospectId; // null = add, not null = edit

  const ProspectFormScreen({
    super.key,
    this.prospectId,
  });

  @override
  ConsumerState<ProspectFormScreen> createState() => _ProspectFormScreenState();
}

class _ProspectFormScreenState extends ConsumerState<ProspectFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _interestController = TextEditingController();
  final _budgetController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedSource = 'Walk-in';
  String _selectedStatus = 'hot';
  DateTime? _nextFollowUp;

  final List<String> _sources = [
    'Walk-in',
    'Referral',
    'Facebook Ads',
    'Instagram',
    'Telemarketing',
    'Google Ads',
    'Tokopedia',
    'Shopee',
    'Website',
    'Other',
  ];

  final List<Map<String, dynamic>> _statuses = [
    {'value': 'hot', 'label': 'Hot Lead', 'color': AppColors.error},
    {'value': 'warm', 'label': 'Warm', 'color': AppColors.warning},
    {'value': 'cold', 'label': 'Cold', 'color': AppColors.info},
  ];

  bool _isLoading = false;
  bool get _isEdit => widget.prospectId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      _loadProspectData();
    }
  }

  void _loadProspectData() {
    // Simulate loading existing prospect data
    // In real app, fetch from API
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _interestController.dispose();
    _budgetController.dispose();
    _notesController.dispose();
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
          _isEdit ? 'Edit Prospek' : 'Tambah Prospek Baru',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header Illustration
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isEdit ? Icons.edit : Icons.person_add,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isEdit
                        ? 'Perbarui data prospek'
                        : 'Isi data prospek baru dengan lengkap',
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

            // Section: Basic Info
            _buildSectionTitle('Informasi Dasar'),
            const SizedBox(height: 16),

            // Name
            _buildTextField(
              controller: _nameController,
              label: 'Nama Lengkap *',
              hint: 'Contoh: Budi Santoso',
              icon: Icons.person,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Nama wajib diisi';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Phone
            _buildTextField(
              controller: _phoneController,
              label: 'Nomor Telepon *',
              hint: 'Contoh: 081234567890',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Nomor telepon wajib diisi';
                if (value!.length < 10) return 'Nomor telepon minimal 10 digit';
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email
            _buildTextField(
              controller: _emailController,
              label: 'Email (Opsional)',
              hint: 'Contoh: email@domain.com',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isNotEmpty ?? false) {
                  if (!value!.contains('@')) return 'Format email tidak valid';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Address
            _buildTextField(
              controller: _addressController,
              label: 'Alamat (Opsional)',
              hint: 'Contoh: Jl. Sudirman No. 123, Bandung',
              icon: Icons.location_on,
              maxLines: 2,
            ),

            const SizedBox(height: 32),

            // Section: Lead Info
            _buildSectionTitle('Informasi Lead'),
            const SizedBox(height: 16),

            // Source
            _buildDropdownField(
              label: 'Sumber Lead',
              value: _selectedSource,
              items: _sources,
              icon: Icons.source,
              onChanged: (value) => setState(() => _selectedSource = value!),
            ),

            const SizedBox(height: 16),

            // Status
            const Text(
              'Status Lead *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: _statuses.map((status) {
                final isSelected = _selectedStatus == status['value'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => setState(
                          () => _selectedStatus = status['value']),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (status['color'] as Color).withOpacity(0.1)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? status['color'] as Color
                                : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _getStatusIcon(status['value']),
                              color: isSelected
                                  ? status['color'] as Color
                                  : AppColors.textHint,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              status['label'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? status['color'] as Color
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Section: Interest
            _buildSectionTitle('Minat & Budget'),
            const SizedBox(height: 16),

            // Interest
            _buildTextField(
              controller: _interestController,
              label: 'Produk yang Diminati *',
              hint: 'Contoh: TV 32 inch, AKI Mobil',
              icon: Icons.shopping_bag,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Produk yang diminati wajib diisi';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Budget
            _buildTextField(
              controller: _budgetController,
              label: 'Budget (Opsional)',
              hint: 'Contoh: 3000000',
              icon: Icons.monetization_on,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              prefixText: 'Rp ',
            ),

            const SizedBox(height: 32),

            // Section: Follow Up
            _buildSectionTitle('Follow Up'),
            const SizedBox(height: 16),

            // Next Follow Up
            InkWell(
              onTap: () => _selectFollowUpDate(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Icon(Icons.alarm, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jadwal Follow Up Berikutnya',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _nextFollowUp != null
                                ? DateFormat('EEEE, dd MMM yyyy HH:mm', 'id_ID')
                                    .format(_nextFollowUp!)
                                : 'Belum dijadwalkan',
                            style: TextStyle(
                              fontSize: 13,
                              color: _nextFollowUp != null
                                  ? AppColors.primary
                                  : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: AppColors.textHint),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Section: Notes
            _buildSectionTitle('Catatan'),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _notesController,
              label: 'Catatan (Opsional)',
              hint:
                  'Tambahkan catatan tentang prospek ini...\nContoh: Berminat serius, mau visit showroom',
              icon: Icons.notes,
              maxLines: 4,
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
                          'Tips',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Isi data dengan lengkap dan akurat untuk memudahkan follow up. Jangan lupa jadwalkan follow up berikutnya!',
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
                onPressed: _isLoading ? null : _submitForm,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(_isEdit ? Icons.save : Icons.person_add),
                label: Text(
                  _isLoading
                      ? 'Menyimpan...'
                      : _isEdit
                          ? 'Simpan Perubahan'
                          : 'Simpan Prospek',
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
            if (!_isLoading)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => context.pop(),
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
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
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
              borderSide:
                  BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
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
              borderSide:
                  BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'hot':
        return Icons.local_fire_department;
      case 'warm':
        return Icons.whatshot;
      case 'cold':
        return Icons.ac_unit;
      default:
        return Icons.person;
    }
  }

  Future<void> _selectFollowUpDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 10, minute: 0),
      );

      if (time != null) {
        setState(() {
          _nextFollowUp = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                _isEdit ? 'Prospek Diperbarui!' : 'Prospek Tersimpan!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isEdit
                    ? 'Data prospek berhasil diperbarui'
                    : 'Data prospek baru berhasil disimpan',
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
