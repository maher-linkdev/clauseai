import 'package:deal_insights_assistant/src/app_root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


late ProviderContainer container;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // try {

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
  // } catch (error, stackTrace) {
  //   print('App initialization failed: $error');
  //   print('Stack trace: $stackTrace');
  // }
}
