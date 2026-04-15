import 'dart:async';

import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/auth/domain/entities/repos/auth_repo.dart';

class MockAuthRepo implements AuthRepo {
  static final Map<String, _MockAccount> _accountsByUsername = {
    'demo': _MockAccount(
      user: AppUser(userId: 'u_demo', username: 'demo'),
      password: 'password123',
    ),
  };

  static AppUser? _currentUser;

  @override
  Future<AppUser?> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final username = email.trim().toLowerCase();
    final account = _accountsByUsername[username];
    if (account == null || account.password != password) {
      throw Exception('Invalid username or password');
    }
    _currentUser = account.user;
    return _currentUser;
  }

  @override
  Future<AppUser?> registerWithEmailPassword(
    String name,
    String email,
    String password,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final username = name.trim().toLowerCase();
    if (username.isEmpty) {
      throw Exception('Username is required');
    }
    if (_accountsByUsername.containsKey(username)) {
      throw Exception('Username already exists');
    }
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters');
    }

    final user = AppUser(
      userId: 'u_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
    );
    _accountsByUsername[username] = _MockAccount(user: user, password: password);
    _currentUser = user;
    return user;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _currentUser = null;
  }
}

class _MockAccount {
  const _MockAccount({required this.user, required this.password});

  final AppUser user;
  final String password;
}
