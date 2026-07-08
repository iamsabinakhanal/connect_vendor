export '../core/network/api_client.dart';

import '../core/network/api_client.dart';

class AuthUser {
  AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.role,
  });

  factory AuthUser.fromMap(Map<String, dynamic> map) {
    return AuthUser(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      phone: map['phone']?.toString() ?? '',
      businessName: map['businessName']?.toString() ?? '',
      role: map['role']?.toString() ?? 'USER',
    );
  }

  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String role;
}

class AuthApiService {
  AuthApiService({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  void close() {
    _client.close();
  }

  Future<AuthUser> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final Map<String, dynamic> data = await _client.postJson('/auth/register', {
      'name': name,
      'email': email,
      'phone': phone,
      'businessName': name,
      'password': password,
    });

    return AuthUser.fromMap(data);
  }

  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> data = await _client.postJson('/auth/login', {
      'email': email,
      'password': password,
    });

    return AuthUser.fromMap(data);
  }
}
