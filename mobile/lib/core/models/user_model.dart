import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum UserRole {
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

  bool get canAccessAllBranches => this == UserRole.owner;
  bool get isFieldWorker => this == UserRole.driver || this == UserRole.sales;
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required UserRole role,
    String? branchId,
    String? branchName,
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
