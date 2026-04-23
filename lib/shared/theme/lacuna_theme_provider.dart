import 'package:first_flutter_app/shared/theme/lacuna_theme.dart';
import 'package:first_flutter_app/shared/theme/theme_variants.dart';
import 'package:flutter/material.dart';

final ValueNotifier<LacunaThemeVariant> lacunaThemeNotifier =
    ValueNotifier<LacunaThemeVariant>(LacunaThemeVariant.calm);

LacunaTheme get currentLacunaTheme => themeFor(lacunaThemeNotifier.value);

class LacunaThemeScope extends InheritedWidget {
  const LacunaThemeScope({
    required this.theme,
    required super.child,
    super.key,
  });

  final LacunaTheme theme;

  static LacunaTheme of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<LacunaThemeScope>();
    return scope?.theme ?? currentLacunaTheme;
  }

  @override
  bool updateShouldNotify(LacunaThemeScope old) =>
      old.theme.variant != theme.variant;
}
