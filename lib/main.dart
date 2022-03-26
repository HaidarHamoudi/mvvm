import 'package:flutter/material.dart';
import 'package:mvvm/app/di.dart';

import 'app/app.dart';

void main() async {
  // You only need to call this method if you need the binding to be
  // initialized before calling [runApp]. (Ex: To prevent null check operator error for shared prefs instance)
  WidgetsFlutterBinding.ensureInitialized();
  // I have registered our dependency injection module inside our main
  await initAppModule();
  runApp(MyApp());
}
