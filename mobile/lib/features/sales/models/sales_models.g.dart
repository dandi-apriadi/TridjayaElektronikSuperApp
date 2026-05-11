// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SalesDashboardMetricsImpl _$$SalesDashboardMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$SalesDashboardMetricsImpl(
      totalProspects: (json['total_prospects'] as num).toInt(),
      prospectsByStatus: ProspectSummary.fromJson(
          json['prospects_by_status'] as Map<String, dynamic>),
      monthlyTarget: (json['monthly_target'] as num).toInt(),
      monthlyAchieved: (json['monthly_achieved'] as num).toInt(),
      conversionRate: (json['conversion_rate'] as num).toDouble(),
      activeCampaigns: (json['active_campaigns'] as num).toInt(),
    );

Map<String, dynamic> _$$SalesDashboardMetricsImplToJson(
        _$SalesDashboardMetricsImpl instance) =>
    <String, dynamic>{
      'total_prospects': instance.totalProspects,
      'prospects_by_status': instance.prospectsByStatus,
      'monthly_target': instance.monthlyTarget,
      'monthly_achieved': instance.monthlyAchieved,
      'conversion_rate': instance.conversionRate,
      'active_campaigns': instance.activeCampaigns,
    };

_$ProspectSummaryImpl _$$ProspectSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProspectSummaryImpl(
      newCount: (json['new'] as num).toInt(),
      contacted: (json['contacted'] as num).toInt(),
      negotiation: (json['negotiation'] as num).toInt(),
      closed: (json['closed'] as num).toInt(),
      lost: (json['lost'] as num).toInt(),
    );

Map<String, dynamic> _$$ProspectSummaryImplToJson(
        _$ProspectSummaryImpl instance) =>
    <String, dynamic>{
      'new': instance.newCount,
      'contacted': instance.contacted,
      'negotiation': instance.negotiation,
      'closed': instance.closed,
      'lost': instance.lost,
    };

_$ProspectImpl _$$ProspectImplFromJson(Map<String, dynamic> json) =>
    _$ProspectImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      status: json['status'] as String,
      source: json['source'] as String?,
      productInterest: json['product_interest'] as String?,
      budget: (json['budget'] as num?)?.toInt(),
      notes: json['notes'] as String?,
      lastContact: json['last_contact'] as String?,
      nextFollowup: json['next_followup'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$ProspectImplToJson(_$ProspectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'status': instance.status,
      'source': instance.source,
      'product_interest': instance.productInterest,
      'budget': instance.budget,
      'notes': instance.notes,
      'last_contact': instance.lastContact,
      'next_followup': instance.nextFollowup,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$CampaignImpl _$$CampaignImplFromJson(Map<String, dynamic> json) =>
    _$CampaignImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      targetAmount: (json['target_amount'] as num).toInt(),
      achievedAmount: (json['achieved_amount'] as num).toInt(),
      status: json['status'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$CampaignImplToJson(_$CampaignImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'target_amount': instance.targetAmount,
      'achieved_amount': instance.achievedAmount,
      'status': instance.status,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'created_at': instance.createdAt,
    };

_$SalesReportImpl _$$SalesReportImplFromJson(Map<String, dynamic> json) =>
    _$SalesReportImpl(
      totalClosed: (json['total_closed'] as num).toInt(),
      target: (json['target'] as num).toInt(),
      achievementPercentage: (json['achievement_percentage'] as num).toInt(),
    );

Map<String, dynamic> _$$SalesReportImplToJson(_$SalesReportImpl instance) =>
    <String, dynamic>{
      'total_closed': instance.totalClosed,
      'target': instance.target,
      'achievement_percentage': instance.achievementPercentage,
    };
