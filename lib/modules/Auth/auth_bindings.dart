import 'package:get/get.dart';
import 'package:stok_satis_firebase/core/base_controller.dart';
import 'package:stok_satis_firebase/modules/Auth/auth_controller.dart';
import 'package:stok_satis_firebase/modules/login/login_controller.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => SignupController());
    Get.lazyPut(() => BaseController());
  }
}
