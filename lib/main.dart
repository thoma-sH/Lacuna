import 'package:first_flutter_app/app/app.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final sentryDsn = dotenv.env['SENTRY_DSN'];
  if (sentryDsn == null || sentryDsn.isEmpty) {
    runApp(const BlobApp());
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = sentryDsn;
      options.tracesSampleRate = kReleaseMode ? 0.2 : 1.0;
      options.profilesSampleRate = kReleaseMode ? 0.2 : 1.0;
      options.environment = kReleaseMode ? 'production' : 'development';
      options.sendDefaultPii = false;
      options.attachScreenshot = false;
    },
    appRunner: () => runApp(SentryWidget(child: const BlobApp())),
  );
}
