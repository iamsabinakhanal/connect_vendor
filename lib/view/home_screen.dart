import 'package:flutter/material.dart';
import 'dart:convert';
import '../auth/session_storage.dart';
import '../core/utils/local_database.dart';
import '../auth/login_screen.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatefulWidget {
  final String vendorName;

  const HomeScreen({super.key, required this.vendorName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _chatHistoryKey = 'demo_chat_history_v1';
  int _currentIndex = 0;
  int _selectedExploreCategoryIndex = 0;
  late TextEditingController _chatController;
  int _activeChatIndex = -1;
  final List<_DemoChat> _demoChats = [
    _DemoChat(
      name: 'Sabitra Khanal',
      lastMessage: 'Did you check today\'s offers?',
      time: '10:24 AM',
      unread: 2,
      color: Color(0xFF60A5FA),
    ),
    _DemoChat(
      name: 'Kirty Dhakal',
      lastMessage: 'Let\'s post your product reel today.',
      time: '9:11 AM',
      unread: 0,
      color: Color(0xFFF472B6),
    ),
    _DemoChat(
      name: 'Vendor Community',
      lastMessage: '12 new messages',
      time: 'Yesterday',
      unread: 12,
      color: Color(0xFF34D399),
    ),
    _DemoChat(
      name: 'TechVendor Pro',
      lastMessage: 'Thanks for sharing the catalog.',
      time: 'Yesterday',
      unread: 0,
      color: Color(0xFFA78BFA),
    ),
  ];
  final List<String> _exploreCategories = [
    'All',
    'Screwdrivers',
    'Soldering',
    'Testing',
    'Screen Repair',
    'Accessories',
  ];
  final List<_ExploreToolItem> _exploreItems = [
    _ExploreToolItem(
      category: 'Screwdrivers',
      title: 'Precision Screwdriver Set 120-in-1',
      seller: 'ToolHub Nepal',
      likes: '31.3K',
      price: 'Rs. 2,450',
      icon: Icons.build,
      colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
    ),
    _ExploreToolItem(
      category: 'Soldering',
      title: 'Quick Heat Soldering Station 60W',
      seller: 'FixMaster Store',
      likes: '14.8K',
      price: 'Rs. 4,900',
      icon: Icons.electrical_services,
      colors: [Color(0xFFF97316), Color(0xFFEA580C)],
    ),
    _ExploreToolItem(
      category: 'Testing',
      title: 'Digital Multimeter with Probes',
      seller: 'Mobile Lab Supplies',
      likes: '19.3K',
      price: 'Rs. 1,850',
      icon: Icons.speed,
      colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
    ),
    _ExploreToolItem(
      category: 'Screen Repair',
      title: 'LCD Separator Machine Mini',
      seller: 'Repair King',
      likes: '8.5K',
      price: 'Rs. 12,500',
      icon: Icons.tablet_android,
      colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
    ),
    _ExploreToolItem(
      category: 'Accessories',
      title: 'Anti-Static ESD Mat + Wrist Strap',
      seller: 'SafeFix Tools',
      likes: '21.6K',
      price: 'Rs. 1,200',
      icon: Icons.shield,
      colors: [Color(0xFF22C55E), Color(0xFF15803D)],
    ),
    _ExploreToolItem(
      category: 'Soldering',
      title: 'Lead-Free Solder Wire Pack',
      seller: 'Solder World',
      likes: '11.4K',
      price: 'Rs. 750',
      icon: Icons.cable,
      colors: [Color(0xFFFB7185), Color(0xFFBE123C)],
    ),
    _ExploreToolItem(
      category: 'Testing',
      title: 'DC Power Supply 30V/5A',
      seller: 'Volt & Fix',
      likes: '9.9K',
      price: 'Rs. 8,200',
      icon: Icons.bolt,
      colors: [Color(0xFFF59E0B), Color(0xFFB45309)],
    ),
    _ExploreToolItem(
      category: 'Screen Repair',
      title: 'Phone Opening Picks + Suction Kit',
      seller: 'Display Doctor',
      likes: '29.4K',
      price: 'Rs. 980',
      icon: Icons.phonelink_erase,
      colors: [Color(0xFF6366F1), Color(0xFF4338CA)],
    ),
  ];
  late Map<int, List<_ChatMessage>> _chatMessages;

  @override
  void initState() {
    super.initState();
    _chatController = TextEditingController();
    _chatMessages = {
      0: [
        _ChatMessage(
          text: 'Namaste! Have you seen new offers?',
          isMe: false,
          createdAt: DateTime.now().subtract(Duration(minutes: 35)),
        ),
        _ChatMessage(
          text: 'Not yet, I will check now.',
          isMe: true,
          createdAt: DateTime.now().subtract(Duration(minutes: 34)),
          status: 'seen',
        ),
      ],
      1: [
        _ChatMessage(
          text: 'Let\'s post your product reel today.',
          isMe: false,
          createdAt: DateTime.now().subtract(Duration(minutes: 50)),
        ),
      ],
      2: [
        _ChatMessage(
          text: 'Welcome to Vendor Community.',
          isMe: false,
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
        ),
        _ChatMessage(
          text: 'Thank you everyone!',
          isMe: true,
          createdAt: DateTime.now().subtract(Duration(hours: 2, minutes: 1)),
          status: 'seen',
        ),
      ],
      3: [
        _ChatMessage(
          text: 'Thanks for sharing the catalog.',
          isMe: false,
          createdAt: DateTime.now().subtract(Duration(hours: 3)),
        ),
      ],
    };
    _loadChatHistory();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF6366F1),
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => _showActionMessage('Profile logo tapped'),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'PG',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: SizedBox.shrink(),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () => _showActionMessage('Notifications tapped'),
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: (_currentIndex == 2 && _activeChatIndex >= 0)
          ? null
          : BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _currentIndex > 1 ? 3 : _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  if (index != 2) {
                    _activeChatIndex = -1;
                    _chatController.clear();
                  }
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  label: 'Explore',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.mail_outline),
                  label: 'Messages',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: Color(0xFF6366F1),
              unselectedItemColor: Colors.grey,
            ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHome();
      case 1:
        return _buildExplore();
      case 2:
        return _buildMessages();
      case 3:
        return _buildProfile();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCreatePostComposer(),
          _buildFeedPost(
            vendorName: 'TechVendor Pro',
            vendorInitial: 'T',
            productTitle: 'Premium Laptop Stand',
            productDescription:
                'Ergonomic aluminum laptop stand perfect for work from home setup. Adjustable height and angle for maximum comfort.',
            productImage: Icons.laptop,
            likes: 234,
            comments: 45,
            shares: 12,
            isLiked: false,
          ),
          _buildFeedPost(
            vendorName: 'Quality Electronics',
            vendorInitial: 'Q',
            productTitle: 'USB-C Hub Adapter',
            productDescription:
                'Multi-port USB-C hub with HDMI, USB 3.0, and SD card reader. Perfect for MacBook and Windows laptops.',
            productImage: Icons.router,
            likes: 567,
            comments: 89,
            shares: 34,
            isLiked: true,
          ),
          _buildFeedPost(
            vendorName: 'Office Solutions',
            vendorInitial: 'O',
            productTitle: 'Mechanical Keyboard RGB',
            productDescription:
                'Premium mechanical keyboard with customizable RGB lighting. Perfect for gaming and professional work.',
            productImage: Icons.keyboard,
            likes: 892,
            comments: 156,
            shares: 78,
            isLiked: false,
          ),
          _buildFeedPost(
            vendorName: 'Digital Accessories',
            vendorInitial: 'D',
            productTitle: 'Wireless Mouse Pro',
            productDescription:
                'Precision wireless mouse with ergonomic design. 12-month battery life and advanced tracking technology.',
            productImage: Icons.touch_app,
            likes: 445,
            comments: 67,
            shares: 45,
            isLiked: false,
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePostComposer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE0E7FF),
                  ),
                  child: Center(
                    child: Text(
                      widget.vendorName.isNotEmpty
                          ? widget.vendorName[0].toUpperCase()
                          : 'V',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF4338CA),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _openCreatePostPage,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Text(
                        "What's on your mind, ${widget.vendorName}?",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.photo_library,
                    label: 'Photo',
                    color: Color(0xFF22C55E),
                    onTap: () => _showActionMessage('Photo picker tapped'),
                  ),
                ),
                Container(width: 1, height: 20, color: Color(0xFFE5E7EB)),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.movie_filter,
                    label: 'video',
                    color: Color(0xFFF97316),
                    onTap: () => _showActionMessage('Video picker tapped'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedPost({
    required String vendorName,
    required String vendorInitial,
    required String productTitle,
    required String productDescription,
    required IconData productImage,
    required int likes,
    required int comments,
    required int shares,
    required bool isLiked,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      vendorInitial,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendorName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                        ),
                      ),
                      Text(
                        '2 hours ago',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showActionMessage('Saved $productTitle'),
                  child: Icon(
                    Icons.bookmark_border,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _showActionMessage('More options for $vendorName'),
                  child: Icon(Icons.more_horiz, color: Color(0xFF9CA3AF), size: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  productDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showActionMessage('Opened $productTitle details'),
            child: Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),
                border: Border.symmetric(
                  horizontal: BorderSide(color: Color(0xFFE5E7EB)),
                ),
              ),
              child: Center(
                child: Icon(
                  productImage,
                  size: 80,
                  color: Color(0xFF6366F1),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$likes Likes',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                Text(
                  '$comments Comments • $shares Shares',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_outline,
                    label: 'Like',
                    color: isLiked ? Color(0xFFEF4444) : Color(0xFF6B7280),
                    onTap: () => _showActionMessage('Liked $productTitle'),
                  ),
                ),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: 'Comment',
                    color: Color(0xFF6B7280),
                    onTap: () => _showActionMessage('Comment on $productTitle'),
                  ),
                ),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    color: Color(0xFF6B7280),
                    onTap: () => _showActionMessage('Shared $productTitle'),
                  ),
                ),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.bookmark_border,
                    label: 'Save',
                    color: Color(0xFF6B7280),
                    onTap: () => _showActionMessage('Saved $productTitle'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 24),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Color(0xFF6366F1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'V',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              widget.vendorName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            Text(
              'Vendor',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
            SizedBox(height: 32),
            _buildProfileOption(Icons.person_outline, 'Edit Profile'),
            _buildProfileOption(Icons.lock_outline, 'Change Password'),
            _buildProfileOption(Icons.help_outline, 'Help & Support'),
            _buildProfileOption(Icons.security, 'Privacy Policy'),
            SizedBox(height: 24),
            GestureDetector(
              onTap: _showLogoutDialog,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Color(0xFFEF4444)),
                ),
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplore() {
    final String selectedCategory =
        _exploreCategories[_selectedExploreCategoryIndex];
    final List<_ExploreToolItem> visibleItems = selectedCategory == 'All'
        ? _exploreItems
        : _exploreItems
            .where((item) => item.category == selectedCategory)
            .toList();

    return Container(
      color: Color(0xFFF3F4F6),
      child: Column(
        children: [
          SizedBox(height: 8),
          SizedBox(
            height: 42,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: _exploreCategories.length,
              separatorBuilder: (_, index) => SizedBox(width: 8),
              itemBuilder: (context, index) {
                final bool isSelected = index == _selectedExploreCategoryIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedExploreCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFE5E7EB) : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Text(
                      _exploreCategories[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(12, 2, 12, 12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.67,
              ),
              itemCount: visibleItems.length,
              itemBuilder: (context, index) {
                final _ExploreToolItem item = visibleItems[index];
                return GestureDetector(
                  onTap: () => _showActionMessage('${item.title} tapped'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: item.colors,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.25),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item.category,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  item.icon,
                                  size: 68,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 10,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      item.likes,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        item.seller,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        item.price,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4338CA),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    if (_activeChatIndex >= 0) {
      return _buildConversationView();
    }

    return Container(
      color: Color(0xFFEDEDED),
      child: Column(
        children: [
          Container(
            color: Color(0xFF128C7E),
            padding: EdgeInsets.fromLTRB(12, 12, 12, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Messages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _showActionMessage('Search chats tapped'),
                  icon: Icon(Icons.search, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => _showActionMessage('New chat tapped'),
                  icon: Icon(Icons.chat, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search or start new chat',
                prefixIcon: Icon(Icons.search, color: Color(0xFF9CA3AF)),
                filled: true,
                fillColor: Color(0xFFF3F4F6),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < _demoChats.length; i++)
                  _buildDemoChatTile(chat: _demoChats[i], index: i),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationView() {
    final _DemoChat activeChat = _demoChats[_activeChatIndex];
    final List<_ChatMessage> messages = _chatMessages[_activeChatIndex] ?? [];

    return Container(
      color: Color(0xFFEDEDED),
      child: Column(
        children: [
          Container(
            color: Color(0xFF128C7E),
            padding: EdgeInsets.fromLTRB(8, 12, 8, 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _activeChatIndex = -1;
                    });
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
                CircleAvatar(
                  radius: 18,
                  backgroundColor: activeChat.color,
                  child: Text(
                    activeChat.name.isNotEmpty ? activeChat.name[0] : 'U',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    activeChat.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final _ChatMessage message = messages[index];
                return Align(
                  alignment:
                      message.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    constraints: BoxConstraints(maxWidth: 270),
                    decoration: BoxDecoration(
                      color: message.isMe ? Color(0xFFDCF8C6) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _formatMessageTime(message.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            if (message.isMe) ...[
                              SizedBox(width: 4),
                              Icon(
                                message.status == 'seen'
                                    ? Icons.done_all
                                    : Icons.done,
                                size: 14,
                                color: message.status == 'seen'
                                    ? Color(0xFF2563EB)
                                    : Color(0xFF6B7280),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _showActionMessage('Attachment tapped'),
                  icon: Icon(Icons.attach_file, color: Color(0xFF6B7280)),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _chatController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendDemoMessage,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Color(0xFF25D366),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoChatTile({
    required _DemoChat chat,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeChatIndex = index;
          _demoChats[index].unread = 0;
        });
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: EdgeInsets.only(bottom: 1),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: chat.color,
              child: Text(
                chat.name.isNotEmpty ? chat.name[0] : 'U',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 6),
                chat.unread > 0
                    ? Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Color(0xFF25D366),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${chat.unread}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendDemoMessage() {
    final String message = _chatController.text.trim();
    if (message.isEmpty) {
      _showActionMessage('Type a message first');
      return;
    }

    if (_activeChatIndex < 0) {
      _showActionMessage('Open a chat first');
      return;
    }

    setState(() {
      _chatMessages[_activeChatIndex] ??= [];
      _chatMessages[_activeChatIndex]!.add(
        _ChatMessage(
          text: message,
          isMe: true,
          createdAt: DateTime.now(),
          status: 'delivered',
        ),
      );
      _demoChats[_activeChatIndex].lastMessage = message;
      _demoChats[_activeChatIndex].time = _currentTimeLabel();
    });
    _saveChatHistory();

    _chatController.clear();

    Future.delayed(Duration(milliseconds: 700), () {
      if (!mounted || _activeChatIndex < 0) return;
      setState(() {
        final List<_ChatMessage> chat = _chatMessages[_activeChatIndex]!;
        for (int i = chat.length - 1; i >= 0; i--) {
          if (chat[i].isMe) {
            chat[i].status = 'seen';
            break;
          }
        }
        _chatMessages[_activeChatIndex]!.add(
          _ChatMessage(
            text: 'Got it. I will reply soon.',
            isMe: false,
            createdAt: DateTime.now(),
          ),
        );
        _demoChats[_activeChatIndex].lastMessage = 'Got it. I will reply soon.';
        _demoChats[_activeChatIndex].time = _currentTimeLabel();
      });
      _saveChatHistory();
    });
  }

  String _currentTimeLabel() {
    return TimeOfDay.now().format(context);
  }

  String _formatMessageTime(DateTime time) {
    final TimeOfDay tod = TimeOfDay.fromDateTime(time);
    return tod.format(context);
  }

  Future<void> _loadChatHistory() async {
    final box = LocalDatabase.chatBox();
    final String? raw = box.get(_chatHistoryKey) as String?;
    if (raw == null || raw.isEmpty) return;

    try {
      final Map<String, dynamic> decoded = jsonDecode(raw);
      final Map<int, List<_ChatMessage>> loaded = {};

      decoded.forEach((key, value) {
        final int chatIndex = int.tryParse(key) ?? -1;
        if (chatIndex < 0 || value is! List) return;
        loaded[chatIndex] = value
            .whereType<Map>()
            .map((e) => _ChatMessage.fromMap(Map<String, dynamic>.from(e)))
            .toList();
      });

      if (!mounted) return;
      setState(() {
        _chatMessages = loaded.isNotEmpty ? loaded : _chatMessages;
        for (int i = 0; i < _demoChats.length; i++) {
          final List<_ChatMessage>? chat = _chatMessages[i];
          if (chat == null || chat.isEmpty) continue;
          final _ChatMessage last = chat.last;
          _demoChats[i].lastMessage = last.text;
          _demoChats[i].time = _formatMessageTime(last.createdAt);
        }
      });
    } catch (_) {
      // Keep default demo data if saved payload is malformed.
    }
  }

  Future<void> _saveChatHistory() async {
    final box = LocalDatabase.chatBox();
    final Map<String, dynamic> payload = {};
    _chatMessages.forEach((key, value) {
      payload[key.toString()] = value.map((m) => m.toMap()).toList();
    });
    await box.put(_chatHistoryKey, jsonEncode(payload));
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return GestureDetector(
      onTap: () => _showActionMessage('$title tapped'),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFE5E7EB)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF6366F1), size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreatePostPage() async {
    final String? createdPost = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => CreatePostScreen(vendorName: widget.vendorName),
      ),
    );

    if (!mounted || createdPost == null || createdPost.trim().isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post created: $createdPost'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await SessionStorage.clearSession();
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class _DemoChat {
  _DemoChat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.color,
  });

  final String name;
  String lastMessage;
  String time;
  int unread;
  final Color color;
}

class _ChatMessage {
  _ChatMessage({
    required this.text,
    required this.isMe,
    required this.createdAt,
    this.status = 'delivered',
  });

  factory _ChatMessage.fromMap(Map<String, dynamic> map) {
    return _ChatMessage(
      text: map['text'] as String? ?? '',
      isMe: map['isMe'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      status: map['status'] as String? ?? 'delivered',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isMe': isMe,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  final String text;
  final bool isMe;
  final DateTime createdAt;
  String status;
}

class _ExploreToolItem {
  _ExploreToolItem({
    required this.category,
    required this.title,
    required this.seller,
    required this.likes,
    required this.price,
    required this.icon,
    required this.colors,
  });

  final String category;
  final String title;
  final String seller;
  final String likes;
  final String price;
  final IconData icon;
  final List<Color> colors;
}
