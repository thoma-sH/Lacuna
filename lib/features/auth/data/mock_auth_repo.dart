import 'dart:async';

import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/auth/domain/entities/repos/auth_repo.dart';

class MockAuthRepo implements AuthRepo {
  static final Map<String, _MockAccount> _accountsByUsername = {};

  static AppUser? _currentUser;

  @override
  Future<AppUser?> getCurrentUser() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<AppUser?> loginWithUsernamePassword(
      String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final account = _accountsByUsername[username.trim().toLowerCase()];
    if (account == null || account.password != password) {
      throw Exception('Incorrect username or password.');
    }
    _currentUser = account.user;
    return _currentUser;
  }

  @override
  Future<AppUser?> registerWithUsernamePassword(
      String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final normalized = username.trim().toLowerCase();
    if (_accountsByUsername.containsKey(normalized)) {
      throw Exception('That username is already taken.');
    }
    final user = AppUser(
      userId: 'u_${DateTime.now().millisecondsSinceEpoch}',
      username: normalized,
    );
    _accountsByUsername[normalized] = _MockAccount(user: user, password: password);
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
