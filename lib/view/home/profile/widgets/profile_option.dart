import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color titleColor;
  final Color trailingColor;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.backgroundColor = AppTheme.surface,
    this.borderColor = AppTheme.border,
    this.iconColor = AppTheme.primarySoft,
    this.titleColor = AppTheme.textPrimary,
    this.trailingColor = AppTheme.textSecondary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        color: backgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 22),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: trailingColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
