import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> loginWithUsernamePassword(String username, String password);
  Future<AppUser?> registerWithUsernamePassword(String username, String password);
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
}
