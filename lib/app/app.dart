import 'package:first_flutter_app/features/auth/data/mock_auth_repo.dart';
import 'package:first_flutter_app/features/auth/data/supabase_auth_repo.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:first_flutter_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:first_flutter_app/features/auth/presentation/pages/login_page.dart';
import 'package:first_flutter_app/features/auth/presentation/pages/splash_page.dart';
import 'package:first_flutter_app/features/home/presentation/pages/app_shell_page.dart';
import 'package:first_flutter_app/shared/theme/app_theme.dart';
import 'package:first_flutter_app/shared/theme/lacuna_theme.dart';
import 'package:first_flutter_app/shared/theme/lacuna_theme_provider.dart';
import 'package:first_flutter_app/shared/theme/theme_variants.dart';
import 'package:first_flutter_app/shared/widgets/themed_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LacunaApp extends StatelessWidget {
  const LacunaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LacunaThemeVariant>(
      valueListenable: lacunaThemeNotifier,
      builder: (_, variant, _) {
        final theme = themeFor(variant);
        final mode = theme.palette.brightness == Brightness.light
            ? ThemeMode.light
            : ThemeMode.dark;
        final materialTheme = AppTheme.fromVariant();
        return LacunaThemeScope(
          theme: theme,
          child: BlocProvider(
            create: (_) =>
                AuthCubit(authRepo: kDebugMode ? MockAuthRepo() : SupabaseAuthRepo())
                  ..checkAuth(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Lacuna',
              theme: materialTheme,
              darkTheme: materialTheme,
              themeMode: mode,
              home: const _AuthGate(),
              builder: (context, child) => Stack(
                children: [
                  const Positioned.fill(child: ThemedBackground()),
                  ?child,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      // The BlocBuilder listens to the AuthCubit and rebuilds the UI based on the current authentication state.
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
