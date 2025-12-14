import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/app_bindings.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';
import 'utils/themes/app_theme.dart';

// translations
import 'utils/translations/app_translations.dart';

// storage service
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final appBindings = AppBindings();
  await appBindings.dependencies();

  // StorageService init ve register
  final storageService = await StorageService().init();
  Get.put<StorageService>(storageService, permanent: true);

  // --- Locale yükleme: önce storage sonra sistem dili ---
  Locale initialLocale = _loadInitialLocale(storageService);

  runApp(MyApp(initialLocale: initialLocale));
}

Locale _loadInitialLocale(StorageService storageService) {
  final saved = storageService.getValue<String>(StorageKeys.locale);
  if (saved != null && saved.isNotEmpty) {
    final parts = saved.split('_'); // 
    return Locale(parts[0], parts[1]);
  }

  // storage'da kayıt yoksa cihazın sistem dilini kullan
  try {
    // Flutter 3.7+ recommended access:
    final platformLocale = WidgetsBinding.instance.platformDispatcher.locale;
    if (platformLocale != null) return platformLocale;
  } catch (_) {
    // fallback
  }

  return const Locale('tr', 'TR'); // kesinlikle fallback
}

class MyApp extends StatelessWidget {
  final Locale? initialLocale;
  const MyApp({super.key, this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,

      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),

      initialRoute: AppRoutes.initial,
    );
  }
}
