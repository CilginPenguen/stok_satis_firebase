import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/login/login_controller.dart';
import 'package:stok_satis_firebase/modules/login/widgets/qr_scanner.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';
import 'widgets/cancelButton.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Giriş")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const Spacer(), // İçerik ortalanıyor
                      Obx(
                        () => Column(
                          children: [
                            Visibility(
                              visible: controller.personal.value,
                              child: controller.isWindows()
                                  ? Row()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              labelText: "Dükkan QR Code",
                                            ),
                                            controller:
                                                controller.uidController,
                                            readOnly: true,
                                            obscureText: true,
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () => Get.to(
                                            QrScanner(forSignUp: false),
                                          ),
                                          child: const Icon(Icons.qr_code),
                                        ),
                                      ],
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
                                    onPressed: () {
                                      if (!controller.owner.value) {
                                        controller.personal.value = false;
                                        controller.owner.value = true;
                                      } else if (controller.owner.value) {
                                        controller.ownerSignIn();
                                      }
                                    },
                                    label: const Text("Dükkan Giriş"),
                                    icon: const Icon(Icons.home_outlined),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Cancel(visible: controller.owner),
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
                                      onPressed: () {
                                        if (!controller.personal.value) {
                                          controller.personal.value = true;
                                          controller.owner.value = false;
                                        } else if (controller.personal.value) {
                                          controller.personalSignIn();
                                        }
                                      },
                                      label: const Text("Personel Giriş"),
                                      icon: const Icon(Icons.person_2_outlined),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Cancel(visible: controller.personal),
                              ],
                            ),

                            Obx(
                              () => Visibility(
                                visible:
                                    controller.owner.value == false &&
                                    controller.personal.value == false,
                                child: Column(
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Get.offAllNamed(AppRoutes.signUp),
                                      child: const Text(
                                        "Henüz Kayıt Olmadıysanız Tıklayınız",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      label: Text("Şifremi Unuttum"),
                                      icon: Icon(Icons.password_rounded),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(), // Ortalamayı koruyor
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
