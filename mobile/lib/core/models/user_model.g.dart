// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      email: json['email'] as String?,
      fullName: json['fullName'] as String?,
      branchId: json['branch_id'] as String?,
      branchName: json['branch_name'] as String?,
      phone: json['phone'] as String?,
      department: json['department'] as String?,
      position: json['position'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      employeeId: json['employee_id'] as String?,
      lastLoginAt: json['last_login_at'] == null
          ? null
          : DateTime.parse(json['last_login_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'role': _$UserRoleEnumMap[instance.role]!,
      'email': instance.email,
      'fullName': instance.fullName,
      'branch_id': instance.branchId,
      'branch_name': instance.branchName,
      'phone': instance.phone,
      'department': instance.department,
      'position': instance.position,
      'profile_photo_url': instance.profilePhotoUrl,
      'employee_id': instance.employeeId,
      'last_login_at': instance.lastLoginAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.superAdmin: 'SuperAdmin',
  UserRole.owner: 'Owner',
  UserRole.kepalaCabang: 'Kepala_Cabang',
  UserRole.picPelaporan: 'PIC_Pelaporan',
  UserRole.admin: 'Admin',
  UserRole.sales: 'Sales',
  UserRole.driver: 'Driver',
};

_$AuthTokensImpl _$$AuthTokensImplFromJson(Map<String, dynamic> json) =>
    _$AuthTokensImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$$AuthTokensImplToJson(_$AuthTokensImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };
