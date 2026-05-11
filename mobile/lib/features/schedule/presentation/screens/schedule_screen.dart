import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/schedule_provider.dart';
import '../../models/schedule_models.dart' as backend_schedule;

/// ============================================================
/// 📅 EMPLOYEE SCHEDULE SCREEN
/// Jadwal kerja karyawan (view for employees)
/// ============================================================

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(myScheduleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Jadwal Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.today, color: Colors.white),
            onPressed: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: scheduleAsync.when(
        data: (shifts) {
          final eventsByDay = _groupEventsByDay(shifts);
          return Column(
            children: [
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
                  eventLoader: (day) => _getEventsForDay(day, eventsByDay),
                  calendarStyle: CalendarStyle(
                    markersMaxCount: 3,
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
              Expanded(
                child: _buildEventsList(eventsByDay),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Gagal memuat jadwal: $error')),
      ),
    );
  }

  Map<DateTime, List<ScheduleEvent>> _groupEventsByDay(List<backend_schedule.Shift> shifts) {
    final grouped = <DateTime, List<ScheduleEvent>>{};

    for (final shift in shifts) {
      final startTime = DateTime.tryParse(shift.startTime);
      final key = DateTime(
        (startTime ?? DateTime.now()).year,
        (startTime ?? DateTime.now()).month,
        (startTime ?? DateTime.now()).day,
      );
      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(_toScheduleEvent(shift));
    }

    return grouped;
  }

  List<ScheduleEvent> _getEventsForDay(DateTime day, Map<DateTime, List<ScheduleEvent>> eventsByDay) {
    return eventsByDay[DateTime(day.year, day.month, day.day)] ?? [];
  }

  ScheduleEvent _toScheduleEvent(backend_schedule.Shift shift) {
    final startTime = DateTime.tryParse(shift.startTime);
    final endTime = DateTime.tryParse(shift.endTime);
    final time = startTime != null && endTime != null
        ? '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}'
        : shift.startTime;

    return ScheduleEvent(
      id: shift.id,
      title: shift.title,
      time: time,
      location: shift.location ?? '-',
      type: _mapShiftType(shift.shiftType),
      status: _mapShiftStatus(shift.status),
    );
  }

  EventType _mapShiftType(String shiftType) {
    switch (shiftType.toLowerCase()) {
      case 'morning':
        return EventType.meeting;
      case 'afternoon':
        return EventType.visit;
      case 'night':
        return EventType.call;
      default:
        return EventType.training;
    }
  }

  EventStatus _mapShiftStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return EventStatus.completed;
      case 'cancelled':
        return EventStatus.cancelled;
      case 'in_progress':
        return EventStatus.inProgress;
      default:
        return EventStatus.scheduled;
    }
  }

  Widget _buildEventsList(Map<DateTime, List<ScheduleEvent>> eventsByDay) {
    final selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay, eventsByDay);
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
                        'Jadwal',
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
                    '${selectedEvents.length} Aktivitas',
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
            'Tidak Ada Jadwal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hari ini tidak ada aktivitas yang dijadwalkan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(ScheduleEvent event) {
    Color typeColor;
    IconData typeIcon;

    switch (event.type) {
      case EventType.visit:
        typeColor = AppColors.info;
        typeIcon = Icons.directions_car;
        break;
      case EventType.meeting:
        typeColor = AppColors.warning;
        typeIcon = Icons.groups;
        break;
      case EventType.call:
        typeColor = AppColors.success;
        typeIcon = Icons.phone;
        break;
      case EventType.training:
        typeColor = AppColors.primary;
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
            // Time indicator
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: event.status == EventStatus.completed
                    ? AppColors.success
                    : typeColor,
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
                        if (event.status == EventStatus.completed)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  size: 12,
                                  color: AppColors.success,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Selesai',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Schedule Event Model
class ScheduleEvent {
  final String id;
  final String title;
  final String time;
  final String location;
  final EventType type;
  final EventStatus status;

  ScheduleEvent({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.type,
    required this.status,
  });
}

enum EventType {
  visit,
  meeting,
  call,
  training,
  other,
}

enum EventStatus {
  scheduled,
  inProgress,
  completed,
  cancelled,
}
