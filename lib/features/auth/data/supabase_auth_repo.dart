import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/auth/domain/entities/repos/auth_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthRepo implements AuthRepo {
  final _client = Supabase.instance.client;

  static const _emailDomain = '@lacuna.app';
  String _toEmail(String username) => '$username$_emailDomain';
  String _toUsername(String email) => email.replaceAll(_emailDomain, '');

  @override
  Future<AppUser?> loginWithUsernamePassword(
      String username, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: _toEmail(username),
        password: password,
      );
      final user = response.user;
      if (user == null) return null;
      return AppUser(userId: user.id, username: username);
    } catch (_) {
      throw Exception('Incorrect username or password.');
    }
  }

  @override
  Future<AppUser?> registerWithUsernamePassword(
      String username, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: _toEmail(username),
        password: password,
        data: {'username': username},
      );
      final user = response.user;
      if (user == null) return null;
      // Profile row is created atomically by the on_auth_user_created trigger.
      return AppUser(userId: user.id, username: username);
    } on AuthException catch (e) {
      if (e.message.contains('already registered')) {
        throw Exception('That username is already taken.');
      }
      throw Exception('Registration failed. Please try again.');
    } catch (_) {
      throw Exception('Registration failed. Please try again.');
    }
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final username = user.userMetadata?['username'] as String? ??
        _toUsername(user.email ?? '');
    if (username.isEmpty) return null;
    return AppUser(userId: user.id, username: username);
  }
}
