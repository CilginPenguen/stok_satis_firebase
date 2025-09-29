import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_controller.dart';

class SignupCancel extends GetView<SignupController> {
  const SignupCancel({super.key, required this.visible});
  final RxBool visible;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: (visible.value),
        child: OutlinedButton(
          onPressed: () {
            controller.personal.value = false;
            controller.owner.value = false;
          },
          child: Text("Iptal Et"),
        ),
      ),
    );
  }
}
