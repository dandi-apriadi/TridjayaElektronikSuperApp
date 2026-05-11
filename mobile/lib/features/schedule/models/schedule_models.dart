import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_models.freezed.dart';
part 'schedule_models.g.dart';

/// ============================================================
/// SCHEDULE MODELS
/// ============================================================

@freezed
class Shift with _$Shift {
  const factory Shift({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    @JsonKey(name: 'shift_type') required String shiftType, // morning, afternoon, night, custom
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    String? location,
    String? notes,
    required String status, // scheduled, completed, cancelled
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Shift;

  factory Shift.fromJson(Map<String, dynamic> json) =>
      _$ShiftFromJson(json);
}

@freezed
class ScheduleEvent with _$ScheduleEvent {
  const factory ScheduleEvent({
    required String id,
    required String title,
    @JsonKey(name: 'shift_type') required String shiftType,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    required String status,
    String? location,
  }) = _ScheduleEvent;

  factory ScheduleEvent.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEventFromJson(json);
}

@freezed
class TeamSchedule with _$TeamSchedule {
  const factory TeamSchedule({
    required String date,
    required List<EmployeeShift> employees,
  }) = _TeamSchedule;

  factory TeamSchedule.fromJson(Map<String, dynamic> json) =>
      _$TeamScheduleFromJson(json);
}

@freezed
class EmployeeShift with _$EmployeeShift {
  const factory EmployeeShift({
    @JsonKey(name: 'employee_name') required String employeeName,
    @JsonKey(name: 'shift_type') required String shiftType,
    @JsonKey(name: 'start_time') required String startTime,
    @JsonKey(name: 'end_time') required String endTime,
    required String status,
  }) = _EmployeeShift;

  factory EmployeeShift.fromJson(Map<String, dynamic> json) =>
      _$EmployeeShiftFromJson(json);
}

@freezed
class ScheduleStatistics with _$ScheduleStatistics {
  const factory ScheduleStatistics({
    required int scheduled,
    required int completed,
    required int cancelled,
    required int total,
  }) = _ScheduleStatistics;

  factory ScheduleStatistics.fromJson(Map<String, dynamic> json) =>
      _$ScheduleStatisticsFromJson(json);
}
