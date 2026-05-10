import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
  @JsonValue('SuperAdmin')
  superAdmin,
  @JsonValue('Owner')
  owner,
  @JsonValue('Kepala_Cabang')
  kepalaCabang,
  @JsonValue('Admin')
  admin,
  @JsonValue('Sales')
  sales,
  @JsonValue('Driver')
  driver,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.superAdmin:
        return 'Super Admin';
      case UserRole.owner:
        return 'Owner';
      case UserRole.kepalaCabang:
        return 'Kepala Cabang';
      case UserRole.admin:
        return 'Admin';
      case UserRole.sales:
        return 'Sales';
      case UserRole.driver:
        return 'Driver';
    }
  }

  bool get canAccessAllBranches => this == UserRole.superAdmin || this == UserRole.owner;
  bool get isFieldWorker => this == UserRole.driver || this == UserRole.sales;
  bool get isSuperAdmin => this == UserRole.superAdmin;
  bool get canManageAllUsers => this == UserRole.superAdmin;
  bool get canEditAnyData => this == UserRole.superAdmin;
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required UserRole role,
    String? email,
    String? fullName,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'branch_name') String? branchName,
    String? phone,
    String? department,
    String? position,
    @JsonKey(name: 'profile_photo_url') String? profilePhotoUrl,
    @JsonKey(name: 'employee_id') String? employeeId,
    @JsonKey(name: 'last_login_at') DateTime? lastLoginAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@freezed
class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}
