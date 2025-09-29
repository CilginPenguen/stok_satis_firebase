import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/profile/profile_controller.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfilePageController());
  }
}
