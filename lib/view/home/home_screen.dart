import 'package:flutter/material.dart';
import '../../auth/auth_storage.dart';
import '../../app/theme/app_theme.dart';
import 'screens/home_feed_screen.dart';
import 'widgets/bottom_nav_bar.dart';
import 'screens/explore_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String vendorName;

  const HomeScreen({super.key, required this.vendorName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<String> _pageTitles = [
    'Home',
    'Explore',
    'Messages',
    'Profile',
  ];

  static const List<String> _pageSubtitles = [
    'Quick access to your dashboard',
    'Browse tools and product ideas',
    'Stay on top of customer chats',
    'Update your seller details',
  ];

  @override
  Widget build(BuildContext context) {
    final String pageSubtitle = _pageSubtitles[_currentIndex];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: SizedBox.shrink(),
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect Vendor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 2),
            Text(
              pageSubtitle,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_outlined,
              color: AppTheme.textPrimary,
            ),
            onPressed: () => _showActionMessage('Search tapped'),
            tooltip: 'Search',
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppTheme.textPrimary,
            ),
            onPressed: () => _showActionMessage('Notifications tapped'),
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 3) {
            _loadProfileImage();
          }
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return HomeFeedScreen(vendorName: widget.vendorName);
      case 1:
        return ExploreScreen();
      case 2:
        return MessagesScreen();
      case 3:
        return ProfileScreen(
          vendorName: widget.vendorName,
          onProfileUpdated: _loadProfileImage,
        );
      default:
        return HomeFeedScreen(vendorName: widget.vendorName);
    }
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }
}
