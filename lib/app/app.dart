import 'package:first_flutter_app/features/auth/data/mock_auth_repo.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:first_flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:first_flutter_app/features/auth/presentation/pages/splash_page.dart';
import 'package:first_flutter_app/features/home/presentation/pages/app_shell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlobApp extends StatelessWidget {
  const BlobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(authRepo: MockAuthRepo())..checkAuth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lacuna',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return AppShellPage(user: state.user);
        }
        if (state is AuthLoading || state is AuthInitial) {
          return const SplashPage();
        }
        return const LoginPage();
      },
    );
  }
}
