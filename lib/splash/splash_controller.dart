import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../services/storage_service.dart';

class SplashController extends GetxController {
  var isReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    try {
      // StorageService register edilene kadar bekle
      if (!Get.isRegistered<StorageService>()) {
        await Get.putAsync<StorageService>(() async {
          final service = StorageService();
          await service.init();
          return service;
        }, permanent: true);
      } else {
        // Zaten register edilmişse init et
        final service = Get.find<StorageService>();
        await service.init();
      }

      isReady.value = true;

      // Servis hazır → yönlendir
      if (Get.currentRoute == AppRoutes.splash) {
        Get.offAllNamed(AppRoutes.auth);
      }
    } catch (e) {}
  }
}
