import 'package:freezed_annotation/freezed_annotation.dart';

part 'crm_models.freezed.dart';
part 'crm_models.g.dart';

/// ============================================================
/// CRM MODELS
/// ============================================================

@freezed
class CrmCustomer with _$CrmCustomer {
  const factory CrmCustomer({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    required String phone,
    String? email,
    String? address,
    required String status, // hot, warm, cold, converted, lost
    String? source,
    int? budget,
    String? interest,
    String? notes,
    @JsonKey(name: 'last_interaction') String? lastInteraction,
    @JsonKey(name: 'next_followup') String? nextFollowup,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _CrmCustomer;

  factory CrmCustomer.fromJson(Map<String, dynamic> json) =>
      _$CrmCustomerFromJson(json);
}

@freezed
class CustomerInteraction with _$CustomerInteraction {
  const factory CustomerInteraction({
    required String id,
    @JsonKey(name: 'customer_id') required String customerId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'interaction_type') required String interactionType, // call, email, meeting, message
    required String notes,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _CustomerInteraction;

  factory CustomerInteraction.fromJson(Map<String, dynamic> json) =>
      _$CustomerInteractionFromJson(json);
}

@freezed
class CrmStatistics with _$CrmStatistics {
  const factory CrmStatistics({
    @JsonKey(name: 'total_customers') required int totalCustomers,
    @JsonKey(name: 'hot_prospects') required int hotProspects,
    @JsonKey(name: 'warm_prospects') required int warmProspects,
    @JsonKey(name: 'cold_prospects') required int coldProspects,
    required int converted,
    required int lost,
    @JsonKey(name: 'conversion_rate') required double conversionRate,
    @JsonKey(name: 'total_interactions') required int totalInteractions,
  }) = _CrmStatistics;

  factory CrmStatistics.fromJson(Map<String, dynamic> json) =>
      _$CrmStatisticsFromJson(json);
}

@freezed
class CustomerDetail with _$CustomerDetail {
  const factory CustomerDetail({
    required CrmCustomer customer,
    required List<CustomerInteraction> interactions,
  }) = _CustomerDetail;

  factory CustomerDetail.fromJson(Map<String, dynamic> json) =>
      _$CustomerDetailFromJson(json);
}
