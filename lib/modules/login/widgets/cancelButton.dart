import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login_controller.dart';

class Cancel extends GetView<LoginController> {
  const Cancel({super.key, required this.visible});
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
