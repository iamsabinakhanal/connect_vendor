import '../core/utils/local_database.dart';

class AuthStorage {
  static const String _nameKey = 'auth_name';
  static const String _emailKey = 'auth_email';
  static const String _phoneKey = 'auth_phone';
  static const String _passwordKey = 'auth_password';
  static const String _profileImagePathKey = 'auth_profile_image_path';

  static Future<void> saveCredentials({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final box = LocalDatabase.authBox();
    await box.put(_nameKey, name.trim());
    await box.put(_emailKey, email.trim().toLowerCase());
    await box.put(_phoneKey, phone.trim());
    await box.put(_passwordKey, password);
  }

  static Future<bool> hasRegisteredUser() async {
    final box = LocalDatabase.authBox();
    return box.containsKey(_emailKey) && box.containsKey(_passwordKey);
  }

  static Future<String?> getRegisteredName() async {
    final box = LocalDatabase.authBox();
    return box.get(_nameKey) as String?;
  }

  static Future<bool> validateLogin({
    required String email,
    required String password,
  }) async {
    final box = LocalDatabase.authBox();
    final String? savedEmail = box.get(_emailKey) as String?;
    final String? savedPassword = box.get(_passwordKey) as String?;
    if (savedEmail == null || savedPassword == null) {
      return false;
    }

    return savedEmail == email.trim().toLowerCase() &&
        savedPassword == password;
  }

  static Future<void> saveProfileImagePath(String path) async {
    final box = LocalDatabase.authBox();
    await box.put(_profileImagePathKey, path.trim());
  }

  static Future<String?> getProfileImagePath() async {
    final box = LocalDatabase.authBox();
    final String? value = box.get(_profileImagePathKey) as String?;
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return value;
  }

  static Future<void> clearProfileImagePath() async {
    final box = LocalDatabase.authBox();
    await box.delete(_profileImagePathKey);
  }
}
