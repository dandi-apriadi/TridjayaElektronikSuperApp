// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftImpl _$$ShiftImplFromJson(Map<String, dynamic> json) => _$ShiftImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      shiftType: json['shift_type'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$ShiftImplToJson(_$ShiftImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'shift_type': instance.shiftType,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'location': instance.location,
      'notes': instance.notes,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$ScheduleEventImpl _$$ScheduleEventImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleEventImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      shiftType: json['shift_type'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: json['status'] as String,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$ScheduleEventImplToJson(_$ScheduleEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'shift_type': instance.shiftType,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
      'location': instance.location,
    };

_$TeamScheduleImpl _$$TeamScheduleImplFromJson(Map<String, dynamic> json) =>
    _$TeamScheduleImpl(
      date: json['date'] as String,
      employees: (json['employees'] as List<dynamic>)
          .map((e) => EmployeeShift.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TeamScheduleImplToJson(_$TeamScheduleImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'employees': instance.employees,
    };

_$EmployeeShiftImpl _$$EmployeeShiftImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeShiftImpl(
      employeeName: json['employee_name'] as String,
      shiftType: json['shift_type'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$$EmployeeShiftImplToJson(_$EmployeeShiftImpl instance) =>
    <String, dynamic>{
      'employee_name': instance.employeeName,
      'shift_type': instance.shiftType,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'status': instance.status,
    };

_$ScheduleStatisticsImpl _$$ScheduleStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$ScheduleStatisticsImpl(
      scheduled: (json['scheduled'] as num).toInt(),
      completed: (json['completed'] as num).toInt(),
      cancelled: (json['cancelled'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$$ScheduleStatisticsImplToJson(
        _$ScheduleStatisticsImpl instance) =>
    <String, dynamic>{
      'scheduled': instance.scheduled,
      'completed': instance.completed,
      'cancelled': instance.cancelled,
      'total': instance.total,
    };
