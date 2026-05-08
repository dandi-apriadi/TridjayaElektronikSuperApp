import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/jobdesk_dummy_data.dart';
import '../../models/jobdesk_models.dart';

/// ============================================================
/// 👔 JOB DESK TEMPLATE LIST SCREEN - Owner/Superadmin
/// ============================================================
/// Screen untuk mengelola semua template job desk per role
/// - List templates
/// - Filter by role
/// - Activate/deactivate
/// ============================================================

class JobDeskTemplateListScreen extends ConsumerStatefulWidget {
  const JobDeskTemplateListScreen({super.key});

  @override
  ConsumerState<JobDeskTemplateListScreen> createState() => _JobDeskTemplateListScreenState();
}

class _JobDeskTemplateListScreenState extends ConsumerState<JobDeskTemplateListScreen> {
  String _selectedRole = 'all';
  final List<Map<String, String>> _roles = [
    {'value': 'all', 'label': 'Semua Role'},
    {'value': 'support_online', 'label': 'Support Online'},
    {'value': 'sales', 'label': 'Sales'},
    {'value': 'driver', 'label': 'Driver'},
    {'value': 'admin', 'label': 'Admin'},
    {'value': 'kepala_cabang', 'label': 'Kepala Cabang'},
  ];

  @override
  Widget build(BuildContext context) {
    final templates = _selectedRole == 'all'
        ? JobDeskDummyData.allTemplates
        : JobDeskDummyData.allTemplates.where((t) => t.role == _selectedRole).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.ownerColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Kelola Template Job Desk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => context.push('/jobdesk/templates/create'),
            tooltip: 'Buat Template Baru',
          ),
        ],
      ),
      body: Column(
        children: [
          // Role Filter
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _roles.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final role = _roles[index];
                  final isSelected = _selectedRole == role['value'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRole = role['value']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.ownerColor : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role['label']!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Template Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${templates.length} Template${_selectedRole != 'all' ? ' - ${_roles.firstWhere((r) => r['value'] == _selectedRole)['label']}' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                // Monitoring Button
                TextButton.icon(
                  onPressed: () => context.push('/jobdesk/monitoring'),
                  icon: const Icon(Icons.analytics_outlined, size: 18),
                  label: const Text('Monitoring'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.ownerColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Template List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: templates.length,
              itemBuilder: (context, index) {
                return _buildTemplateCard(templates[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/jobdesk/templates/create'),
        backgroundColor: AppColors.ownerColor,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Template Baru'),
      ),
    );
  }

  Widget _buildTemplateCard(JobDeskTemplate template) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.sm,
      ),
      child: InkWell(
        onTap: () => _showTemplateDetail(template),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRoleColor(template.role).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getRoleLabel(template.role),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getRoleColor(template.role),
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Status Switch
                  Row(
                    children: [
                      Text(
                        template.isActive ? 'Aktif' : 'Nonaktif',
                        style: TextStyle(
                          fontSize: 12,
                          color: template.isActive ? AppColors.success : AppColors.textHint,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: template.isActive,
                        onChanged: (value) => _toggleTemplateStatus(template.id, value),
                        activeColor: AppColors.success,
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Template Name
              Text(
                template.name,
                style: AppTextStyles.subtitle,
              ),
              
              // Description
              if (template.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  template.description!,
                  style: AppTextStyles.caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              
              // Stats
              Row(
                children: [
                  _buildStatItem(
                    icon: Icons.checklist_outlined,
                    label: '${template.tasks.length} Tugas',
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    icon: Icons.camera_alt_outlined,
                    label: '${template.tasks.where((t) => t.requiresProof).length} Bukti',
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    icon: Icons.warning_amber_outlined,
                    label: '${template.tasks.where((t) => t.isMandatory).length} Wajib',
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => context.push('/jobdesk/templates/edit/${template.id}'),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showAssignDialog(template),
                      icon: const Icon(Icons.person_add_outlined, size: 16),
                      label: const Text('Assign'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.success,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'support_online':
        return const Color(0xFF9333EA); // Purple
      case 'sales':
        return AppColors.salesColor;
      case 'driver':
        return AppColors.warning;
      case 'admin':
        return AppColors.adminColor;
      case 'kepala_cabang':
        return AppColors.kepalaCabangColor;
      default:
        return AppColors.primary;
    }
  }

  String _getRoleLabel(String role) {
    switch (role) {
      case 'support_online':
        return 'Support Online';
      case 'sales':
        return 'Sales';
      case 'driver':
        return 'Driver';
      case 'admin':
        return 'Admin';
      case 'kepala_cabang':
        return 'Kepala Cabang';
      default:
        return role;
    }
  }

  void _toggleTemplateStatus(String id, bool value) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Template ${value ? 'diaktifkan' : 'dinonaktifkan'}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    setState(() {});
  }

  void _showTemplateDetail(JobDeskTemplate template) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getRoleColor(template.role).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getRoleLabel(template.role),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _getRoleColor(template.role),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        template.name,
                        style: AppTextStyles.heading3,
                      ),
                      if (template.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          template.description!,
                          style: AppTextStyles.body,
                        ),
                      ],
                    ],
                  ),
                ),
                
                const Divider(),
                
                // Task List
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: template.tasks.length,
                    itemBuilder: (context, index) {
                      final task = template.tasks[index];
                      return _buildTaskDetailItem(task, index + 1);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskDetailItem(JobDeskTaskItem task, int number) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: task.isHighlighted ? const Color(0xFFFFD93D) : AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: task.isHighlighted ? Colors.black : AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: task.isHighlighted ? FontWeight.w700 : FontWeight.w500,
                    color: task.isHighlighted ? const Color(0xFF856404) : AppColors.textPrimary,
                  ),
                ),
                if (task.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description!,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    if (task.requiresProof)
                      _buildDetailChip(
                        icon: _getProofIcon(task.proofType),
                        label: 'Bukti ${_getProofLabel(task.proofType)}',
                        color: AppColors.warning,
                      ),
                    if (task.isMandatory)
                      _buildDetailChip(
                        icon: Icons.priority_high,
                        label: 'Wajib',
                        color: AppColors.error,
                      ),
                    if (task.type == JobDeskTaskType.counter && task.targetValue != null)
                      _buildDetailChip(
                        icon: Icons.flag,
                        label: 'Target: ${task.targetValue} ${task.targetUnit ?? ''}',
                        color: AppColors.info,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getProofIcon(JobDeskProofType? type) {
    switch (type) {
      case JobDeskProofType.photo:
        return Icons.camera_alt_outlined;
      case JobDeskProofType.document:
        return Icons.description_outlined;
      case JobDeskProofType.link:
        return Icons.link_outlined;
      case JobDeskProofType.screenshot:
        return Icons.screenshot_outlined;
      default:
        return Icons.attachment_outlined;
    }
  }

  String _getProofLabel(JobDeskProofType? type) {
    switch (type) {
      case JobDeskProofType.photo:
        return 'Foto';
      case JobDeskProofType.document:
        return 'Dokumen';
      case JobDeskProofType.link:
        return 'Link';
      case JobDeskProofType.screenshot:
        return 'Screenshot';
      default:
        return 'File';
    }
  }

  void _showAssignDialog(JobDeskTemplate template) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign ${template.name}'),
        content: const Text(
          'Fitur ini akan menampilkan daftar karyawan untuk di-assign template.\n\n'
          'Coming Soon: Multi-select employee picker',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
