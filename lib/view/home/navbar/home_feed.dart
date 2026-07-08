import 'package:flutter/material.dart';
import '../../create_post_screen.dart';

class HomeFeed extends StatefulWidget {
  final String vendorName;

  const HomeFeed({super.key, required this.vendorName});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed> {
  @override
  Widget build(BuildContext context) {
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
}
