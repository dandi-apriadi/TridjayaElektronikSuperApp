// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Shift _$ShiftFromJson(Map<String, dynamic> json) {
  return _Shift.fromJson(json);
}

/// @nodoc
mixin _$Shift {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_type')
  String get shiftType =>
      throw _privateConstructorUsedError; // morning, afternoon, night, custom
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // scheduled, completed, cancelled
  @JsonKey(name: 'created_at')
  String get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShiftCopyWith<Shift> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShiftCopyWith<$Res> {
  factory $ShiftCopyWith(Shift value, $Res Function(Shift) then) =
      _$ShiftCopyWithImpl<$Res, Shift>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      @JsonKey(name: 'shift_type') String shiftType,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String? location,
      String? notes,
      String status,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class _$ShiftCopyWithImpl<$Res, $Val extends Shift>
    implements $ShiftCopyWith<$Res> {
  _$ShiftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? shiftType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? location = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      shiftType: null == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShiftImplCopyWith<$Res> implements $ShiftCopyWith<$Res> {
  factory _$$ShiftImplCopyWith(
          _$ShiftImpl value, $Res Function(_$ShiftImpl) then) =
      __$$ShiftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String title,
      @JsonKey(name: 'shift_type') String shiftType,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String? location,
      String? notes,
      String status,
      @JsonKey(name: 'created_at') String createdAt,
      @JsonKey(name: 'updated_at') String updatedAt});
}

/// @nodoc
class __$$ShiftImplCopyWithImpl<$Res>
    extends _$ShiftCopyWithImpl<$Res, _$ShiftImpl>
    implements _$$ShiftImplCopyWith<$Res> {
  __$$ShiftImplCopyWithImpl(
      _$ShiftImpl _value, $Res Function(_$ShiftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? shiftType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? location = freezed,
    Object? notes = freezed,
    Object? status = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ShiftImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      shiftType: null == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShiftImpl implements _Shift {
  const _$ShiftImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.title,
      @JsonKey(name: 'shift_type') required this.shiftType,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      this.location,
      this.notes,
      required this.status,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ShiftImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShiftImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  final String title;
  @override
  @JsonKey(name: 'shift_type')
  final String shiftType;
// morning, afternoon, night, custom
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  final String? location;
  @override
  final String? notes;
  @override
  final String status;
// scheduled, completed, cancelled
  @override
  @JsonKey(name: 'created_at')
  final String createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  @override
  String toString() {
    return 'Shift(id: $id, userId: $userId, title: $title, shiftType: $shiftType, startTime: $startTime, endTime: $endTime, location: $location, notes: $notes, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShiftImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.shiftType, shiftType) ||
                other.shiftType == shiftType) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, title, shiftType,
      startTime, endTime, location, notes, status, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShiftImplCopyWith<_$ShiftImpl> get copyWith =>
      __$$ShiftImplCopyWithImpl<_$ShiftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShiftImplToJson(
      this,
    );
  }
}

abstract class _Shift implements Shift {
  const factory _Shift(
          {required final String id,
          @JsonKey(name: 'user_id') required final String userId,
          required final String title,
          @JsonKey(name: 'shift_type') required final String shiftType,
          @JsonKey(name: 'start_time') required final String startTime,
          @JsonKey(name: 'end_time') required final String endTime,
          final String? location,
          final String? notes,
          required final String status,
          @JsonKey(name: 'created_at') required final String createdAt,
          @JsonKey(name: 'updated_at') required final String updatedAt}) =
      _$ShiftImpl;

  factory _Shift.fromJson(Map<String, dynamic> json) = _$ShiftImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get title;
  @override
  @JsonKey(name: 'shift_type')
  String get shiftType;
  @override // morning, afternoon, night, custom
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  String? get location;
  @override
  String? get notes;
  @override
  String get status;
  @override // scheduled, completed, cancelled
  @JsonKey(name: 'created_at')
  String get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ShiftImplCopyWith<_$ShiftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleEvent _$ScheduleEventFromJson(Map<String, dynamic> json) {
  return _ScheduleEvent.fromJson(json);
}

/// @nodoc
mixin _$ScheduleEvent {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_type')
  String get shiftType => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduleEventCopyWith<ScheduleEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleEventCopyWith<$Res> {
  factory $ScheduleEventCopyWith(
          ScheduleEvent value, $Res Function(ScheduleEvent) then) =
      _$ScheduleEventCopyWithImpl<$Res, ScheduleEvent>;
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'shift_type') String shiftType,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String status,
      String? location});
}

/// @nodoc
class _$ScheduleEventCopyWithImpl<$Res, $Val extends ScheduleEvent>
    implements $ScheduleEventCopyWith<$Res> {
  _$ScheduleEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? shiftType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? location = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      shiftType: null == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleEventImplCopyWith<$Res>
    implements $ScheduleEventCopyWith<$Res> {
  factory _$$ScheduleEventImplCopyWith(
          _$ScheduleEventImpl value, $Res Function(_$ScheduleEventImpl) then) =
      __$$ScheduleEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      @JsonKey(name: 'shift_type') String shiftType,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String status,
      String? location});
}

/// @nodoc
class __$$ScheduleEventImplCopyWithImpl<$Res>
    extends _$ScheduleEventCopyWithImpl<$Res, _$ScheduleEventImpl>
    implements _$$ScheduleEventImplCopyWith<$Res> {
  __$$ScheduleEventImplCopyWithImpl(
      _$ScheduleEventImpl _value, $Res Function(_$ScheduleEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? shiftType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
    Object? location = freezed,
  }) {
    return _then(_$ScheduleEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      shiftType: null == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleEventImpl implements _ScheduleEvent {
  const _$ScheduleEventImpl(
      {required this.id,
      required this.title,
      @JsonKey(name: 'shift_type') required this.shiftType,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      required this.status,
      this.location});

  factory _$ScheduleEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleEventImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  @JsonKey(name: 'shift_type')
  final String shiftType;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  final String status;
  @override
  final String? location;

  @override
  String toString() {
    return 'ScheduleEvent(id: $id, title: $title, shiftType: $shiftType, startTime: $startTime, endTime: $endTime, status: $status, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.shiftType, shiftType) ||
                other.shiftType == shiftType) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, shiftType, startTime, endTime, status, location);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleEventImplCopyWith<_$ScheduleEventImpl> get copyWith =>
      __$$ScheduleEventImplCopyWithImpl<_$ScheduleEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleEventImplToJson(
      this,
    );
  }
}

abstract class _ScheduleEvent implements ScheduleEvent {
  const factory _ScheduleEvent(
      {required final String id,
      required final String title,
      @JsonKey(name: 'shift_type') required final String shiftType,
      @JsonKey(name: 'start_time') required final String startTime,
      @JsonKey(name: 'end_time') required final String endTime,
      required final String status,
      final String? location}) = _$ScheduleEventImpl;

  factory _ScheduleEvent.fromJson(Map<String, dynamic> json) =
      _$ScheduleEventImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  @JsonKey(name: 'shift_type')
  String get shiftType;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  String get status;
  @override
  String? get location;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleEventImplCopyWith<_$ScheduleEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamSchedule _$TeamScheduleFromJson(Map<String, dynamic> json) {
  return _TeamSchedule.fromJson(json);
}

/// @nodoc
mixin _$TeamSchedule {
  String get date => throw _privateConstructorUsedError;
  List<EmployeeShift> get employees => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamScheduleCopyWith<TeamSchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamScheduleCopyWith<$Res> {
  factory $TeamScheduleCopyWith(
          TeamSchedule value, $Res Function(TeamSchedule) then) =
      _$TeamScheduleCopyWithImpl<$Res, TeamSchedule>;
  @useResult
  $Res call({String date, List<EmployeeShift> employees});
}

/// @nodoc
class _$TeamScheduleCopyWithImpl<$Res, $Val extends TeamSchedule>
    implements $TeamScheduleCopyWith<$Res> {
  _$TeamScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? employees = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      employees: null == employees
          ? _value.employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeShift>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamScheduleImplCopyWith<$Res>
    implements $TeamScheduleCopyWith<$Res> {
  factory _$$TeamScheduleImplCopyWith(
          _$TeamScheduleImpl value, $Res Function(_$TeamScheduleImpl) then) =
      __$$TeamScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date, List<EmployeeShift> employees});
}

/// @nodoc
class __$$TeamScheduleImplCopyWithImpl<$Res>
    extends _$TeamScheduleCopyWithImpl<$Res, _$TeamScheduleImpl>
    implements _$$TeamScheduleImplCopyWith<$Res> {
  __$$TeamScheduleImplCopyWithImpl(
      _$TeamScheduleImpl _value, $Res Function(_$TeamScheduleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? employees = null,
  }) {
    return _then(_$TeamScheduleImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      employees: null == employees
          ? _value._employees
          : employees // ignore: cast_nullable_to_non_nullable
              as List<EmployeeShift>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamScheduleImpl implements _TeamSchedule {
  const _$TeamScheduleImpl(
      {required this.date, required final List<EmployeeShift> employees})
      : _employees = employees;

  factory _$TeamScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamScheduleImplFromJson(json);

  @override
  final String date;
  final List<EmployeeShift> _employees;
  @override
  List<EmployeeShift> get employees {
    if (_employees is EqualUnmodifiableListView) return _employees;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_employees);
  }

  @override
  String toString() {
    return 'TeamSchedule(date: $date, employees: $employees)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamScheduleImpl &&
            (identical(other.date, date) || other.date == date) &&
            const DeepCollectionEquality()
                .equals(other._employees, _employees));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, const DeepCollectionEquality().hash(_employees));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamScheduleImplCopyWith<_$TeamScheduleImpl> get copyWith =>
      __$$TeamScheduleImplCopyWithImpl<_$TeamScheduleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamScheduleImplToJson(
      this,
    );
  }
}

abstract class _TeamSchedule implements TeamSchedule {
  const factory _TeamSchedule(
      {required final String date,
      required final List<EmployeeShift> employees}) = _$TeamScheduleImpl;

  factory _TeamSchedule.fromJson(Map<String, dynamic> json) =
      _$TeamScheduleImpl.fromJson;

  @override
  String get date;
  @override
  List<EmployeeShift> get employees;
  @override
  @JsonKey(ignore: true)
  _$$TeamScheduleImplCopyWith<_$TeamScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EmployeeShift _$EmployeeShiftFromJson(Map<String, dynamic> json) {
  return _EmployeeShift.fromJson(json);
}

/// @nodoc
mixin _$EmployeeShift {
  @JsonKey(name: 'employee_name')
  String get employeeName => throw _privateConstructorUsedError;
  @JsonKey(name: 'shift_type')
  String get shiftType => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_time')
  String get startTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_time')
  String get endTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmployeeShiftCopyWith<EmployeeShift> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmployeeShiftCopyWith<$Res> {
  factory $EmployeeShiftCopyWith(
          EmployeeShift value, $Res Function(EmployeeShift) then) =
      _$EmployeeShiftCopyWithImpl<$Res, EmployeeShift>;
  @useResult
  $Res call(
      {@JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'shift_type') String shiftType,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String status});
}

/// @nodoc
class _$EmployeeShiftCopyWithImpl<$Res, $Val extends EmployeeShift>
    implements $EmployeeShiftCopyWith<$Res> {
  _$EmployeeShiftCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeName = null,
    Object? shiftType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      shiftType: null == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EmployeeShiftImplCopyWith<$Res>
    implements $EmployeeShiftCopyWith<$Res> {
  factory _$$EmployeeShiftImplCopyWith(
          _$EmployeeShiftImpl value, $Res Function(_$EmployeeShiftImpl) then) =
      __$$EmployeeShiftImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'employee_name') String employeeName,
      @JsonKey(name: 'shift_type') String shiftType,
      @JsonKey(name: 'start_time') String startTime,
      @JsonKey(name: 'end_time') String endTime,
      String status});
}

/// @nodoc
class __$$EmployeeShiftImplCopyWithImpl<$Res>
    extends _$EmployeeShiftCopyWithImpl<$Res, _$EmployeeShiftImpl>
    implements _$$EmployeeShiftImplCopyWith<$Res> {
  __$$EmployeeShiftImplCopyWithImpl(
      _$EmployeeShiftImpl _value, $Res Function(_$EmployeeShiftImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? employeeName = null,
    Object? shiftType = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? status = null,
  }) {
    return _then(_$EmployeeShiftImpl(
      employeeName: null == employeeName
          ? _value.employeeName
          : employeeName // ignore: cast_nullable_to_non_nullable
              as String,
      shiftType: null == shiftType
          ? _value.shiftType
          : shiftType // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EmployeeShiftImpl implements _EmployeeShift {
  const _$EmployeeShiftImpl(
      {@JsonKey(name: 'employee_name') required this.employeeName,
      @JsonKey(name: 'shift_type') required this.shiftType,
      @JsonKey(name: 'start_time') required this.startTime,
      @JsonKey(name: 'end_time') required this.endTime,
      required this.status});

  factory _$EmployeeShiftImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmployeeShiftImplFromJson(json);

  @override
  @JsonKey(name: 'employee_name')
  final String employeeName;
  @override
  @JsonKey(name: 'shift_type')
  final String shiftType;
  @override
  @JsonKey(name: 'start_time')
  final String startTime;
  @override
  @JsonKey(name: 'end_time')
  final String endTime;
  @override
  final String status;

  @override
  String toString() {
    return 'EmployeeShift(employeeName: $employeeName, shiftType: $shiftType, startTime: $startTime, endTime: $endTime, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmployeeShiftImpl &&
            (identical(other.employeeName, employeeName) ||
                other.employeeName == employeeName) &&
            (identical(other.shiftType, shiftType) ||
                other.shiftType == shiftType) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, employeeName, shiftType, startTime, endTime, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EmployeeShiftImplCopyWith<_$EmployeeShiftImpl> get copyWith =>
      __$$EmployeeShiftImplCopyWithImpl<_$EmployeeShiftImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EmployeeShiftImplToJson(
      this,
    );
  }
}

abstract class _EmployeeShift implements EmployeeShift {
  const factory _EmployeeShift(
      {@JsonKey(name: 'employee_name') required final String employeeName,
      @JsonKey(name: 'shift_type') required final String shiftType,
      @JsonKey(name: 'start_time') required final String startTime,
      @JsonKey(name: 'end_time') required final String endTime,
      required final String status}) = _$EmployeeShiftImpl;

  factory _EmployeeShift.fromJson(Map<String, dynamic> json) =
      _$EmployeeShiftImpl.fromJson;

  @override
  @JsonKey(name: 'employee_name')
  String get employeeName;
  @override
  @JsonKey(name: 'shift_type')
  String get shiftType;
  @override
  @JsonKey(name: 'start_time')
  String get startTime;
  @override
  @JsonKey(name: 'end_time')
  String get endTime;
  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$EmployeeShiftImplCopyWith<_$EmployeeShiftImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScheduleStatistics _$ScheduleStatisticsFromJson(Map<String, dynamic> json) {
  return _ScheduleStatistics.fromJson(json);
}

/// @nodoc
mixin _$ScheduleStatistics {
  int get scheduled => throw _privateConstructorUsedError;
  int get completed => throw _privateConstructorUsedError;
  int get cancelled => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScheduleStatisticsCopyWith<ScheduleStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleStatisticsCopyWith<$Res> {
  factory $ScheduleStatisticsCopyWith(
          ScheduleStatistics value, $Res Function(ScheduleStatistics) then) =
      _$ScheduleStatisticsCopyWithImpl<$Res, ScheduleStatistics>;
  @useResult
  $Res call({int scheduled, int completed, int cancelled, int total});
}

/// @nodoc
class _$ScheduleStatisticsCopyWithImpl<$Res, $Val extends ScheduleStatistics>
    implements $ScheduleStatisticsCopyWith<$Res> {
  _$ScheduleStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduled = null,
    Object? completed = null,
    Object? cancelled = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      scheduled: null == scheduled
          ? _value.scheduled
          : scheduled // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      cancelled: null == cancelled
          ? _value.cancelled
          : cancelled // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleStatisticsImplCopyWith<$Res>
    implements $ScheduleStatisticsCopyWith<$Res> {
  factory _$$ScheduleStatisticsImplCopyWith(_$ScheduleStatisticsImpl value,
          $Res Function(_$ScheduleStatisticsImpl) then) =
      __$$ScheduleStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int scheduled, int completed, int cancelled, int total});
}

/// @nodoc
class __$$ScheduleStatisticsImplCopyWithImpl<$Res>
    extends _$ScheduleStatisticsCopyWithImpl<$Res, _$ScheduleStatisticsImpl>
    implements _$$ScheduleStatisticsImplCopyWith<$Res> {
  __$$ScheduleStatisticsImplCopyWithImpl(_$ScheduleStatisticsImpl _value,
      $Res Function(_$ScheduleStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scheduled = null,
    Object? completed = null,
    Object? cancelled = null,
    Object? total = null,
  }) {
    return _then(_$ScheduleStatisticsImpl(
      scheduled: null == scheduled
          ? _value.scheduled
          : scheduled // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      cancelled: null == cancelled
          ? _value.cancelled
          : cancelled // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScheduleStatisticsImpl implements _ScheduleStatistics {
  const _$ScheduleStatisticsImpl(
      {required this.scheduled,
      required this.completed,
      required this.cancelled,
      required this.total});

  factory _$ScheduleStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScheduleStatisticsImplFromJson(json);

  @override
  final int scheduled;
  @override
  final int completed;
  @override
  final int cancelled;
  @override
  final int total;

  @override
  String toString() {
    return 'ScheduleStatistics(scheduled: $scheduled, completed: $completed, cancelled: $cancelled, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleStatisticsImpl &&
            (identical(other.scheduled, scheduled) ||
                other.scheduled == scheduled) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.cancelled, cancelled) ||
                other.cancelled == cancelled) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, scheduled, completed, cancelled, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleStatisticsImplCopyWith<_$ScheduleStatisticsImpl> get copyWith =>
      __$$ScheduleStatisticsImplCopyWithImpl<_$ScheduleStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScheduleStatisticsImplToJson(
      this,
    );
  }
}

abstract class _ScheduleStatistics implements ScheduleStatistics {
  const factory _ScheduleStatistics(
      {required final int scheduled,
      required final int completed,
      required final int cancelled,
      required final int total}) = _$ScheduleStatisticsImpl;

  factory _ScheduleStatistics.fromJson(Map<String, dynamic> json) =
      _$ScheduleStatisticsImpl.fromJson;

  @override
  int get scheduled;
  @override
  int get completed;
  @override
  int get cancelled;
  @override
  int get total;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleStatisticsImplCopyWith<_$ScheduleStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
