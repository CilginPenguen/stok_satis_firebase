import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/signup_temp/personal/personal_can_login.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';
import 'package:stok_satis_firebase/services/storage_service.dart';

import '../models/deviceapproval.dart';
import '../models/staff.dart';
import '../modules/home/home_page.dart';
import '../modules/signup_temp/personal/personal_reject.dart';
import '../modules/signup_temp/personal/personal_waiting_approval.dart';
import '../themes/app_colors.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class BaseController extends GetxController {
  Future<void> storageClean() async {
    final storage = Get.find<StorageService>();
    storage.remove("ownerUid");
    storage.remove("staffUid");
  }

  final ssc = Get.find<StorageService>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<void> alertDiyalog({
    required String title,
    required Widget widgets,
  }) async {
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        actions: [widgets],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        elevation: 10,
      ),
      barrierDismissible: true,
    );
  }

  Future<void> diyalog(Widget widgets) async {
    Get.dialog(Dialog(child: widgets), barrierDismissible: false);
  }

  void showErrorSnackbar({
    required String message,
    String title = 'Hata',
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Get.isDarkMode
          ? AppColors.darkExpense
          : AppColors.expense,
      colorText: Get.isDarkMode
          ? AppColors.darkTextPrimary
          : AppColors.textPrimary,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      duration: duration,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      overlayBlur: 0.5,
      overlayColor: Colors.black12,
    );
  }

  void showSuccessSnackbar({
    required String message,
    String title = 'Başarılı',
    Duration duration = const Duration(seconds: 3),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.isDarkMode ? AppColors.darkIncome : AppColors.income,
      colorText: Get.isDarkMode
          ? AppColors.darkTextPrimary
          : AppColors.textPrimary,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      duration: duration,
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      overlayBlur: 0.5,
      overlayColor: Colors.black12,
    );
  }

  Future<String> getDeviceId() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return '${androidInfo.manufacturer}-${androidInfo.model}';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return '${iosInfo.name}-${iosInfo.model}-${iosInfo.identifierForVendor}';
    } else {
      return 'unknown-device';
    }
  }

  Stream<Widget> checkDeviceApprovalStream({
    required String ownerUid,
    required String staffUid,
  }) async* {
    final deviceId = await getDeviceId();

    yield* FirebaseFirestore.instance
        .collection("users")
        .doc(ownerUid)
        .collection("staff")
        .doc(staffUid)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) {
            return const PersonalWaitingApproval();
          }

          final data = snapshot.data() ?? {};
          DeviceApproval? deviceApproval;

          if (data['deviceApproval'] != null) {
            deviceApproval = DeviceApproval.fromMap(data['deviceApproval']);
          }

          if (deviceApproval == null) {
            return const PersonalWaitingApproval();
          }

          if (deviceApproval.deviceId != deviceId) {
            // Cihaz farklı → uyarı verip LoginPage'e yönlendir
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorSnackbar(
                message: "Cihazınız kayıtlı cihazla eşleşmiyor.",
              );
              storageClean();

              Get.offAllNamed(AppRoutes.login);
            });
            return const SizedBox.shrink();
          }

          // Cihaz eşleşiyorsa approved durumuna göre yönlendir
          if (deviceApproval.approved == true) {
            if (deviceApproval.canLogin == true) {
              return const HomePage();
            } else {
              return PersonalCanLogin();
            }
          } else if (deviceApproval.approved == false) {
            storageClean();
            return const RejectedPage();
          } else {
            return const PersonalWaitingApproval();
          }
        });
  }

  bool checkOwner() {
    final user = auth.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkPermission({required String permissionName}) async {
    try {
      bool userCheck = checkOwner();
      if (!userCheck) {
        final storage = Get.find<StorageService>();
        String? staffUid = storage.getValue<String>("staffUid");
        String? ownerUid = storage.getValue<String>("ownerUid");

        if (staffUid != null && ownerUid != null) {
          final checkStaff = await db
              .collection("users")
              .doc(ownerUid)
              .collection("staff")
              .doc(staffUid)
              .get();

          if (checkStaff.exists) {
            final staff = Staff.fromMap(
              checkStaff.data()!,
              docId: checkStaff.id,
            );

            switch (permissionName) {
              case "addProduct":
                return staff.permissions.addProduct;
              case "editProduct":
                return staff.permissions.editProduct;
              case "deleteProduct":
                return staff.permissions.deleteProduct;
              default:
                showErrorSnackbar(
                  message: "Bilinmeyen permission key: $permissionName",
                );
                return false;
            }
          } else {
            showErrorSnackbar(message: "Staff bilgisi bulunamadı.");
            return false;
          }
        } else {
          showErrorSnackbar(message: "Staff UID veya Owner UID bulunamadı.");
          return false;
        }
      } else {
        // Eğer giriş yapmış kullanıcı Owner ise
        return true;
      }
    } catch (e) {
      showErrorSnackbar(message: "Hata oluştu: $e");
      return false;
    }
  }

  Future<String> bringOwnerUid() async {
    final user = auth.currentUser;
    String bringOwner = (ssc.getValue<String>("ownerUid") ?? user?.uid ?? "");
    return bringOwner;
  }

  Future<String?> bringStaffUid() async {
    final staffUid = ssc.getValue<String>("staffUid");
    return staffUid;
  }
}
