import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_controller.dart';

class SignupBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SignupController());
  }
}
