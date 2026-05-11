import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  const _NavItem(this.label, this.icon, this.activeIcon, this.route);
}

List<_NavItem> _navItemsFor(UserRole role, String baseRoute) {
  switch (role) {
    case UserRole.owner:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/owner'),
        _NavItem('Job Desk', Icons.assignment_outlined, Icons.assignment_rounded, '/jobdesk/templates'),
        _NavItem('Laporan', Icons.analytics_outlined, Icons.analytics_rounded, '/jobdesk/report?role=owner'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/owner/profile'),
      ];
    case UserRole.kepalaCabang:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/kepala-cabang'),
        _NavItem('Laporan', Icons.analytics_outlined, Icons.analytics_rounded, '/jobdesk/report?role=kepalaCabang&branch=branch_001'),
        _NavItem('Verifikasi', Icons.fact_check_outlined, Icons.fact_check_rounded, '/jobdesk/pic'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/kepala-cabang/profile'),
      ];
    case UserRole.picPelaporan:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/jobdesk/pic'),
        _NavItem('Verifikasi', Icons.fact_check_outlined, Icons.fact_check_rounded, '/jobdesk/pic-verification'),
        _NavItem('Laporan', Icons.analytics_outlined, Icons.analytics_rounded, '/jobdesk/report?role=pic_pelaporan'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/kepala-cabang/profile'),
      ];
    case UserRole.admin:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/admin'),
        _NavItem('Inventori', Icons.inventory_2_outlined, Icons.inventory_2_rounded, '/admin/inventory'),
        _NavItem('Job Desk', Icons.assignment_outlined, Icons.assignment_rounded, '/jobdesk'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/admin/profile'),
      ];
    case UserRole.sales:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/sales'),
        _NavItem('Prospek', Icons.people_outline_rounded, Icons.people_rounded, '/sales/prospects'),
        _NavItem('Job Desk', Icons.assignment_outlined, Icons.assignment_rounded, '/jobdesk'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/sales/profile'),
      ];
    case UserRole.driver:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/driver'),
        _NavItem('Pengiriman', Icons.local_shipping_outlined, Icons.local_shipping_rounded, '/driver/deliveries'),
        _NavItem('Job Desk', Icons.assignment_outlined, Icons.assignment_rounded, '/jobdesk'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/driver/profile'),
      ];
    
    case UserRole.superAdmin:
      return [
        _NavItem('Dashboard', Icons.dashboard_outlined, Icons.dashboard_rounded, '/superadmin'),
        _NavItem('Pengguna', Icons.people_outline, Icons.people, '/superadmin/users'),
        _NavItem('Monitoring', Icons.analytics_outlined, Icons.analytics_rounded, '/superadmin/monitoring'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/superadmin/profile'),
      ];
  }
}

int _currentNavIndex(List<_NavItem> navItems, String currentRoute) {
  // Exact match first
  final exactIdx = navItems.indexWhere((n) => n.route == currentRoute);
  if (exactIdx >= 0) return exactIdx;
  // Prefix match (longest prefix wins)
  int bestIdx = 0;
  int bestLen = 0;
  for (int i = 0; i < navItems.length; i++) {
    if (currentRoute.startsWith(navItems[i].route) && navItems[i].route.length > bestLen) {
      bestIdx = i;
      bestLen = navItems[i].route.length;
    }
  }
  return bestIdx;
}

Color _roleColor(UserRole role) {
  switch (role) {
    case UserRole.superAdmin: return const Color(0xFF1A1A2E); // Dark admin color
    case UserRole.owner: return AppColors.ownerColor;
    case UserRole.kepalaCabang: return AppColors.kepalaCabangColor;
    case UserRole.picPelaporan: return AppColors.kepalaCabangColor;
    case UserRole.admin: return AppColors.adminColor;
    case UserRole.sales: return AppColors.salesColor;
    case UserRole.driver: return AppColors.driverColor;
  }
}

class AppScaffold extends ConsumerWidget {
  final Widget child;
  final String currentRoute;

  const AppScaffold({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.valueOrNull;
    if (user == null) return child;

    final role = user.role;
    final navItems = _navItemsFor(role, currentRoute);
    final color = _roleColor(role);

    final currentIndex = _currentNavIndex(navItems, currentRoute);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!isActive) context.go(item.route);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive ? color.withOpacity(0.12) : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            color: isActive ? color : AppColors.textHint,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            color: isActive ? color : AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
