// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardMetricsImpl _$$DashboardMetricsImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardMetricsImpl(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalOrders: (json['total_orders'] as num).toInt(),
      totalCustomers: (json['total_customers'] as num).toInt(),
      pendingApprovals: (json['pending_approvals'] as num).toInt(),
      branchPerformance: (json['branch_performance'] as List<dynamic>)
          .map((e) => BranchMetrics.fromJson(e as Map<String, dynamic>))
          .toList(),
      recentActivity: (json['recent_activity'] as List<dynamic>)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DashboardMetricsImplToJson(
        _$DashboardMetricsImpl instance) =>
    <String, dynamic>{
      'total_revenue': instance.totalRevenue,
      'total_orders': instance.totalOrders,
      'total_customers': instance.totalCustomers,
      'pending_approvals': instance.pendingApprovals,
      'branch_performance': instance.branchPerformance,
      'recent_activity': instance.recentActivity,
    };

_$BranchMetricsImpl _$$BranchMetricsImplFromJson(Map<String, dynamic> json) =>
    _$BranchMetricsImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      revenue: (json['revenue'] as num).toDouble(),
      orders: (json['orders'] as num).toInt(),
      target: (json['target'] as num).toDouble(),
      achievementPercentage: (json['achievement_percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$BranchMetricsImplToJson(_$BranchMetricsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'revenue': instance.revenue,
      'orders': instance.orders,
      'target': instance.target,
      'achievement_percentage': instance.achievementPercentage,
    };

_$ActivityItemImpl _$$ActivityItemImplFromJson(Map<String, dynamic> json) =>
    _$ActivityItemImpl(
      id: json['id'] as String,
      userName: json['user_name'] as String,
      action: json['action'] as String,
      details: json['details'] as String,
      timestamp: json['timestamp'] as String,
      iconType: json['icon_type'] as String,
    );

Map<String, dynamic> _$$ActivityItemImplToJson(_$ActivityItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_name': instance.userName,
      'action': instance.action,
      'details': instance.details,
      'timestamp': instance.timestamp,
      'icon_type': instance.iconType,
    };

_$SalesRankingImpl _$$SalesRankingImplFromJson(Map<String, dynamic> json) =>
    _$SalesRankingImpl(
      rank: (json['rank'] as num).toInt(),
      userId: json['user_id'] as String,
      fullName: json['full_name'] as String,
      branchName: json['branch_name'] as String,
      salesAmount: (json['sales_amount'] as num).toDouble(),
      target: (json['target'] as num).toDouble(),
      achievementPercentage: (json['achievement_percentage'] as num).toDouble(),
      totalOrders: (json['total_orders'] as num).toInt(),
      performanceLevel: json['performance_level'] as String,
    );

Map<String, dynamic> _$$SalesRankingImplToJson(_$SalesRankingImpl instance) =>
    <String, dynamic>{
      'rank': instance.rank,
      'user_id': instance.userId,
      'full_name': instance.fullName,
      'branch_name': instance.branchName,
      'sales_amount': instance.salesAmount,
      'target': instance.target,
      'achievement_percentage': instance.achievementPercentage,
      'total_orders': instance.totalOrders,
      'performance_level': instance.performanceLevel,
    };

_$BranchImpl _$$BranchImplFromJson(Map<String, dynamic> json) => _$BranchImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      managerId: json['manager_id'] as String?,
      totalEmployees: (json['total_employees'] as num?)?.toInt(),
      totalRevenue: (json['total_revenue'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$BranchImplToJson(_$BranchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'manager_id': instance.managerId,
      'total_employees': instance.totalEmployees,
      'total_revenue': instance.totalRevenue,
    };

_$BranchDetailImpl _$$BranchDetailImplFromJson(Map<String, dynamic> json) =>
    _$BranchDetailImpl(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      managerId: json['manager_id'] as String?,
      managerName: json['manager_name'] as String?,
      totalEmployees: (json['total_employees'] as num).toInt(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalOrders: (json['total_orders'] as num).toInt(),
      pendingApprovals: (json['pending_approvals'] as num).toInt(),
      attendanceRate: (json['attendance_rate'] as num).toDouble(),
      recentActivity: (json['recent_activity'] as List<dynamic>)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BranchDetailImplToJson(_$BranchDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'address': instance.address,
      'phone': instance.phone,
      'manager_id': instance.managerId,
      'manager_name': instance.managerName,
      'total_employees': instance.totalEmployees,
      'total_revenue': instance.totalRevenue,
      'total_orders': instance.totalOrders,
      'pending_approvals': instance.pendingApprovals,
      'attendance_rate': instance.attendanceRate,
      'recent_activity': instance.recentActivity,
    };
