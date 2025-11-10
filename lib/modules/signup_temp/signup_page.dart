import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/login/login_controller.dart';
import 'package:stok_satis_firebase/modules/signup_temp/signup_controller.dart';
import 'package:stok_satis_firebase/modules/signup_temp/verify_page.dart';
import 'package:stok_satis_firebase/modules/signup_temp/widgets/signup_cancel.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';

import '../login/widgets/qr_scanner.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    const Spacer(),
                    Obx(
                      () => Column(
                        children: [
                          Visibility(
                            visible:
                                controller.personal.value &&
                                !controller.isWindows(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: "Dükkan QR Code",
                                    ),
                                    controller: controller.uidController,
                                    readOnly: !controller.isWindows(),
                                    obscureText: true,
                                    showCursor: false,
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Get.lazyPut(() => LoginController());
                                    Get.to(QrScanner(forSignUp: true));
                                  },

                                  child: const Icon(Icons.qr_code),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: controller.owner.value,
                            child: TextField(
                              controller: controller.ownerName,
                              decoration: InputDecoration(labelText: "İsim"),
                            ),
                          ),
                          Visibility(
                            visible: controller.owner.value,
                            child: TextField(
                              controller: controller.ownerSurname,
                              decoration: InputDecoration(
                                labelText: "Soy isim",
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                (controller.owner.value ||
                                controller.personal.value),
                            child: TextField(
                              controller: controller.emailorNameController,
                              decoration: InputDecoration(
                                labelText: controller.personal.value
                                    ? "İsim"
                                    : "Mail",
                              ),
                            ),
                          ),
                          Visibility(
                            visible:
                                (controller.owner.value ||
                                controller.personal.value),
                            child: TextField(
                              controller:
                                  controller.passwordOrSurnameController,
                              decoration: InputDecoration(
                                labelText: controller.personal.value
                                    ? "Soyisim"
                                    : "Şifre",
                              ),
                              obscureText: controller.owner.value
                                  ? true
                                  : false,
                              maxLength: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: !controller.personal.value,
                                child: OutlinedButton.icon(
                                  onPressed: () async {
                                    if (!controller.owner.value) {
                                      controller.personal.value = false;
                                      controller.owner.value = true;
                                    } else if (controller.owner.value) {
                                      final success = await controller
                                          .ownerSignUp();
                                      if (success) {
                                        Get.to(
                                          VerifyPage(),
                                        ); // ✅ sadece başarılıysa
                                      }
                                    }
                                  },
                                  label: const Text("Dükkan Kayıt"),
                                  icon: Icon(Icons.home_outlined),
                                ),
                              ),
                              SizedBox(width: 15),
                              SignupCancel(visible: controller.owner),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(
                                () => Visibility(
                                  visible:
                                      !controller.owner.value &&
                                      controller.isWindowsOwnerUidSet.value,
                                  child: OutlinedButton.icon(
                                    onPressed: () async {
                                      if (!controller.personal.value) {
                                        controller.personal.value = true;
                                        controller.owner.value = false;
                                      } else if (controller.personal.value) {
                                        await controller.personalSignUp();

                                        // Eğer kayıt başarılıysa, PendingApprovalPage’e yönlendir
                                      }
                                    },
                                    label: const Text("Personel Kayıt"),
                                    icon: Icon(Icons.person_2_outlined),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              SignupCancel(visible: controller.personal),
                            ],
                          ),
                          TextButton(
                            onPressed: () => Get.offAllNamed(AppRoutes.login),
                            child: Text(
                              "Kayıtlıysanız Buraya Tıklayınız",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
