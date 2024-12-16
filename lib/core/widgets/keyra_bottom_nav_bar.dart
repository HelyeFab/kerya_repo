import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class KeyraBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const KeyraBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon == HugeIcons.strokeRoundedDashboardBrowsing)
              HugeIcon(
                icon: icon,
                color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurface,
                size: 20.0,
              )
            else
              Icon(
                icon,
                color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurface,
                size: 20,
              ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? primaryColor : Theme.of(context).colorScheme.onSurface,
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: HugeIcons.strokeRoundedHome13,
              label: 'Home',
              index: 0,
            ),
            _buildNavItem(
              context: context,
              icon: HugeIcons.strokeRoundedBook02,
              label: 'Library',
              index: 1,
            ),
            _buildNavItem(
              context: context,
              icon: HugeIcons.strokeRoundedIdea01,
              label: 'Create',
              index: 2,
            ),
            _buildNavItem(
              context: context,
              icon: HugeIcons.strokeRoundedDashboardBrowsing,
              label: 'Dashboard',
              index: 3,
            ),
            _buildNavItem(
              context: context,
              icon: HugeIcons.strokeRoundedUserCircle,
              label: 'Profile',
              index: 4,
            ),
          ],
        ),
      ),
    );
  }
}
