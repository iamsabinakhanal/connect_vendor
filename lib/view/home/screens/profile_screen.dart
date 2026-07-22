import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../auth/auth_storage.dart';
import '../../../auth/session_storage.dart';
import '../../../auth/login_screen.dart';
import '../../../app/theme/app_theme.dart';
import '../widgets/profile_option.dart';

class ProfileScreen extends StatefulWidget {
  final String vendorName;
  final VoidCallback? onProfileUpdated;

  const ProfileScreen({
    super.key,
    required this.vendorName,
    this.onProfileUpdated,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final String? path = await AuthStorage.getProfileImagePath();
    if (!mounted) {
      return;
    }
    setState(() {
      _profileImagePath = path;
    });
  }

  Future<void> _pickProfileImage() async {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Color(0xFF1E2235),
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
                'Upload Profile Picture',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.camera_alt, color: Color(0xFFD7263D)),
                title: Text(
                  'Take Photo',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _captureProfileImage();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.image, color: Color(0xFFD7263D)),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _selectProfileImageFromGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _captureProfileImage() async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (picked == null || !mounted) {
      return;
    }

    await AuthStorage.saveProfileImagePath(picked.path);
    if (!mounted) {
      return;
    }
    setState(() {
      _profileImagePath = picked.path;
    });
    widget.onProfileUpdated?.call();
    _showActionMessage(context, 'Profile picture updated from camera');
  }

  Future<void> _selectProfileImageFromGallery() async {
    final XFile? picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null || !mounted) {
      return;
    }

    await AuthStorage.saveProfileImagePath(picked.path);
    if (!mounted) {
      return;
    }
    setState(() {
      _profileImagePath = picked.path;
    });
    widget.onProfileUpdated?.call();
    _showActionMessage(context, 'Profile picture updated from gallery');
  }

  Future<void> _removeProfileImage() async {
    await AuthStorage.clearProfileImagePath();
    if (!mounted) {
      return;
    }
    setState(() {
      _profileImagePath = null;
    });
    widget.onProfileUpdated?.call();
    _showActionMessage(context, 'Profile picture removed');
  }

  @override
  Widget build(BuildContext context) {
    final String initials = widget.vendorName.isNotEmpty
        ? widget.vendorName.trim().substring(0, 1).toUpperCase()
        : 'V';

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppTheme.primarySoft, AppTheme.primary],
                            ),
                          ),
                          child: ClipOval(
                            child: _profileImagePath != null
                                ? Image.file(
                                    File(_profileImagePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => Center(
                                      child: Text(
                                        initials,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: AppTheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.surface,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vendorName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Vendor Account',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primarySoft.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: AppTheme.primarySoft.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              'Active',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primarySoft,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18),
              // Stats Row
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('28', 'Posts'),
                    _buildStatCard('1.2K', 'Followers'),
                    _buildStatCard('345', 'Following'),
                  ],
                ),
              ),
              SizedBox(height: 18),
            ProfileOption(
              icon: Icons.person_outline,
              title: 'Change Profile Picture',
              backgroundColor: AppTheme.surface,
              borderColor: AppTheme.border,
              iconColor: AppTheme.primarySoft,
              titleColor: AppTheme.textPrimary,
              trailingColor: AppTheme.textSecondary,
              onTap: _pickProfileImage,
            ),
            if (_profileImagePath != null)
              ProfileOption(
                icon: Icons.delete_outline,
                title: 'Remove Profile Picture',
                backgroundColor: AppTheme.surface,
                borderColor: AppTheme.border,
                iconColor: AppTheme.primarySoft,
                titleColor: AppTheme.textPrimary,
                trailingColor: AppTheme.textSecondary,
                onTap: _removeProfileImage,
              ),
            ProfileOption(
              icon: Icons.lock_outline,
              title: 'Change Password',
              backgroundColor: AppTheme.surface,
              borderColor: AppTheme.border,
              iconColor: AppTheme.primarySoft,
              titleColor: AppTheme.textPrimary,
              trailingColor: AppTheme.textSecondary,
              onTap: () =>
                  _showActionMessage(context, 'Change Password tapped'),
            ),
            ProfileOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              backgroundColor: AppTheme.surface,
              borderColor: AppTheme.border,
              iconColor: AppTheme.primarySoft,
              titleColor: AppTheme.textPrimary,
              trailingColor: AppTheme.textSecondary,
              onTap: () => _showActionMessage(context, 'Help & Support tapped'),
            ),
            ProfileOption(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              backgroundColor: AppTheme.surface,
              borderColor: AppTheme.border,
              iconColor: AppTheme.primarySoft,
              titleColor: AppTheme.textPrimary,
              trailingColor: AppTheme.textSecondary,
              onTap: () => _showActionMessage(context, 'Privacy Policy tapped'),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Logout',
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
    );
  }

  void _showActionMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await SessionStorage.clearSession();
                await AuthStorage.clearProfileImagePath();
                if (!context.mounted) {
                  return;
                }
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
