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
        _NavItem('Performa', Icons.leaderboard_outlined, Icons.leaderboard_rounded, '/owner/performance'),
        _NavItem('Laporan', Icons.bar_chart_outlined, Icons.bar_chart_rounded, '/owner/reports'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/owner/profile'),
      ];
    case UserRole.kepalaCabang:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/kepala-cabang'),
        _NavItem('Tugas', Icons.task_outlined, Icons.task_rounded, '/kepala-cabang/tasks'),
        _NavItem('Laporan', Icons.description_outlined, Icons.description_rounded, '/kepala-cabang/reports'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/kepala-cabang/profile'),
      ];
    case UserRole.admin:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/admin'),
        _NavItem('Inventori', Icons.inventory_2_outlined, Icons.inventory_2_rounded, '/admin/inventory'),
        _NavItem('Tugas', Icons.task_outlined, Icons.task_rounded, '/admin/tasks'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/admin/profile'),
      ];
    case UserRole.sales:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/sales'),
        _NavItem('Prospek', Icons.people_outline_rounded, Icons.people_rounded, '/sales/prospects'),
        _NavItem('Kampanye', Icons.campaign_outlined, Icons.campaign_rounded, '/sales/campaigns'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/sales/profile'),
      ];
    case UserRole.driver:
      return [
        _NavItem('Beranda', Icons.home_outlined, Icons.home_rounded, '/driver'),
        _NavItem('Pengiriman', Icons.local_shipping_outlined, Icons.local_shipping_rounded, '/driver/deliveries'),
        _NavItem('Absensi', Icons.fingerprint_rounded, Icons.fingerprint_rounded, '/driver/attendance'),
        _NavItem('Profil', Icons.person_outline_rounded, Icons.person_rounded, '/driver/profile'),
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
    case UserRole.owner: return AppColors.ownerColor;
    case UserRole.kepalaCabang: return AppColors.kepalaCabangColor;
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
    final user = ref.watch(currentUserProvider);
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
