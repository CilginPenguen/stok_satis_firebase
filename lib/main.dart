import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/app_bindings.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 🔹 AppBindings'i manuel initialize ediyoruz
  final appBindings = AppBindings();
  await appBindings.dependencies(); // tüm controller ve servisler hazır

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // ❌ initialBinding gerekmez çünkü biz zaten elle bekledik
      initialRoute: AppRoutes.initial,
    );
  }
}
