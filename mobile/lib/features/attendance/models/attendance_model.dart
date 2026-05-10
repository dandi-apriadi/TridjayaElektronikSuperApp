/// Model untuk Attendance Record
class Attendance {
  final String id;
  final String userId;
  final String username;
  final String? fullName;
  final String date;
  final String? clockIn;
  final String? clockOut;
  final String status; // present, absent, late, on_leave
  final double? locationLat;
  final double? locationLng;
  final String? photoUrl;
  final String? notes;
  final String? workingHours; // Format: "8.5 jam"
  final bool isLate;
  final String createdAt;

  Attendance({
    required this.id,
    required this.userId,
    required this.username,
    this.fullName,
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.status,
    this.locationLat,
    this.locationLng,
    this.photoUrl,
    this.notes,
    this.workingHours,
    required this.isLate,
    required this.createdAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'],
      date: json['date'] ?? '',
      clockIn: json['clock_in'],
      clockOut: json['clock_out'],
      status: json['status'] ?? 'present',
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      photoUrl: json['photo_url'],
      notes: json['notes'],
      workingHours: json['working_hours'],
      isLate: json['is_late'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'username': username,
      'full_name': fullName,
      'date': date,
      'clock_in': clockIn,
      'clock_out': clockOut,
      'status': status,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'photo_url': photoUrl,
      'notes': notes,
      'working_hours': workingHours,
      'is_late': isLate,
      'created_at': createdAt,
    };
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'present':
        return 'Hadir';
      case 'absent':
        return 'Absen';
      case 'late':
        return 'Terlambat';
      case 'on_leave':
        return 'Izin';
      default:
        return status;
    }
  }

  String get statusColor {
    switch (status.toLowerCase()) {
      case 'present':
        return '#4CAF50'; // Green
      case 'absent':
        return '#F44336'; // Red
      case 'late':
        return '#FF9800'; // Orange
      case 'on_leave':
        return '#2196F3'; // Blue
      default:
        return '#757575'; // Grey
    }
  }

  bool get hasClockOut => clockOut != null && clockOut!.isNotEmpty;
  bool get isCheckedIn => clockIn != null && clockIn!.isNotEmpty;
}

/// Model untuk Attendance Summary
class AttendanceSummary {
  final int totalPresent;
  final int totalAbsent;
  final int totalLate;
  final int totalLeave;
  final double attendanceRate; // Persentase
  final int thisMonthPresent;
  final int thisWeekPresent;

  AttendanceSummary({
    required this.totalPresent,
    required this.totalAbsent,
    required this.totalLate,
    required this.totalLeave,
    required this.attendanceRate,
    required this.thisMonthPresent,
    required this.thisWeekPresent,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      totalPresent: json['total_present'] ?? 0,
      totalAbsent: json['total_absent'] ?? 0,
      totalLate: json['total_late'] ?? 0,
      totalLeave: json['total_leave'] ?? 0,
      attendanceRate: (json['attendance_rate'] as num?)?.toDouble() ?? 0.0,
      thisMonthPresent: json['this_month_present'] ?? 0,
      thisWeekPresent: json['this_week_present'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_present': totalPresent,
      'total_absent': totalAbsent,
      'total_late': totalLate,
      'total_leave': totalLeave,
      'attendance_rate': attendanceRate,
      'this_month_present': thisMonthPresent,
      'this_week_present': thisWeekPresent,
    };
  }

  String get attendanceRateString => '${attendanceRate.toStringAsFixed(1)}%';
}

/// Model untuk Check-in Request
class CheckInRequest {
  final double latitude;
  final double longitude;
  final String? photoUrl;
  final String? notes;

  CheckInRequest({
    required this.latitude,
    required this.longitude,
    this.photoUrl,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'photo_url': photoUrl,
      'notes': notes,
    };
  }
}

/// Model untuk Check-out Request
class CheckOutRequest {
  final double latitude;
  final double longitude;
  final String? notes;

  CheckOutRequest({
    required this.latitude,
    required this.longitude,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
    };
  }
}

/// Model untuk Check-in Response
class CheckInResponse {
  final bool success;
  final String message;
  final Attendance attendance;

  CheckInResponse({
    required this.success,
    required this.message,
    required this.attendance,
  });

  factory CheckInResponse.fromJson(Map<String, dynamic> json) {
    return CheckInResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      attendance: Attendance.fromJson(json['attendance'] ?? {}),
    );
  }
}

/// Model untuk Check-out Response
class CheckOutResponse {
  final bool success;
  final String message;
  final String workingHours;
  final Attendance attendance;

  CheckOutResponse({
    required this.success,
    required this.message,
    required this.workingHours,
    required this.attendance,
  });

  factory CheckOutResponse.fromJson(Map<String, dynamic> json) {
    return CheckOutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      workingHours: json['working_hours'] ?? '',
      attendance: Attendance.fromJson(json['attendance'] ?? {}),
    );
  }
}
