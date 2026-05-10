import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 📋 TASK LIST SCREEN
/// Kepala Cabang melihat & monitor semua tugas tim
/// ============================================================

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String _selectedFilter = 'all'; // all, pending, in_progress, completed, overdue
  String _selectedEmployee = 'all';

  // Dummy tasks
  final List<Map<String, dynamic>> _tasks = [
    {
      'id': '1',
      'title': 'Kunjungan Prospek PT Maju Jaya',
      'employee': {'name': 'Ahmad Santoso', 'avatar': 'AS', 'role': 'Sales'},
      'type': 'Kunjungan',
      'priority': 'high',
      'status': 'in_progress',
      'dueDate': DateTime.now().add(const Duration(hours: 4)),
      'location': 'Jl. Sudirman No. 123',
      'requiresPhoto': true,
      'hasPhoto': false,
      'notes': 'Bawa sample produk',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '2',
      'title': 'Pengiriman 5 unit TV ke Cibaduyut',
      'employee': {'name': 'Citra Dewi', 'avatar': 'CD', 'role': 'Driver'},
      'type': 'Pengiriman',
      'priority': 'urgent',
      'status': 'pending',
      'dueDate': DateTime.now().add(const Duration(hours: 2)),
      'location': 'Komplek Cibaduyut Indah',
      'requiresPhoto': true,
      'hasPhoto': false,
      'notes': 'Konfirmasi sebelum berangkat',
      'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '3',
      'title': 'Follow up nasabah bulan lalu',
      'employee': {'name': 'Budi Wijaya', 'avatar': 'BW', 'role': 'Sales'},
      'type': 'Telepon',
      'priority': 'medium',
      'status': 'completed',
      'dueDate': DateTime.now().subtract(const Duration(hours: 2)),
      'location': 'Via Telepon',
      'requiresPhoto': false,
      'hasPhoto': false,
      'notes': 'Sudah dihubungi 15 nasabah',
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '4',
      'title': 'Input data penjualan harian',
      'employee': {'name': 'Eka Putri', 'avatar': 'EP', 'role': 'Admin'},
      'type': 'Administrasi',
      'priority': 'low',
      'status': 'overdue',
      'dueDate': DateTime.now().subtract(const Duration(hours: 5)),
      'location': 'Kantor Cabang',
      'requiresPhoto': false,
      'hasPhoto': false,
      'notes': 'Deadline kemarin',
      'createdAt': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '5',
      'title': 'Survey lokasi cabang baru',
      'employee': {'name': 'Dedi Kurniawan', 'avatar': 'DK', 'role': 'Sales'},
      'type': 'Survey',
      'priority': 'high',
      'status': 'pending',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'location': 'Area Cimahi',
      'requiresPhoto': true,
      'hasPhoto': false,
      'notes': 'Ambil foto lokasi',
      'createdAt': DateTime.now(),
    },
  ];

  final List<Map<String, dynamic>> _employees = [
    {'id': 'all', 'name': 'Semua Karyawan'},
    {'id': '1', 'name': 'Ahmad Santoso'},
    {'id': '2', 'name': 'Budi Wijaya'},
    {'id': '3', 'name': 'Citra Dewi'},
    {'id': '4', 'name': 'Dedi Kurniawan'},
    {'id': '5', 'name': 'Eka Putri'},
  ];

  List<Map<String, dynamic>> get _filteredTasks {
    return _tasks.where((task) {
      if (_selectedFilter != 'all' && task['status'] != _selectedFilter) {
        return false;
      }
      if (_selectedEmployee != 'all' &&
          task['employee']['name'] !=
              _employees.firstWhere((e) => e['id'] == _selectedEmployee)['name']) {
        return false;
      }
      return true;
    }).toList();
  }

  Map<String, int> get _statusCounts {
    return {
      'all': _tasks.length,
      'pending': _tasks.where((t) => t['status'] == 'pending').length,
      'in_progress': _tasks.where((t) => t['status'] == 'in_progress').length,
      'completed': _tasks.where((t) => t['status'] == 'completed').length,
      'overdue': _tasks.where((t) => t['status'] == 'overdue').length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Daftar Tugas Tim',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),

          // Filters
          _buildFilters(),

          // Task List
          Expanded(
            child: _filteredTasks.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredTasks.length,
                    itemBuilder: (context, index) {
                      return _buildTaskCard(_filteredTasks[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/kepala-cabang/tasks/assign'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Assign Tugas'),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final counts = _statusCounts;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSummaryCard(
              label: 'Total',
              value: '${counts['all']}',
              color: Colors.white,
            ),
            _buildSummaryCard(
              label: 'Pending',
              value: '${counts['pending']}',
              color: AppColors.warning,
            ),
            _buildSummaryCard(
              label: 'Berjalan',
              value: '${counts['in_progress']}',
              color: AppColors.info,
            ),
            _buildSummaryCard(
              label: 'Selesai',
              value: '${counts['completed']}',
              color: AppColors.success,
            ),
            _buildSummaryCard(
              label: 'Terlambat',
              value: '${counts['overdue']}',
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          // Status Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Semua', 'all', Icons.all_inclusive),
                const SizedBox(width: 8),
                _buildFilterChip('Pending', 'pending', Icons.pending),
                const SizedBox(width: 8),
                _buildFilterChip('Berjalan', 'in_progress', Icons.play_circle),
                const SizedBox(width: 8),
                _buildFilterChip('Selesai', 'completed', Icons.check_circle),
                const SizedBox(width: 8),
                _buildFilterChip('Terlambat', 'overdue', Icons.warning),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Employee Filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.divider),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedEmployee,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down),
                items: _employees.map((emp) {
                  return DropdownMenuItem<String>(
                    value: emp['id'] as String,
                    child: Text(emp['name'] as String),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedEmployee = value!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _selectedFilter == value;

    Color chipColor;
    switch (value) {
      case 'pending':
        chipColor = AppColors.warning;
        break;
      case 'in_progress':
        chipColor = AppColors.info;
        break;
      case 'completed':
        chipColor = AppColors.success;
        break;
      case 'overdue':
        chipColor = AppColors.error;
        break;
      default:
        chipColor = AppColors.primary;
    }

    return FilterChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: chipColor.withOpacity(0.1),
      checkmarkColor: chipColor,
      labelStyle: TextStyle(
        color: isSelected ? chipColor : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Tugas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Assign tugas baru ke tim Anda',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/kepala-cabang/tasks/assign'),
            icon: const Icon(Icons.add),
            label: const Text('Assign Tugas'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final status = task['status'] as String;
    final priority = task['priority'] as String;
    final employee = task['employee'] as Map<String, dynamic>;
    final dateFormat = DateFormat('dd MMM, HH:mm');

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case 'pending':
        statusColor = AppColors.warning;
        statusLabel = 'Pending';
        statusIcon = Icons.pending;
        break;
      case 'in_progress':
        statusColor = AppColors.info;
        statusLabel = 'Dikerjakan';
        statusIcon = Icons.play_circle;
        break;
      case 'completed':
        statusColor = AppColors.success;
        statusLabel = 'Selesai';
        statusIcon = Icons.check_circle;
        break;
      case 'overdue':
        statusColor = AppColors.error;
        statusLabel = 'Terlambat';
        statusIcon = Icons.warning;
        break;
      default:
        statusColor = AppColors.textHint;
        statusLabel = status;
        statusIcon = Icons.help;
    }

    Color priorityColor;
    switch (priority) {
      case 'urgent':
        priorityColor = Colors.purple;
        break;
      case 'high':
        priorityColor = AppColors.error;
        break;
      case 'medium':
        priorityColor = AppColors.warning;
        break;
      default:
        priorityColor = AppColors.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: InkWell(
        onTap: () => _showTaskDetail(task),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header with status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.flag, size: 14, color: priorityColor),
                        const SizedBox(width: 4),
                        Text(
                          priority.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: priorityColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Employee info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: _getRoleColor(employee['role']).withOpacity(0.2),
                        child: Text(
                          employee['avatar'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getRoleColor(employee['role']),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              employee['role'],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Task title
                  Text(
                    task['title'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Task details
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        'Deadline: ${dateFormat.format(task['dueDate'])}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          task['location'],
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Photo requirement indicator
                  if (task['requiresPhoto']) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.photo_camera,
                          size: 14,
                          color: task['hasPhoto'] ? AppColors.success : AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          task['hasPhoto'] ? 'Foto sudah diupload' : 'Wajib upload foto',
                          style: TextStyle(
                            fontSize: 12,
                            color: task['hasPhoto'] ? AppColors.success : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Sales':
        return AppColors.salesColor;
      case 'Driver':
        return AppColors.driverColor;
      case 'Admin':
        return AppColors.adminColor;
      default:
        return AppColors.primary;
    }
  }

  void _showTaskDetail(Map<String, dynamic> task) {
    // Show task detail modal
  }

  void _showFilterBottomSheet() {
    // Show filter options
  }
}
