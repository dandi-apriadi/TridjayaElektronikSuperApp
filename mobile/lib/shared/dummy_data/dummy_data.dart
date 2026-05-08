class DummyBranch {
  final String id;
  final String name;
  final String address;

  const DummyBranch({required this.id, required this.name, required this.address});
}

class DummyInventorySummary {
  final String branchId;
  final int akiStock;
  final int tvStock;
  final int hpStock;
  final int lowStockCount;

  const DummyInventorySummary({
    required this.branchId,
    required this.akiStock,
    required this.tvStock,
    required this.hpStock,
    required this.lowStockCount,
  });
}

class DummySalesData {
  final String branchId;
  final int dailySales;
  final int weeklySales;
  final int monthlySales;
  final double dailyRevenue;

  const DummySalesData({
    required this.branchId,
    required this.dailySales,
    required this.weeklySales,
    required this.monthlySales,
    required this.dailyRevenue,
  });
}

class DummyEmployee {
  final String id;
  final String name;
  final String role;
  final String branchId;
  final String status;
  final double score;

  const DummyEmployee({
    required this.id,
    required this.name,
    required this.role,
    required this.branchId,
    required this.status,
    required this.score,
  });
}

class DummyTask {
  final String id;
  final String title;
  final String assignee;
  final String priority;
  final String status;
  final DateTime dueDate;

  const DummyTask({
    required this.id,
    required this.title,
    required this.assignee,
    required this.priority,
    required this.status,
    required this.dueDate,
  });
}

class DummyDelivery {
  final String id;
  final String customerName;
  final String address;
  final String status;
  final String scheduledTime;

  const DummyDelivery({
    required this.id,
    required this.customerName,
    required this.address,
    required this.status,
    required this.scheduledTime,
  });
}

class DummyProspect {
  final String id;
  final String name;
  final String phone;
  final String productInterest;
  final String status;

  const DummyProspect({
    required this.id,
    required this.name,
    required this.phone,
    required this.productInterest,
    required this.status,
  });
}

class DummyDataProvider {
  static const List<DummyBranch> branches = [
    DummyBranch(id: 'b1', name: 'Cabang Pusat', address: 'Jl. Sudirman No. 1, Jakarta'),
    DummyBranch(id: 'b2', name: 'Cabang Selatan', address: 'Jl. Fatmawati No. 55, Jakarta Selatan'),
    DummyBranch(id: 'b3', name: 'Cabang Timur', address: 'Jl. Bekasi Raya No. 12, Jakarta Timur'),
  ];

  static const List<DummyInventorySummary> inventories = [
    DummyInventorySummary(branchId: 'b1', akiStock: 145, tvStock: 32, hpStock: 78, lowStockCount: 3),
    DummyInventorySummary(branchId: 'b2', akiStock: 87, tvStock: 15, hpStock: 102, lowStockCount: 1),
    DummyInventorySummary(branchId: 'b3', akiStock: 210, tvStock: 44, hpStock: 55, lowStockCount: 5),
  ];

  static const List<DummySalesData> salesData = [
    DummySalesData(branchId: 'b1', dailySales: 12, weeklySales: 67, monthlySales: 289, dailyRevenue: 45500000),
    DummySalesData(branchId: 'b2', dailySales: 8, weeklySales: 43, monthlySales: 178, dailyRevenue: 28750000),
    DummySalesData(branchId: 'b3', dailySales: 15, weeklySales: 82, monthlySales: 341, dailyRevenue: 61200000),
  ];

