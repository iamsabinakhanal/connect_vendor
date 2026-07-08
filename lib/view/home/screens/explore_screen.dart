import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../models/community_post.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    'All',
    'Sunshine',
    'Relife',
    '2UUL',
    'Quick',
  ];

  final List<CommunityPost> _posts = [
    CommunityPost(
      id: 1,
      category: 'Sunshine',
      categoryIcon: Icons.lightbulb,
      title: 'Sunshine Soldering Station — bulk stock available',
      description:
          'High-grade soldering stations with stable heat control and fast delivery. Ideal for repair shops looking for dependable daily-use tools...',
      image: Icons.handyman,
      views: '58K',
      likes: 623,
      comments: 91,
      communityName: 'Sunshine',
      communityInitial: 'S',
      communityColor: Color(0xFF6B7280),
    ),
    CommunityPost(
      id: 2,
      category: 'Relife',
      categoryIcon: Icons.build_circle,
      title: 'Relife multimeter and power supply tools in stock',
      description:
          'Reliable diagnostic tools for mobile repair vendors. Great pricing on DC power supplies, testers, and measurement accessories...',
      image: Icons.settings,
      views: '49K',
      likes: 521,
      comments: 78,
      communityName: 'Relife',
      communityInitial: 'R',
      communityColor: Color(0xFF6B7280),
    ),
    CommunityPost(
      id: 3,
      category: '2UUL',
      categoryIcon: Icons.precision_manufacturing,
      title: '2UUL pry tools and repair kits for technicians',
      description:
          'Compact kits for screen replacement, opening tools, and precision repair work. Built for vendors who sell practical service tools...',
      image: Icons.build,
      views: '41K',
      likes: 445,
      comments: 63,
      communityName: '2UUL',
      communityInitial: '2',
      communityColor: Color(0xFF6B7280),
    ),
    CommunityPost(
      id: 4,
      category: 'Quick',
      categoryIcon: Icons.flash_on,
      title: 'Quick heat tools and accessory packs ready to ship',
      description:
          'Fast-moving inventory for repair shops that need dependable heat guns, soldering accessories, and everyday quick-sale tools...',
      image: Icons.electrical_services,
      views: '35K',
      likes: 389,
      comments: 52,
      communityName: 'Quick',
      communityInitial: 'Q',
      communityColor: Color(0xFF6B7280),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;
    final isWide = screenWidth >= 1000;
    final headerHeight = isCompact ? 190.0 : 220.0;

    final List<CommunityPost> filteredPosts = _selectedCategoryIndex == 0
        ? _posts
        : _posts
              .where(
                (post) => post.category == _categories[_selectedCategoryIndex],
              )
              .toList();

    if (filteredPosts.isEmpty) {
      return Center(child: Text('No posts found in this category'));
    }

    return Container(
      color: AppTheme.background,
      child: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            backgroundColor: AppTheme.surface,
            elevation: 0,
            floating: true,
            pinned: true,
            expandedHeight: headerHeight,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppTheme.surface,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      isCompact ? 12 : 16,
                      16,
                      12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explore Communities',
                          style: TextStyle(
                            fontSize: isCompact ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: isCompact ? 2 : 4),
                        Text(
                          'Discover brand communities for mobile repair vendors.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isCompact ? 12 : 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        SizedBox(height: isCompact ? 8 : 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceAlt,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search communities...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppTheme.textSecondary,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: isCompact ? 10 : 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Category Tabs
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.surface,
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    color: AppTheme.textSecondary,
                    iconSize: 24,
                    onPressed: () => _showActionMessage('Scroll left'),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_categories.length, (index) {
                          final isSelected = index == _selectedCategoryIndex;
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategoryIndex = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                    ? AppTheme.surfaceAlt
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected
                                      ? null
                                    : Border.all(color: AppTheme.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (index == 0)
                                      Icon(
                                        Icons.all_inbox,
                                        size: 14,
                                        color: AppTheme.textSecondary,
                                      )
                                    else
                                      SizedBox.shrink(),
                                    if (index == 0) SizedBox(width: 6),
                                    Text(
                                      _categories[index],
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    color: AppTheme.textSecondary,
                    iconSize: 24,
                    onPressed: () => _showActionMessage('Scroll right'),
                  ),
                ],
              ),
            ),
          ),
          // Trending Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Icon(Icons.trending_up, size: 20, color: AppTheme.primarySoft),
                  SizedBox(width: 8),
                  Text(
                    'Trending Posts',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Posts Section
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              isCompact ? 12 : 16,
              0,
              isCompact ? 12 : 16,
              20,
            ),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isCompact ? 1 : (isWide ? 3 : 2),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isCompact ? 0.78 : 0.84,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildCommunityPostCard(filteredPosts[index]),
                childCount: filteredPosts.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildCommunityPostCard(CommunityPost post) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section with Badges
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: isCompact ? 150 : 170,
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceAlt,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: Icon(
                    post.image,
                    size: 60,
                    color: AppTheme.primarySoft,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.visibility,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        post.views,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    post.communityInitial,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(isCompact ? 10 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: isCompact ? 30 : 32,
                            height: isCompact ? 30 : 32,
                            decoration: BoxDecoration(
                              color: post.communityColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                post.communityInitial,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              post.communityName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () =>
                          _showActionMessage('Joined ${post.communityName}'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add, size: 14, color: Colors.white),
                            SizedBox(width: 2),
                            Text(
                              'Join',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 13.5 : 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  post.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 11.5 : 12,
                    color: AppTheme.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildEngagementStat(Icons.favorite, '${post.likes}'),
                      const SizedBox(width: 8),
                      _buildEngagementStat(
                        Icons.chat_bubble,
                        '${post.comments}',
                      ),
                      const SizedBox(width: 8),
                      _buildEngagementStat(Icons.visibility, post.views),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showActionMessage('Shared ${post.title}'),
                        child: const Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementStat(IconData icon, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        SizedBox(width: 4),
        Text(
          count,
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }
}
