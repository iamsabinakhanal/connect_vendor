import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const String _sessionLoggedInKey = 'auth_logged_in';
  static const String _sessionVendorNameKey = 'auth_session_vendor_name';
  static const String _sessionRoleKey = 'auth_session_role';

  static Future<void> saveSession({
    required String vendorName,
    String role = 'USER',
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_sessionLoggedInKey, true);
    await prefs.setString(_sessionVendorNameKey, vendorName.trim());
    await prefs.setString(_sessionRoleKey, role.trim().toUpperCase());
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_sessionLoggedInKey) ?? false;
  }

  static Future<String?> getSessionVendorName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionVendorNameKey);
  }

  static Future<String> getSessionRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionRoleKey) ?? 'USER';
  }

  static Future<void> clearSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionLoggedInKey);
    await prefs.remove(_sessionVendorNameKey);
    await prefs.remove(_sessionRoleKey);
  }
}
