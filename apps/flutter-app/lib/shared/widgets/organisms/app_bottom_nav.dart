library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';


/// Destination de navigation.
class AppNavDestination {
  const AppNavDestination({
    required this.icon,
    required this.label,
    this.badge,
  });

  final IconData icon;
  final String label;

  /// Optionnel : badge de compteur (ex. messages non lus).
  final int? badge;
}


/// Barre de navigation inférieure Learn@Home.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  }) : assert(
          destinations.length >= 2 && destinations.length <= 5,
          'AppBottomNav accepte entre 2 et 5 destinations.',
        );

  final List<AppNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations.map(_buildDestination).toList(),
      ),
    );
  }

  NavigationDestination _buildDestination(AppNavDestination dest) {
    final icon = Icon(dest.icon);

    return NavigationDestination(
      icon: dest.badge != null && dest.badge! > 0
          ? Badge(label: Text('${dest.badge}'), child: icon)
          : icon,
      selectedIcon: dest.badge != null && dest.badge! > 0
          ? Badge(
              label: Text('${dest.badge}'),
              child: Icon(dest.icon, color: AppColors.primary),
            )
          : Icon(dest.icon, color: AppColors.primary),
      label: dest.label,
    );
  }
}
