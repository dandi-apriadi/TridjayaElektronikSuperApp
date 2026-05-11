import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../models/inventory_models.dart';

/// Provider untuk list inventory items dengan filter
final inventoryItemsProvider = FutureProvider.family<List<InventoryItem>, Map<String, dynamic>?>((ref, params) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = <String, dynamic>{};
    if (params != null) {
      if (params['category'] != null && params['category'] != 'Semua') {
        queryParams['category'] = params['category'];
      }
      if (params['status'] != null) {
        queryParams['status'] = params['status'];
      }
      if (params['search'] != null && params['search'].isNotEmpty) {
        queryParams['search'] = params['search'];
      }
    }
    
    final response = await dio.get(
      '/api/inventory/items',
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((json) => InventoryItem.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching inventory items: ${e.message}');
    throw Exception('Gagal mengambil data inventory: ${e.message}');
  }
});

/// Provider untuk detail inventory item
final inventoryItemDetailProvider = FutureProvider.family<InventoryItem, String>((ref, itemId) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/inventory/items/$itemId');
    
    if (response.statusCode == 200) {
      return InventoryItem.fromJson(response.data);
    }
    throw Exception('Item tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching inventory item detail: ${e.message}');
    throw Exception('Gagal mengambil detail item: ${e.message}');
  }
});

/// Provider untuk stock transactions
final stockTransactionsProvider = FutureProvider.family<List<StockTransaction>, Map<String, dynamic>?>((ref, params) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = <String, dynamic>{};
    if (params != null) {
      if (params['item_id'] != null) {
        queryParams['item_id'] = params['item_id'];
      }
      if (params['type'] != null) {
        queryParams['type'] = params['type'];
      }
      if (params['start_date'] != null) {
        queryParams['start_date'] = params['start_date'];
      }
      if (params['end_date'] != null) {
        queryParams['end_date'] = params['end_date'];
      }
    }
    
    final response = await dio.get(
      '/api/inventory/transactions',
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((json) => StockTransaction.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching stock transactions: ${e.message}');
    throw Exception('Gagal mengambil riwayat transaksi: ${e.message}');
  }
});

/// Provider untuk inventory alerts
final inventoryAlertsProvider = FutureProvider.family<List<InventoryAlert>, Map<String, dynamic>?>((ref, params) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final queryParams = <String, dynamic>{};
    if (params != null) {
      if (params['type'] != null) {
        queryParams['type'] = params['type'];
      }
      if (params['resolved'] != null) {
        queryParams['resolved'] = params['resolved'];
      }
    }
    
    final response = await dio.get(
      '/api/inventory/alerts',
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List ? response.data : response.data['data'] ?? [];
      return data.map((json) => InventoryAlert.fromJson(json)).toList();
    }
    return [];
  } on DioException catch (e) {
    debugPrint('Error fetching inventory alerts: ${e.message}');
    throw Exception('Gagal mengambil alert: ${e.message}');
  }
});

/// Provider untuk inventory statistics
final inventoryStatsProvider = FutureProvider<InventoryStats>((ref) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.get('/api/inventory/stats');
    
    if (response.statusCode == 200) {
      return InventoryStats.fromJson(response.data);
    }
    throw Exception('Statistik tidak ditemukan');
  } on DioException catch (e) {
    debugPrint('Error fetching inventory stats: ${e.message}');
    throw Exception('Gagal mengambil statistik: ${e.message}');
  }
});

/// Mutation provider untuk add stock
final addStockProvider = FutureProvider.family<InventoryResponse, AddStockRequest>((ref, request) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.post(
      '/api/inventory/stock/add',
      data: request.toJson(),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Invalidate inventory items provider to refresh
      ref.invalidate(inventoryItemsProvider);
      ref.invalidate(inventoryStatsProvider);
      ref.invalidate(inventoryAlertsProvider);
      
      return InventoryResponse.fromJson(response.data);
    }
    throw Exception('Gagal menambah stok');
  } on DioException catch (e) {
    debugPrint('Error adding stock: ${e.message}');
    throw Exception('Gagal menambah stok: ${e.message}');
  }
});

/// Mutation provider untuk remove stock
final removeStockProvider = FutureProvider.family<InventoryResponse, RemoveStockRequest>((ref, request) async {
  final dio = ref.watch(dioClientProvider).dio;
  
  try {
    final response = await dio.post(
      '/api/inventory/stock/remove',
      data: request.toJson(),
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Invalidate inventory items provider to refresh
      ref.invalidate(inventoryItemsProvider);
      ref.invalidate(inventoryStatsProvider);
      ref.invalidate(inventoryAlertsProvider);
      
      return InventoryResponse.fromJson(response.data);
    }
    throw Exception('Gagal mengurangi stok');
  } on DioException catch (e) {
    debugPrint('Error removing stock: ${e.message}');
    throw Exception('Gagal mengurangi stok: ${e.message}');
  }
});

/// State management untuk search/filter
final inventoryFilterProvider = StateProvider<InventoryFilter>((ref) {
  return const InventoryFilter();
});

class InventoryFilter {
  final String category;
  final String searchQuery;
  final String status; // all, low_stock, out_of_stock

  const InventoryFilter({
    this.category = 'Semua',
    this.searchQuery = '',
    this.status = 'all',
  });

  InventoryFilter copyWith({
    String? category,
    String? searchQuery,
    String? status,
  }) {
    return InventoryFilter(
      category: category ?? this.category,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toParams() {
    return {
      if (category != 'Semua') 'category': category,
      if (searchQuery.isNotEmpty) 'search': searchQuery,
      if (status != 'all') 'status': status,
    };
  }
}
