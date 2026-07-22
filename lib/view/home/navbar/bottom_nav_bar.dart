import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppTheme.surface,
      elevation: 8,
      currentIndex: currentIndex > 1 ? 3 : currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 24),
          activeIcon: Icon(Icons.home, size: 24),
          label: 'Feed',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore_outlined, size: 24),
          activeIcon: Icon(Icons.explore, size: 24),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail_outlined, size: 24),
          activeIcon: Icon(Icons.mail, size: 24),
          label: 'Messages',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined, size: 24),
          activeIcon: Icon(Icons.person, size: 24),
          label: 'Profile',
        ),
      ],
      selectedItemColor: AppTheme.primarySoft,
      unselectedItemColor: AppTheme.textSecondary,
      selectedLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
