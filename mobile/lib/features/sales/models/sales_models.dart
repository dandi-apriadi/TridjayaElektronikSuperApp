import 'package:freezed_annotation/freezed_annotation.dart';

part 'sales_models.freezed.dart';
part 'sales_models.g.dart';

/// ============================================================
/// SALES MODELS
/// ============================================================

@freezed
class SalesDashboardMetrics with _$SalesDashboardMetrics {
  const factory SalesDashboardMetrics({
    @JsonKey(name: 'total_prospects') required int totalProspects,
    @JsonKey(name: 'prospects_by_status') required ProspectSummary prospectsByStatus,
    @JsonKey(name: 'monthly_target') required int monthlyTarget,
    @JsonKey(name: 'monthly_achieved') required int monthlyAchieved,
    @JsonKey(name: 'conversion_rate') required double conversionRate,
    @JsonKey(name: 'active_campaigns') required int activeCampaigns,
  }) = _SalesDashboardMetrics;

  factory SalesDashboardMetrics.fromJson(Map<String, dynamic> json) =>
      _$SalesDashboardMetricsFromJson(json);
}

@freezed
class ProspectSummary with _$ProspectSummary {
  const factory ProspectSummary({
    @JsonKey(name: 'new') required int newCount,
    required int contacted,
    required int negotiation,
    required int closed,
    required int lost,
  }) = _ProspectSummary;

  factory ProspectSummary.fromJson(Map<String, dynamic> json) =>
      _$ProspectSummaryFromJson(json);
}

@freezed
class Prospect with _$Prospect {
  const factory Prospect({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    required String phone,
    String? email,
    String? address,
    required String status, // new, contacted, negotiation, closed, lost
    String? source,
    @JsonKey(name: 'product_interest') String? productInterest,
    int? budget,
    String? notes,
    @JsonKey(name: 'last_contact') String? lastContact,
    @JsonKey(name: 'next_followup') String? nextFollowup,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
  }) = _Prospect;

  factory Prospect.fromJson(Map<String, dynamic> json) =>
      _$ProspectFromJson(json);
}

@freezed
class Campaign with _$Campaign {
  const factory Campaign({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String name,
    String? description,
    @JsonKey(name: 'target_amount') required int targetAmount,
    @JsonKey(name: 'achieved_amount') required int achievedAmount,
    required String status, // active, completed, cancelled
    @JsonKey(name: 'start_date') required String startDate,
    @JsonKey(name: 'end_date') required String endDate,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _Campaign;

  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);
}

@freezed
class SalesReport with _$SalesReport {
  const factory SalesReport({
    @JsonKey(name: 'total_closed') required int totalClosed,
    required int target,
    @JsonKey(name: 'achievement_percentage') required int achievementPercentage,
  }) = _SalesReport;

  factory SalesReport.fromJson(Map<String, dynamic> json) =>
      _$SalesReportFromJson(json);
}
