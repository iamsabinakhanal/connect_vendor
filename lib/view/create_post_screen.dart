import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../app/theme/app_theme.dart';

class CreatePostScreen extends StatefulWidget {
  final String vendorName;

  const CreatePostScreen({super.key, required this.vendorName});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final ImagePicker _imagePicker;
  final List<XFile> _selectedImages = <XFile>[];
  String _selectedCommunity = 'Public';
  String _selectedCategory = 'Electronics';

  static const List<String> _communityOptions = [
    'Public',
    'Sunshine',
    'Relife',
    '2UUL',
    'Quick',
  ];

  static const List<String> _categoryOptions = [
    'Electronics',
    'Accessories',
    'Services',
    'Repair Parts',
    'Software',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Create Post',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF272B42),
                      ),
                      child: Center(
                        child: Text(
                          widget.vendorName.isNotEmpty
                              ? widget.vendorName[0].toUpperCase()
                              : 'V',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primarySoft,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vendorName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceAlt,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  _selectedCommunity,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                onPressed: _pickCommunity,
                                icon: const Icon(Icons.group_add, size: 18),
                                label: const Text('Add to Community'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.primarySoft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Title Field
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Product Title *',
                  hintText: 'Enter product name',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                  hintStyle: TextStyle(color: AppTheme.textSecondary),
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppTheme.border),
                  ),
                ),
                style: TextStyle(fontSize: 14, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 12),
              // Category Picker
              GestureDetector(
                onTap: _pickCategory,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCategory,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: AppTheme.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Description Field
              Container(
                height: 200,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Product details, features, condition, etc.',
                    hintStyle: TextStyle(color: AppTheme.textSecondary),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              if (_selectedImages.isNotEmpty) ...[
                const SizedBox(height: 14),
                Text(
                  'Selected Images (${_selectedImages.length})',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 88,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final XFile image = _selectedImages[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(image.path),
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(2),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildPostActionIcon(
                      Icons.camera_alt_outlined,
                      'Camera',
                      onTap: _captureImage,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPostActionIcon(
                      Icons.image_outlined,
                      'Gallery',
                      onTap: _pickImages,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPostActionIcon(
                      Icons.group_add_outlined,
                      'Community',
                      onTap: _pickCommunity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostActionIcon(
    IconData icon,
    String label, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceAlt,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primarySoft, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages() async {
    final List<XFile> picked = await _imagePicker.pickMultiImage(
      imageQuality: 80,
    );

    if (!mounted || picked.isEmpty) {
      return;
    }

    setState(() {
      _selectedImages.addAll(picked);
    });
  }

  Future<void> _captureImage() async {
    final XFile? captured = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (!mounted || captured == null) {
      return;
    }

    setState(() {
      _selectedImages.add(captured);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image captured successfully'),
        duration: Duration(milliseconds: 800),
      ),
    );
  }

  void _removeImage(int index) {
    if (index < 0 || index >= _selectedImages.length) {
      return;
    }

    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _pickCommunity() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add to Community',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ..._communityOptions.map((community) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.groups, color: AppTheme.primarySoft),
                  title: Text(community),
                  trailing: _selectedCommunity == community
                      ? Icon(Icons.check_circle, color: AppTheme.primarySoft)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCommunity = community;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text('Added to $community'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _submitPost() {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a product title.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    if (description.isEmpty && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add a description or at least one image before posting.'),
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }

    Navigator.of(context).pop({
      'title': title,
      'text': description,
      'category': _selectedCategory,
      'community': _selectedCommunity,
      'imagePaths': _selectedImages.map((x) => x.path).toList(),
    });
  }

  void _pickCategory() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Category',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ..._categoryOptions.map((category) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.category, color: AppTheme.primarySoft),
                  title: Text(category),
                  trailing: _selectedCategory == category
                      ? Icon(Icons.check_circle, color: AppTheme.primarySoft)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
