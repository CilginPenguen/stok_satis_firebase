// clock_service.dart
import 'package:get/get.dart';
import 'storage_service.dart';

class ClockService extends GetxService {
  final _storageService = Get.find<StorageService>();
  final _clockOpen = true.obs;

  bool get clockMode => _clockOpen.value;

  @override
  void onInit() {
    super.onInit();
    loadClockStatus();
  }

  void loadClockStatus() {
    final savedClockMode = _storageService.getValue<String>(
      StorageKeys.clockCheck,
    );
    if (savedClockMode != null) {
      _clockOpen.value = savedClockMode == 'true';
    } else {
      _clockOpen.value = true;
    }
  }

  Future<void> toggleClock() async {
    _clockOpen.value = !_clockOpen.value;
    await _storageService.setValue<String>(
      StorageKeys.clockCheck,
      _clockOpen.value.toString(),
    );
  }
}
