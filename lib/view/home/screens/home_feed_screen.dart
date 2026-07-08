import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/local_database.dart';
import '../../create_post_screen.dart';
import '../models/feed_post.dart';
import 'post_detail_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  final String vendorName;

  const HomeFeedScreen({super.key, required this.vendorName});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  static const String _feedPostsKey = 'home_feed_posts_v1';
  late List<FeedPost> _feedPosts;

  static const List<Color> _mediaColors = [
    Color(0xFF818CF8),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEC4899),
    Color(0xFF3B82F6),
    Color(0xFFF97316),
  ];

  @override
  void initState() {
    super.initState();
    _feedPosts = _seedFeedPosts();
    _loadFeedPosts();
  }

  List<FeedPost> _seedFeedPosts() {
    return [
      FeedPost(
        id: 'post-1',
        vendorName: 'TechVendor Pro',
        vendorInitial: 'T',
        communityName: 'Sunshine',
        title: 'Premium Laptop Stand',
        description:
            'Ergonomic aluminum laptop stand perfect for work from home setup. Adjustable height and angle for maximum comfort.',
        mediaIcons: [
          Icons.laptop,
          Icons.desktop_windows,
          Icons.chair,
          Icons.workspace_premium,
          Icons.lightbulb,
        ],
        likes: 234,
        comments: 45,
        shares: 12,
        isLiked: false,
        isSaved: false,
        commentsList: [
          'Looks premium and practical.',
          'Is this available in bulk?',
        ],
        timeAgo: '2 hours ago',
      ),
      FeedPost(
        id: 'post-2',
        vendorName: 'Quality Electronics',
        vendorInitial: 'Q',
        communityName: 'Relife',
        title: 'USB-C Hub Adapter',
        description:
            'Multi-port USB-C hub with HDMI, USB 3.0, and SD card reader. Perfect for MacBook and Windows laptops.',
        mediaIcons: [Icons.router, Icons.cable, Icons.memory],
        likes: 567,
        comments: 89,
        shares: 34,
        isLiked: true,
        isSaved: false,
        commentsList: ['Good option for laptop users.'],
        timeAgo: '4 hours ago',
      ),
      FeedPost(
        id: 'post-3',
        vendorName: 'Office Solutions',
        vendorInitial: 'O',
        communityName: '2UUL',
        title: 'Mechanical Keyboard RGB',
        description:
            'Premium mechanical keyboard with customizable RGB lighting. Perfect for gaming and professional work.',
        mediaIcons: [Icons.keyboard, Icons.games],
        likes: 892,
        comments: 156,
        shares: 78,
        isLiked: false,
        isSaved: false,
        commentsList: ['Nice keyboard layout.'],
        timeAgo: '6 hours ago',
      ),
      FeedPost(
        id: 'post-4',
        vendorName: 'Digital Accessories',
        vendorInitial: 'D',
        communityName: 'Quick',
        title: 'Wireless Mouse Pro',
        description:
            'Precision wireless mouse with ergonomic design. 12-month battery life and advanced tracking technology.',
        mediaIcons: [Icons.touch_app],
        likes: 445,
        comments: 67,
        shares: 45,
        isLiked: false,
        isSaved: false,
        commentsList: [],
        timeAgo: '9 hours ago',
      ),
    ];
  }

  Future<void> _loadFeedPosts() async {
    final box = LocalDatabase.feedBox();
    final dynamic raw = box.get(_feedPostsKey);
    if (raw is! List || raw.isEmpty) {
      return;
    }

    try {
      final List<FeedPost> loaded = raw
          .whereType<Map>()
          .map((item) => FeedPost.fromMap(Map<String, dynamic>.from(item)))
          .toList();

      if (!mounted || loaded.isEmpty) {
        return;
      }

      setState(() {
        _feedPosts = loaded;
      });
    } catch (_) {
      // Keep seeded feed if stored payload is invalid.
    }
  }

  Future<void> _saveFeedPosts() async {
    final box = LocalDatabase.feedBox();
    final List<Map<String, dynamic>> payload = _feedPosts
        .map((post) => post.toMap())
        .toList();
    await box.put(_feedPostsKey, payload);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCreatePostComposer(),
          ..._feedPosts.map(_buildFeedPost),
        ],
      ),
    );
  }

  Widget _buildCreatePostComposer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      color: AppTheme.surface,
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
                    color: AppTheme.surfaceAlt,
                  ),
                  child: Center(
                    child: Text(
                      widget.vendorName.isNotEmpty
                          ? widget.vendorName[0].toUpperCase()
                          : 'V',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primarySoft,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _openCreatePostPage,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceAlt,
                        borderRadius: BorderRadius.circular(26),
                      ),
                      child: Text(
                        "What's on your mind, ${widget.vendorName}?",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: AppTheme.border),
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
                Container(width: 1, height: 20, color: AppTheme.border),
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

  Widget _buildFeedPost(FeedPost post) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.border, width: 1)),
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
                    color: AppTheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      post.vendorInitial,
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
                        post.vendorName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        post.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceAlt,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          post.communityName,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.primarySoft,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _toggleSave(post.id),
                  child: Icon(
                    post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: post.isSaved
                        ? AppTheme.primarySoft
                        : AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () =>
                      _showActionMessage('More options for ${post.vendorName}'),
                  child: Icon(
                    Icons.more_horiz,
                    color: AppTheme.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _openPostDetail(post),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        post.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildPostMediaGrid(post),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${post.likes} Likes',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                Text(
                  '${post.comments} Comments • ${post.shares} Shares',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
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
                    icon: post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    label: 'Like',
                    color: post.isLiked ? AppTheme.primary : AppTheme.textSecondary,
                    onTap: () => _toggleLike(post.id),
                  ),
                ),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: 'Comment',
                    color: AppTheme.textSecondary,
                    onTap: () => _addComment(post.id),
                  ),
                ),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.share_outlined,
                    label: 'Share',
                    color: AppTheme.textSecondary,
                    onTap: () => _sharePost(post.id),
                  ),
                ),
                Expanded(
                  child: _buildActionButton(
                    icon: post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    label: 'Save',
                    color: post.isSaved
                        ? AppTheme.primarySoft
                        : AppTheme.textSecondary,
                    onTap: () => _toggleSave(post.id),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostMediaGrid(FeedPost post) {
    final int total = post.mediaIcons.length;
    if (total == 0) {
      return SizedBox.shrink();
    }

    Widget tile(int index, {bool showOverlay = false}) {
      final int remaining = total - 4;

      return GestureDetector(
        onTap: () => _openPostDetail(post, initialPage: index),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildMediaTile(post.mediaIcons[index], index),
            if (showOverlay && remaining > 0)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    if (total == 1) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 240,
        child: tile(0),
      );
    }

    if (total == 2) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 220,
        child: Row(
          children: [
            Expanded(child: tile(0)),
            SizedBox(width: 4),
            Expanded(child: tile(1)),
          ],
        ),
      );
    }

    if (total == 3) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.symmetric(horizontal: 12),
        height: 240,
        child: Row(
          children: [
            Expanded(flex: 2, child: tile(0)),
            SizedBox(width: 4),
            Expanded(
              child: Column(
                children: [
                  Expanded(child: tile(1)),
                  SizedBox(height: 4),
                  Expanded(child: tile(2)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      height: 240,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: tile(0)),
                SizedBox(width: 4),
                Expanded(child: tile(1)),
              ],
            ),
          ),
          SizedBox(height: 4),
          Expanded(
            child: Row(
              children: [
                Expanded(child: tile(2)),
                SizedBox(width: 4),
                Expanded(child: tile(3, showOverlay: total > 4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaTile(IconData icon, int colorIndex) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          colors: [
            _mediaColors[colorIndex % _mediaColors.length],
            Color(0xFF111827),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(child: Icon(icon, size: 56, color: Colors.white)),
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

  Future<void> _openCreatePostPage() async {
    final dynamic createdPost = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (context) => CreatePostScreen(vendorName: widget.vendorName),
      ),
    );

    final String createdText;
    final String createdCommunity;

    if (createdPost is String) {
      createdText = createdPost.trim();
      createdCommunity = 'Public';
    } else if (createdPost is Map) {
      createdText = (createdPost['text']?.toString() ?? '').trim();
      createdCommunity = (createdPost['community']?.toString() ?? 'Public')
          .trim();
    } else {
      return;
    }

    if (!mounted || createdText.isEmpty) {
      return;
    }

    setState(() {
      _feedPosts.insert(
        0,
        FeedPost(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          vendorName: widget.vendorName,
          vendorInitial: widget.vendorName.isNotEmpty
              ? widget.vendorName[0].toUpperCase()
              : 'V',
          communityName: createdCommunity.isEmpty ? 'Public' : createdCommunity,
          title: 'New Post',
          description: createdText,
          mediaIcons: [],
          likes: 0,
          comments: 0,
          shares: 0,
          isLiked: false,
          isSaved: false,
          commentsList: [],
          timeAgo: 'Just now',
        ),
      );
    });
    _saveFeedPosts();
  }

  void _openPostDetail(FeedPost post, {int initialPage = 0}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PostDetailScreen(post: post, initialPage: initialPage),
      ),
    );
  }

  void _toggleLike(String postId) {
    final int postIndex = _feedPosts.indexWhere((post) => post.id == postId);
    if (postIndex < 0) {
      return;
    }

    final FeedPost post = _feedPosts[postIndex];
    final bool nextLiked = !post.isLiked;

    setState(() {
      _feedPosts[postIndex] = post.copyWith(
        isLiked: nextLiked,
        likes: nextLiked
            ? post.likes + 1
            : (post.likes > 0 ? post.likes - 1 : 0),
      );
    });
    _saveFeedPosts();
  }

  Future<void> _addComment(String postId) async {
    final int postIndex = _feedPosts.indexWhere((post) => post.id == postId);
    if (postIndex < 0) {
      return;
    }

    final TextEditingController commentController = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            final FeedPost post = _feedPosts[postIndex];

            void submitComment() {
              final String comment = commentController.text.trim();
              if (comment.isEmpty) {
                return;
              }

              setState(() {
                final FeedPost latestPost = _feedPosts[postIndex];
                _feedPosts[postIndex] = latestPost.copyWith(
                  comments: latestPost.comments + 1,
                  commentsList: [...latestPost.commentsList, comment],
                );
              });

              commentController.clear();
              sheetSetState(() {});
              _saveFeedPosts();
            }

            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
                ),
                child: SizedBox(
                  height: MediaQuery.of(sheetContext).size.height * 0.76,
                  child: Column(
                    children: [
                      Container(
                        width: 44,
                        height: 5,
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Comments',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${post.comments} total',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      Expanded(
                        child: post.commentsList.isEmpty
                            ? const Center(
                                child: Text(
                                  'No comments yet. Start the conversation.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  12,
                                  12,
                                  12,
                                ),
                                itemCount: post.commentsList.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final String comment =
                                      post.commentsList[index];

                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.surfaceAlt,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            post.vendorInitial,
                                            style: const TextStyle(
                                              color: AppTheme.primarySoft,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: AppTheme.surfaceAlt,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                post.vendorName,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppTheme.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                comment,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppTheme.textPrimary,
                                                  height: 1.35,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      const Divider(height: 1, thickness: 1),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: commentController,
                                autofocus: true,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => submitComment(),
                                decoration: InputDecoration(
                                  hintText: 'Write a comment...',
                                  filled: true,
                                  fillColor: AppTheme.surfaceAlt,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(24),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: submitComment,
                              icon: const Icon(
                                Icons.send_rounded,
                                color: AppTheme.primarySoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    commentController.dispose();
  }

  void _sharePost(String postId) {
    final int postIndex = _feedPosts.indexWhere((post) => post.id == postId);
    if (postIndex < 0) {
      return;
    }

    setState(() {
      final FeedPost post = _feedPosts[postIndex];
      _feedPosts[postIndex] = post.copyWith(shares: post.shares + 1);
    });
    _saveFeedPosts();

    _showActionMessage('Post shared');
  }

  void _toggleSave(String postId) {
    final int postIndex = _feedPosts.indexWhere((post) => post.id == postId);
    if (postIndex < 0) {
      return;
    }

    final FeedPost post = _feedPosts[postIndex];
    final bool nextSaved = !post.isSaved;

    setState(() {
      _feedPosts[postIndex] = post.copyWith(isSaved: nextSaved);
    });
    _saveFeedPosts();

    _showActionMessage(nextSaved ? 'Post saved' : 'Post unsaved');
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }
}
