import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../core/base_controller.dart';
import '../../services/storage_service.dart';
import '../history/history_controller.dart';

class DashboardController extends BaseController {
  RxBool isExpanded = false.obs;
  final aylikGelir = 0.0.obs;
  final aylikGider = 0.0.obs;
  var hc = Get.find<HistoryController>();

  List<String> sayiTipi = [
    " ",
    " ",
    "III",
    " ",
    " ",
    "VI",
    " ",
    " ",
    "IX",
    " ",
    " ",
    "XII",
  ];

  @override
  void onInit() async {
    await hc.gecmisGetir();
    hc.gecmisList;
    super.onInit();
  }

  Future<void> signOut() async {
    final storage = Get.find<StorageService>();
    await storage.remove("staffUid");
    await storage.remove("ownerUid");
    await FirebaseAuth.instance.signOut();
  }
}
