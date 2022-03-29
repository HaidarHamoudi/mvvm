import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mvvm/app/di.dart';
import 'package:mvvm/presentation/resources/language_manager.dart';

import 'app/app.dart';

void main() async {
  // You only need to call this method if you need the binding to be
  // initialized before calling [runApp]. (Ex: To prevent null check operator error for shared prefs instance)
  WidgetsFlutterBinding.ensureInitialized();
  // Make sure that localization is initialized
  await EasyLocalization.ensureInitialized();
  // I have registered our dependency injection module inside our main
  await initAppModule();
  runApp(
    EasyLocalization(
      // Phoenix for easy restart the app
      child: Phoenix(
        child: MyApp(),
      ),
      supportedLocales: const [ENGLISH_LOCAL, ARABIC_LOCAL],
      path: ASSETS_PATH_LOCALIZATIONS,
    ),
  );
}
