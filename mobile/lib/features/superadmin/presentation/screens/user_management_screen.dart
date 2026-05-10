import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/user_model.dart';

/// ============================================================
/// 👥 USER MANAGEMENT SCREEN
/// Super Admin kelola user & cabang
/// ============================================================

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  String _selectedTab = 'users'; // users, branches
  String _searchQuery = '';
  String _selectedRole = 'all';
  String _selectedBranch = 'all';

  // Dummy users data
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'name': 'Pak Iwan',
      'email': 'iwan@tridjaya.co.id',
      'phone': '081234567890',
      'role': 'owner',
      'branch': 'Pusat',
      'isActive': true,
      'lastLogin': DateTime.now().subtract(const Duration(hours: 2)),
      'createdAt': DateTime.now().subtract(const Duration(days: 365)),
    },
    {
      'id': '2',
      'name': 'Ahmad Santoso',
      'email': 'ahmad.s@tridjaya.co.id',
      'phone': '081234567891',
      'role': 'sales',
      'branch': 'Cabang Bandung',
      'isActive': true,
      'lastLogin': DateTime.now().subtract(const Duration(hours: 5)),
      'createdAt': DateTime.now().subtract(const Duration(days: 180)),
    },
    {
      'id': '3',
      'name': 'Budi Wijaya',
      'email': 'budi.w@tridjaya.co.id',
      'phone': '081234567892',
      'role': 'kepala_cabang',
      'branch': 'Cabang Bandung',
      'isActive': true,
      'lastLogin': DateTime.now().subtract(const Duration(days: 1)),
      'createdAt': DateTime.now().subtract(const Duration(days: 200)),
    },
    {
      'id': '4',
      'name': 'Citra Dewi',
      'email': 'citra.d@tridjaya.co.id',
      'phone': '081234567893',
      'role': 'driver',
      'branch': 'Cabang Jakarta',
      'isActive': false,
      'lastLogin': DateTime.now().subtract(const Duration(days: 30)),
      'createdAt': DateTime.now().subtract(const Duration(days: 90)),
    },
    {
      'id': '5',
      'name': 'Dedi Kurniawan',
      'email': 'dedi.k@tridjaya.co.id',
      'phone': '081234567894',
      'role': 'admin',
      'branch': 'Cabang Surabaya',
      'isActive': true,
      'lastLogin': DateTime.now().subtract(const Duration(hours: 1)),
      'createdAt': DateTime.now().subtract(const Duration(days: 120)),
    },
  ];

  // Dummy branches data
  final List<Map<String, dynamic>> _branches = [
    {
      'id': '1',
      'name': 'Cabang Bandung',
      'code': 'BDG',
      'address': 'Jl. Sudirman No. 123, Bandung',
      'phone': '022-1234567',
      'kepalaCabang': 'Budi Wijaya',
      'employees': 12,
      'isActive': true,
    },
    {
      'id': '2',
      'name': 'Cabang Jakarta',
      'code': 'JKT',
      'address': 'Jl. Thamrin No. 45, Jakarta',
      'phone': '021-7654321',
      'kepalaCabang': 'Siti Rahayu',
      'employees': 15,
      'isActive': true,
    },
    {
      'id': '3',
      'name': 'Cabang Surabaya',
      'code': 'SBY',
      'address': 'Jl. Pemuda No. 78, Surabaya',
      'phone': '031-9876543',
      'kepalaCabang': 'Agus Salim',
      'employees': 10,
      'isActive': true,
    },
    {
      'id': '4',
      'name': 'Cabang Medan',
      'code': 'MDN',
      'address': 'Jl. Gatot Subroto No. 90, Medan',
      'phone': '061-4567890',
      'kepalaCabang': 'Belum ditunjuk',
      'employees': 0,
      'isActive': false,
    },
  ];

  final List<Map<String, dynamic>> _roles = [
    {'id': 'all', 'name': 'Semua Role'},
    {'id': 'owner', 'name': 'Owner'},
    {'id': 'kepala_cabang', 'name': 'Kepala Cabang'},
    {'id': 'sales', 'name': 'Sales'},
    {'id': 'driver', 'name': 'Driver'},
    {'id': 'admin', 'name': 'Admin'},
  ];

  List<Map<String, dynamic>> get _filteredUsers {
    return _users.where((user) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!user['name'].toString().toLowerCase().contains(query) &&
            !user['email'].toString().toLowerCase().contains(query) &&
            !user['phone'].toString().toLowerCase().contains(query)) {
          return false;
        }
      }
      if (_selectedRole != 'all' && user['role'] != _selectedRole) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF8B0000), // Super admin dark red
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Manajemen Pengguna',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) => setState(() => _selectedTab = index == 0 ? 'users' : 'branches'),
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Pengguna'),
            Tab(icon: Icon(Icons.business), text: 'Cabang'),
          ],
        ),
      ),
      body: _selectedTab == 'users' ? _buildUsersTab() : _buildBranchesTab(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedTab == 'users') {
            _showAddUserDialog();
          } else {
            _showAddBranchDialog();
          }
        },
        backgroundColor: const Color(0xFF8B0000),
        icon: const Icon(Icons.add),
        label: Text(_selectedTab == 'users' ? 'Tambah User' : 'Tambah Cabang'),
      ),
    );
  }

  Widget _buildUsersTab() {
    return Column(
      children: [
        // Search & Filter
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            children: [
              // Search
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari user...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF8B0000)),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Role Filter
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _roles.length,
                  itemBuilder: (context, index) {
                    final role = _roles[index];
                    final isSelected = _selectedRole == role['id'];

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => _selectedRole = role['id']);
                        },
                        label: Text(role['name']),
                        selectedColor: const Color(0xFF8B0000).withOpacity(0.1),
                        checkmarkColor: const Color(0xFF8B0000),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF8B0000) : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Users List
        Expanded(
          child: _filteredUsers.isEmpty
              ? _buildEmptyState('Tidak ada user ditemukan')
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    return _buildUserCard(_filteredUsers[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildBranchesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _branches.length,
      itemBuilder: (context, index) {
        return _buildBranchCard(_branches[index]);
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final role = user['role'] as String;
    final isActive = user['isActive'] as bool;

    Color roleColor;
    String roleLabel;
    IconData roleIcon;

    switch (role) {
      case 'owner':
        roleColor = const Color(0xFF8B0000);
        roleLabel = 'Owner';
        roleIcon = Icons.account_balance;
        break;
      case 'kepala_cabang':
        roleColor = AppColors.primary;
        roleLabel = 'Kepala Cabang';
        roleIcon = Icons.store;
        break;
      case 'sales':
        roleColor = AppColors.salesColor;
        roleLabel = 'Sales';
        roleIcon = Icons.shopping_bag;
        break;
      case 'driver':
        roleColor = AppColors.driverColor;
        roleLabel = 'Driver';
        roleIcon = Icons.local_shipping;
        break;
      case 'admin':
        roleColor = AppColors.adminColor;
        roleLabel = 'Admin';
        roleIcon = Icons.settings;
        break;
      default:
        roleColor = AppColors.textHint;
        roleLabel = role;
        roleIcon = Icons.person;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: isActive ? roleColor.withOpacity(0.2) : AppColors.textHint.withOpacity(0.2),
          child: Icon(
            roleIcon,
            color: isActive ? roleColor : AppColors.textHint,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                user['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            if (!isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.textHint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Nonaktif',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    roleLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: roleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.business, size: 12, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(
                  user['branch'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    user['email'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.phone, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(
                  user['phone'],
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showEditUserDialog(user);
            } else if (value == 'toggle') {
              _toggleUserStatus(user);
            } else if (value == 'reset') {
              _showResetPasswordDialog(user);
            } else if (value == 'delete') {
              _showDeleteUserConfirmation(user);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(
              value: 'toggle',
              child: Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
            ),
            const PopupMenuItem(value: 'reset', child: Text('Reset Password')),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Hapus', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
        onTap: () => _showUserDetail(user),
      ),
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> branch) {
    final isActive = branch['isActive'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: isActive
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.textHint.withOpacity(0.2),
          child: Text(
            branch['code'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? AppColors.primary : AppColors.textHint,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                branch['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            if (!isActive)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.textHint.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Nonaktif',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    branch['address'],
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${branch['employees']} Karyawan',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, size: 14, color: AppColors.info),
                      const SizedBox(width: 4),
                      Text(
                        'KC: ${branch['kepalaCabang']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.info,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showEditBranchDialog(branch);
            } else if (value == 'toggle') {
              _toggleBranchStatus(branch);
            } else if (value == 'delete') {
              _showDeleteBranchConfirmation(branch);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(
              value: 'toggle',
              child: Text(isActive ? 'Nonaktifkan' : 'Aktifkan'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Hapus', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
        onTap: () => _showBranchDetail(branch),
      ),
    );
  }

  // Dialog methods
  void _showAddUserDialog() {
    // Show add user dialog
  }

  void _showAddBranchDialog() {
    // Show add branch dialog
  }

  void _showEditUserDialog(Map<String, dynamic> user) {
    // Show edit user dialog
  }

  void _showEditBranchDialog(Map<String, dynamic> branch) {
    // Show edit branch dialog
  }

  void _showUserDetail(Map<String, dynamic> user) {
    // Show user detail
  }

  void _showBranchDetail(Map<String, dynamic> branch) {
    // Show branch detail
  }

  void _showResetPasswordDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password?'),
        content: Text('Reset password untuk ${user['name']}? Password baru akan dikirim ke email/user.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('✅ Password ${user['name']} telah direset')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B0000)),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserConfirmation(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus User?'),
        content: Text('Yakin ingin menghapus ${user['name']}? Data tidak dapat dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() => _users.removeWhere((u) => u['id'] == user['id']));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ User dihapus'), backgroundColor: AppColors.error),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showDeleteBranchConfirmation(Map<String, dynamic> branch) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Cabang?'),
        content: Text('Yakin ingin menghapus ${branch['name']}? Semua data terkait akan hilang.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              setState(() => _branches.removeWhere((b) => b['id'] == branch['id']));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑️ Cabang dihapus'), backgroundColor: AppColors.error),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _toggleUserStatus(Map<String, dynamic> user) {
    setState(() => user['isActive'] = !user['isActive']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(user['isActive']
            ? '✅ ${user['name']} diaktifkan'
            : '⏸️ ${user['name']} dinonaktifkan'),
      ),
    );
  }

  void _toggleBranchStatus(Map<String, dynamic> branch) {
    setState(() => branch['isActive'] = !branch['isActive']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(branch['isActive']
            ? '✅ ${branch['name']} diaktifkan'
            : '⏸️ ${branch['name']} dinonaktifkan'),
      ),
    );
  }
}
