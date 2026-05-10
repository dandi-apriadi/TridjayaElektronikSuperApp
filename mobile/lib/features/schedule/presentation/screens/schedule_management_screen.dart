import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/user_model.dart';

/// ============================================================
/// 📅 SCHEDULE MANAGEMENT SCREEN
/// Kepala Cabang mengatur jadwal tim
/// ============================================================

class ScheduleManagementScreen extends ConsumerStatefulWidget {
  const ScheduleManagementScreen({super.key});

  @override
  ConsumerState<ScheduleManagementScreen> createState() => _ScheduleManagementScreenState();
}

class _ScheduleManagementScreenState extends ConsumerState<ScheduleManagementScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _selectedEmployee = 'all';

  // Dummy employees
  final List<Map<String, dynamic>> _employees = [
    {'id': 'all', 'name': 'Semua Karyawan', 'role': 'Team'},
    {'id': '1', 'name': 'Ahmad Santoso', 'role': 'Sales'},
    {'id': '2', 'name': 'Budi Wijaya', 'role': 'Sales'},
    {'id': '3', 'name': 'Citra Dewi', 'role': 'Driver'},
    {'id': '4', 'name': 'Dedi Kurniawan', 'role': 'Driver'},
    {'id': '5', 'name': 'Eka Putri', 'role': 'Admin'},
  ];

  // Dummy events
  final Map<DateTime, List<ScheduleItem>> _teamEvents = {
    DateTime.now(): [
      ScheduleItem(
        id: '1',
        employeeId: '1',
        employeeName: 'Ahmad Santoso',
        title: 'Kunjungan Prospek',
        time: '08:00 - 12:00',
        location: 'Area Bandung Selatan',
        type: ScheduleType.visit,
        date: DateTime.now(),
      ),
      ScheduleItem(
        id: '2',
        employeeId: '2',
        employeeName: 'Budi Wijaya',
        title: 'Meeting Klien',
        time: '14:00 - 15:30',
        location: 'Kantor Cabang',
        type: ScheduleType.meeting,
        date: DateTime.now(),
      ),
    ],
    DateTime.now().add(const Duration(days: 1)): [
      ScheduleItem(
        id: '3',
        employeeId: '3',
        employeeName: 'Citra Dewi',
        title: 'Pengiriman Unit',
        time: '09:00 - 15:00',
        location: 'Area Cibaduyut',
        type: ScheduleType.delivery,
        date: DateTime.now().add(const Duration(days: 1)),
      ),
    ],
  };

  List<ScheduleItem> _getEventsForDay(DateTime day) {
    final events = _teamEvents[DateTime(day.year, day.month, day.day)] ?? [];
    if (_selectedEmployee == 'all') return events;
    return events.where((e) => e.employeeId == _selectedEmployee).toList();
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
          'Kelola Jadwal Tim',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: _showAddScheduleDialog,
            tooltip: 'Tambah Jadwal',
          ),
        ],
      ),
      body: Column(
        children: [
          // Employee Selector
          _buildEmployeeSelector(),

          // Calendar
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: AppShadows.sm,
            ),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 365)),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: _getEventsForDay,
              calendarStyle: CalendarStyle(
                markersMaxCount: 5,
                markerDecoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                formatButtonDecoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                formatButtonTextStyle: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          // Events List
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddScheduleDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Jadwal'),
      ),
    );
  }

  Widget _buildEmployeeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Karyawan',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                final isSelected = _selectedEmployee == employee['id'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedEmployee = employee['id']);
                    },
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (employee['id'] != 'all')
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: _getRoleColor(employee['role']).withOpacity(0.2),
                            child: Text(
                              employee['name'].substring(0, 1),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getRoleColor(employee['role']),
                              ),
                            ),
                          ),
                        if (employee['id'] != 'all') const SizedBox(width: 8),
                        Text(employee['name']),
                      ],
                    ),
                    selectedColor: AppColors.primary.withOpacity(0.1),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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

  Widget _buildEventsList() {
    final selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.event_note,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jadwal Tim',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textHint,
                        ),
                      ),
                      Text(
                        dateFormat.format(_selectedDay ?? _focusedDay),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${selectedEvents.length} Jadwal',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.divider),

          // Events
          Expanded(
            child: selectedEvents.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: selectedEvents.length,
                    itemBuilder: (context, index) {
                      return _buildEventCard(selectedEvents[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Jadwal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tambahkan jadwal untuk tim Anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _showAddScheduleDialog,
            icon: const Icon(Icons.add),
            label: const Text('Tambah Jadwal'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(ScheduleItem event) {
    Color typeColor;
    IconData typeIcon;

    switch (event.type) {
      case ScheduleType.visit:
        typeColor = AppColors.info;
        typeIcon = Icons.directions_car;
        break;
      case ScheduleType.meeting:
        typeColor = AppColors.warning;
        typeIcon = Icons.groups;
        break;
      case ScheduleType.call:
        typeColor = AppColors.success;
        typeIcon = Icons.phone;
        break;
      case ScheduleType.delivery:
        typeColor = AppColors.primary;
        typeIcon = Icons.local_shipping;
        break;
      case ScheduleType.training:
        typeColor = AppColors.secondary;
        typeIcon = Icons.school;
        break;
      default:
        typeColor = AppColors.textHint;
        typeIcon = Icons.event;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withOpacity(0.5)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Color indicator
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(typeIcon, size: 16, color: typeColor),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                event.time,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showEditScheduleDialog(event);
                            } else if (value == 'delete') {
                              _showDeleteConfirmation(event);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 18, color: AppColors.error),
                                  SizedBox(width: 8),
                                  Text('Hapus', style: TextStyle(color: AppColors.error)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          event.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person, size: 12, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            event.employeeName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddScheduleDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _ScheduleForm(
            controller: scrollController,
            employees: _employees.where((e) => e['id'] != 'all').toList(),
            selectedDate: _selectedDay ?? _focusedDay,
            onSave: (schedule) {
              setState(() {
                final date = DateTime(
                  schedule.date.year,
                  schedule.date.month,
                  schedule.date.day,
                );
                if (_teamEvents[date] == null) {
                  _teamEvents[date] = [];
                }
                _teamEvents[date]!.add(schedule);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Jadwal berhasil ditambahkan'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditScheduleDialog(ScheduleItem event) {
    // Similar to add but with pre-filled data
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return _ScheduleForm(
            controller: scrollController,
            employees: _employees.where((e) => e['id'] != 'all').toList(),
            selectedDate: _selectedDay ?? _focusedDay,
            existingSchedule: event,
            onSave: (schedule) {
              // Update logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Jadwal berhasil diperbarui'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(ScheduleItem event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Jadwal?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus jadwal "${event.title}" untuk ${event.employeeName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final date = DateTime(
                  _selectedDay?.year ?? _focusedDay.year,
                  _selectedDay?.month ?? _focusedDay.month,
                  _selectedDay?.day ?? _focusedDay.day,
                );
                _teamEvents[date]?.removeWhere((e) => e.id == event.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ Jadwal dihapus'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

// Schedule Form Widget
class _ScheduleForm extends StatefulWidget {
  final ScrollController controller;
  final List<Map<String, dynamic>> employees;
  final DateTime selectedDate;
  final ScheduleItem? existingSchedule;
  final Function(ScheduleItem) onSave;

  const _ScheduleForm({
    required this.controller,
    required this.employees,
    required this.selectedDate,
    this.existingSchedule,
    required this.onSave,
  });

  @override
  State<_ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<_ScheduleForm> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedEmployee;
  late String _title;
  late String _location;
  late ScheduleType _type;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _selectedEmployee = widget.existingSchedule?.employeeId ?? 
                        widget.employees.first['id'];
    _title = widget.existingSchedule?.title ?? '';
    _location = widget.existingSchedule?.location ?? '';
    _type = widget.existingSchedule?.type ?? ScheduleType.visit;
    _startTime = TimeOfDay(hour: 8, minute: 0);
    _endTime = TimeOfDay(hour: 17, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: ListView(
        controller: widget.controller,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            widget.existingSchedule == null ? 'Tambah Jadwal Baru' : 'Edit Jadwal',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(widget.selectedDate),
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 24),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Employee Selection
                const Text(
                  'Karyawan',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedEmployee,
                  decoration: _inputDecoration(),
                  items: widget.employees.map((e) {
                    return DropdownMenuItem<String>(
                      value: e['id'] as String,
                      child: Text('${e['name']} (${e['role']})'),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedEmployee = value!),
                ),

                const SizedBox(height: 16),

                // Event Title
                const Text(
                  'Judul Aktivitas',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _title,
                  decoration: _inputDecoration(hint: 'Contoh: Kunjungan Prospek'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                  onSaved: (value) => _title = value!,
                ),

                const SizedBox(height: 16),

                // Event Type
                const Text(
                  'Tipe Aktivitas',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ScheduleType.values.map((type) {
                    final isSelected = _type == type;
                    return ChoiceChip(
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _type = type);
                      },
                      label: Text(_getTypeLabel(type)),
                      selectedColor: AppColors.primary.withOpacity(0.1),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Time Selection
                const Text(
                  'Waktu',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        label: 'Mulai',
                        time: _startTime,
                        onPick: (time) => setState(() => _startTime = time),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker(
                        label: 'Selesai',
                        time: _endTime,
                        onPick: (time) => setState(() => _endTime = time),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Location
                const Text(
                  'Lokasi',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: _location,
                  decoration: _inputDecoration(hint: 'Contoh: Kantor Cabang'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Wajib diisi' : null,
                  onSaved: (value) => _location = value!,
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      widget.existingSchedule == null ? 'Simpan Jadwal' : 'Perbarui Jadwal',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
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
      contentPadding: const EdgeInsets.all(16),
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay time,
    required Function(TimeOfDay) onPick,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
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
            Text(
              time.format(context),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(ScheduleType type) {
    switch (type) {
      case ScheduleType.visit:
        return 'Kunjungan';
      case ScheduleType.meeting:
        return 'Meeting';
      case ScheduleType.call:
        return 'Telepon';
      case ScheduleType.delivery:
        return 'Pengiriman';
      case ScheduleType.training:
        return 'Pelatihan';
      default:
        return 'Lainnya';
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final employee = widget.employees.firstWhere(
      (e) => e['id'] == _selectedEmployee,
    );

    final schedule = ScheduleItem(
      id: widget.existingSchedule?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      employeeId: _selectedEmployee,
      employeeName: employee['name'],
      title: _title,
      time: '${_startTime.format(context)} - ${_endTime.format(context)}',
      location: _location,
      type: _type,
      date: widget.selectedDate,
    );

    widget.onSave(schedule);
  }
}

// Models
class ScheduleItem {
  final String id;
  final String employeeId;
  final String employeeName;
  final String title;
  final String time;
  final String location;
  final ScheduleType type;
  final DateTime date;

  ScheduleItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.title,
    required this.time,
    required this.location,
    required this.type,
    required this.date,
  });
}

enum ScheduleType {
  visit,
  meeting,
  call,
  delivery,
  training,
  other,
}
