import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_model.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// ============================================================
/// 👤 PERSONAL INFO SCREEN
/// Informasi pribadi pengguna
/// ============================================================

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  
  bool _isLoading = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: 'budi.santoso@email.com');
    _phoneController = TextEditingController(text: '081234567890');
    _addressController = TextEditingController(text: 'Jl. Sudirman No. 123, Jakarta');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
          _isEditing = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Informasi berhasil diperbarui'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Informasi Pribadi',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _saveChanges();
                } else {
                  _isEditing = true;
                }
              });
            },
            child: Text(
              _isEditing ? 'Simpan' : 'Edit',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Avatar Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.1),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              user?.username.substring(0, 1).toUpperCase() ?? 'B',
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_isEditing)
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ganti foto - Upload dari galeri/kamera'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: const Text('Ganti Foto Profil'),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Basic Info Section
              _buildSectionHeader('Informasi Dasar'),
              const SizedBox(height: 12),
              _buildInfoCard([
                _buildTextField(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline,
                  enabled: _isEditing,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Nama tidak boleh kosong';
                    return null;
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  enabled: _isEditing,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Email tidak boleh kosong';
                    if (!value!.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildTextField(
                  controller: _phoneController,
                  label: 'Nomor Telepon',
                  icon: Icons.phone_outlined,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Nomor telepon tidak boleh kosong';
                    if (value!.length < 10) return 'Nomor telepon tidak valid';
                    return null;
                  },
                ),
              ]),

              const SizedBox(height: 24),

              // Work Info Section
              _buildSectionHeader('Informasi Pekerjaan'),
              const SizedBox(height: 12),
              _buildInfoCard([
                _buildReadOnlyTile(
                  icon: Icons.badge_outlined,
                  label: 'ID Karyawan',
                  value: user?.id ?? 'EMP001',
                ),
                const Divider(height: 1, indent: 56),
                _buildReadOnlyTile(
                  icon: Icons.work_outline,
                  label: 'Jabatan',
                  value: user?.role.displayName ?? 'Sales',
                ),
                const Divider(height: 1, indent: 56),
                _buildReadOnlyTile(
                  icon: Icons.store_outlined,
                  label: 'Cabang',
                  value: user?.branchName ?? 'Cabang Pusat',
                ),
                const Divider(height: 1, indent: 56),
                _buildReadOnlyTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Bergabung Sejak',
                  value: '15 Januari 2023',
                ),
              ]),

              const SizedBox(height: 24),

              // Address Section
              _buildSectionHeader('Alamat'),
              const SizedBox(height: 12),
              _buildInfoCard([
                _buildTextField(
                  controller: _addressController,
                  label: 'Alamat Lengkap',
                  icon: Icons.location_on_outlined,
                  enabled: _isEditing,
                  maxLines: 3,
                ),
              ]),

              const SizedBox(height: 24),

              // Account Info
              _buildSectionHeader('Informasi Akun'),
              const SizedBox(height: 12),
              _buildInfoCard([
                _buildReadOnlyTile(
                  icon: Icons.verified_user_outlined,
                  label: 'Status Akun',
                  value: 'Aktif',
                  valueColor: AppColors.success,
                ),
                const Divider(height: 1, indent: 56),
                _buildReadOnlyTile(
                  icon: Icons.access_time_outlined,
                  label: 'Terakhir Login',
                  value: 'Hari ini, 09:30',
                ),
              ]),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 14,
            color: enabled ? AppColors.textSecondary : AppColors.textHint,
          ),
          prefixIcon: Icon(icon, color: enabled ? AppColors.primary : AppColors.textHint, size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildReadOnlyTile({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
