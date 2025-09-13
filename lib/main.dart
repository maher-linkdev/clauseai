import 'package:deal_insights_assistant/firebase_options.dart';
import 'package:deal_insights_assistant/src/app_root.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

late ProviderContainer container;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Firebase App Check for security
  // await FirebaseAppCheck.instance.activate(
  //   webProvider: kIsWeb ? ReCaptchaV3Provider('linkdevelopment') : null,
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.debug,
  // );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  container = ProviderContainer(
    overrides: [
      // tangentSDKServiceProvider.overrideWithValue(tangentService),
      // sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      // driftDBServiceProvider.overrideWith((ref) => driftDBService),
      // firebaseAuthServiceProvider.overrideWithValue(authService),
      // superwallServiceProvider.overrideWithValue(superwallService),
      // remoteConfigServiceProvider.overrideWithValue(remoteConfigService),
    ],
  );

  runApp(UncontrolledProviderScope(container: container, child: const AppRoot()));
}