  static final List<DummyEmployee> employees = [
    DummyEmployee(id: 'e1', name: 'Budi Santoso', role: 'Sales', branchId: 'b1', status: 'Hadir', score: 92.5),
    DummyEmployee(id: 'e2', name: 'Siti Rahayu', role: 'Sales', branchId: 'b1', status: 'Hadir', score: 88.0),
    DummyEmployee(id: 'e3', name: 'Ahmad Fauzi', role: 'Sales', branchId: 'b2', status: 'Terlambat', score: 74.5),
    DummyEmployee(id: 'e4', name: 'Dewi Lestari', role: 'Admin', branchId: 'b1', status: 'Hadir', score: 95.0),
    DummyEmployee(id: 'e5', name: 'Rudi Hartono', role: 'Driver', branchId: 'b1', status: 'Hadir', score: 85.5),
    DummyEmployee(id: 'e6', name: 'Maya Indah', role: 'Sales', branchId: 'b3', status: 'Hadir', score: 91.0),
    DummyEmployee(id: 'e7', name: 'Hendra Wijaya', role: 'Driver', branchId: 'b2', status: 'Absen', score: 60.0),
    DummyEmployee(id: 'e8', name: 'Rina Kusuma', role: 'Admin', branchId: 'b3', status: 'Hadir', score: 89.0),
  ];

  static final List<DummyTask> tasks = [
    DummyTask(id: 't1', title: 'Update stok Aki GS Astra', assignee: 'Dewi Lestari', priority: 'High', status: 'Pending', dueDate: DateTime.now().add(const Duration(hours: 3))),
    DummyTask(id: 't2', title: 'Follow up prospek TV Samsung', assignee: 'Budi Santoso', priority: 'Urgent', status: 'InProgress', dueDate: DateTime.now().add(const Duration(hours: 1))),
    DummyTask(id: 't3', title: 'Kirim laporan mingguan', assignee: 'Siti Rahayu', priority: 'Medium', status: 'Pending', dueDate: DateTime.now().add(const Duration(days: 1))),
    DummyTask(id: 't4', title: 'Pengecekan stok HP Xiaomi', assignee: 'Dewi Lestari', priority: 'Low', status: 'Completed', dueDate: DateTime.now().subtract(const Duration(hours: 2))),
    DummyTask(id: 't5', title: 'Antar barang ke Cibubur', assignee: 'Rudi Hartono', priority: 'High', status: 'InProgress', dueDate: DateTime.now().add(const Duration(hours: 2))),
  ];

  static final List<DummyDelivery> deliveries = [
    DummyDelivery(id: 'd1', customerName: 'Pak Joko Susilo', address: 'Jl. Mawar No. 15, Cibubur', status: 'Pending', scheduledTime: '09:00'),
    DummyDelivery(id: 'd2', customerName: 'Ibu Sri Wahyuni', address: 'Jl. Anggrek No. 7, Bekasi', status: 'InProgress', scheduledTime: '11:00'),
    DummyDelivery(id: 'd3', customerName: 'Pak Dedi Kurniawan', address: 'Jl. Melati No. 22, Depok', status: 'Completed', scheduledTime: '08:00'),
    DummyDelivery(id: 'd4', customerName: 'Ibu Ratna Dewi', address: 'Jl. Kenanga No. 3, Bogor', status: 'Pending', scheduledTime: '14:00'),
  ];

  static const List<DummyProspect> prospects = [
    DummyProspect(id: 'p1', name: 'Bapak Andi', phone: '08123456789', productInterest: 'Aki', status: 'Negotiation'),
    DummyProspect(id: 'p2', name: 'Ibu Cantika', phone: '08987654321', productInterest: 'TV', status: 'Contacted'),
    DummyProspect(id: 'p3', name: 'Pak Suryo', phone: '08111222333', productInterest: 'HP', status: 'New'),
    DummyProspect(id: 'p4', name: 'Ibu Mega', phone: '08444555666', productInterest: 'Aki', status: 'Closed'),
    DummyProspect(id: 'p5', name: 'Pak Wahyu', phone: '08777888999', productInterest: 'TV', status: 'Lost'),
    DummyProspect(id: 'p6', name: 'Ibu Sandra', phone: '08222333444', productInterest: 'HP', status: 'New'),
  ];
}
