// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crm_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CrmCustomerImpl _$$CrmCustomerImplFromJson(Map<String, dynamic> json) =>
    _$CrmCustomerImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String?,
      status: json['status'] as String,
      source: json['source'] as String?,
      budget: (json['budget'] as num?)?.toInt(),
      interest: json['interest'] as String?,
      notes: json['notes'] as String?,
      lastInteraction: json['last_interaction'] as String?,
      nextFollowup: json['next_followup'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$$CrmCustomerImplToJson(_$CrmCustomerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'status': instance.status,
      'source': instance.source,
      'budget': instance.budget,
      'interest': instance.interest,
      'notes': instance.notes,
      'last_interaction': instance.lastInteraction,
      'next_followup': instance.nextFollowup,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

_$CustomerInteractionImpl _$$CustomerInteractionImplFromJson(
        Map<String, dynamic> json) =>
    _$CustomerInteractionImpl(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      userId: json['user_id'] as String,
      interactionType: json['interaction_type'] as String,
      notes: json['notes'] as String,
      createdAt: json['created_at'] as String,
    );

Map<String, dynamic> _$$CustomerInteractionImplToJson(
        _$CustomerInteractionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customer_id': instance.customerId,
      'user_id': instance.userId,
      'interaction_type': instance.interactionType,
      'notes': instance.notes,
      'created_at': instance.createdAt,
    };

_$CrmStatisticsImpl _$$CrmStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$CrmStatisticsImpl(
      totalCustomers: (json['total_customers'] as num).toInt(),
      hotProspects: (json['hot_prospects'] as num).toInt(),
      warmProspects: (json['warm_prospects'] as num).toInt(),
      coldProspects: (json['cold_prospects'] as num).toInt(),
      converted: (json['converted'] as num).toInt(),
      lost: (json['lost'] as num).toInt(),
      conversionRate: (json['conversion_rate'] as num).toDouble(),
      totalInteractions: (json['total_interactions'] as num).toInt(),
    );

Map<String, dynamic> _$$CrmStatisticsImplToJson(_$CrmStatisticsImpl instance) =>
    <String, dynamic>{
      'total_customers': instance.totalCustomers,
      'hot_prospects': instance.hotProspects,
      'warm_prospects': instance.warmProspects,
      'cold_prospects': instance.coldProspects,
      'converted': instance.converted,
      'lost': instance.lost,
      'conversion_rate': instance.conversionRate,
      'total_interactions': instance.totalInteractions,
    };

_$CustomerDetailImpl _$$CustomerDetailImplFromJson(Map<String, dynamic> json) =>
    _$CustomerDetailImpl(
      customer: CrmCustomer.fromJson(json['customer'] as Map<String, dynamic>),
      interactions: (json['interactions'] as List<dynamic>)
          .map((e) => CustomerInteraction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CustomerDetailImplToJson(
        _$CustomerDetailImpl instance) =>
    <String, dynamic>{
      'customer': instance.customer,
      'interactions': instance.interactions,
    };
