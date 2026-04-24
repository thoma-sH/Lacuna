import 'package:first_flutter_app/features/auth/domain/entities/app_user.dart';
import 'package:first_flutter_app/features/auth/domain/entities/repos/auth_repo.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  void checkAuth() async {
    final user = await authRepo.getCurrentUser();
    emit(user != null ? Authenticated(user) : Unauthenticated());
  }

  Future<void> login(String username, String pw) =>
      _handleAuthResult(() => authRepo.loginWithUsernamePassword(username, pw));

  Future<void> register(String username, String pw) =>
      _handleAuthResult(() => authRepo.registerWithUsernamePassword(username, pw));

  Future<void> logout() async {
    await authRepo.logout();
    emit(Unauthenticated());
  }

  Future<void> _handleAuthResult(Future<AppUser?> Function() action) async {
    try {
      emit(AuthLoading());
      final user = await action();
      emit(user != null ? Authenticated(user) : Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
      emit(Unauthenticated());
    }
  }
}
