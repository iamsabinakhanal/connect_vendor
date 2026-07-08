import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../auth/auth_storage.dart';
import '../../../auth/session_storage.dart';
import '../../../auth/login_screen.dart';
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
    _showActionMessage(context, 'Profile picture updated');
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

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF191B2A), Color(0xFF111320)],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 24),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xFF1E2235),
                border: Border.all(color: Color(0xFF2D3148)),
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
                            colors: [Color(0xFFFF5A66), Color(0xFFD7263D)],
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
                              color: Color(0xFFD7263D),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color(0xFF1E2235),
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
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Vendor Profile',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFAAB0C5),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF272B42),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'Active Seller',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFCA5A5),
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
            ProfileOption(
              icon: Icons.person_outline,
              title: 'Change Profile Picture',
              backgroundColor: Color(0xFF1E2235),
              borderColor: Color(0xFF2D3148),
              iconColor: Color(0xFFF97384),
              titleColor: Colors.white,
              trailingColor: Color(0xFF8E95AE),
              onTap: _pickProfileImage,
            ),
            if (_profileImagePath != null)
              ProfileOption(
                icon: Icons.delete_outline,
                title: 'Remove Profile Picture',
                backgroundColor: Color(0xFF1E2235),
                borderColor: Color(0xFF2D3148),
                iconColor: Color(0xFFF97384),
                titleColor: Colors.white,
                trailingColor: Color(0xFF8E95AE),
                onTap: _removeProfileImage,
              ),
            ProfileOption(
              icon: Icons.lock_outline,
              title: 'Change Password',
              backgroundColor: Color(0xFF1E2235),
              borderColor: Color(0xFF2D3148),
              iconColor: Color(0xFFF97384),
              titleColor: Colors.white,
              trailingColor: Color(0xFF8E95AE),
              onTap: () =>
                  _showActionMessage(context, 'Change Password tapped'),
            ),
            ProfileOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              backgroundColor: Color(0xFF1E2235),
              borderColor: Color(0xFF2D3148),
              iconColor: Color(0xFFF97384),
              titleColor: Colors.white,
              trailingColor: Color(0xFF8E95AE),
              onTap: () => _showActionMessage(context, 'Help & Support tapped'),
            ),
            ProfileOption(
              icon: Icons.security,
              title: 'Privacy Policy',
              backgroundColor: Color(0xFF1E2235),
              borderColor: Color(0xFF2D3148),
              iconColor: Color(0xFFF97384),
              titleColor: Colors.white,
              trailingColor: Color(0xFF8E95AE),
              onTap: () => _showActionMessage(context, 'Privacy Policy tapped'),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Color(0xFFD7263D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
