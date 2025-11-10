import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:stok_satis_firebase/modules/desktop/desktop_page.dart';
import 'package:stok_satis_firebase/modules/signup_temp/personal/personal_can_login.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';
import 'package:stok_satis_firebase/services/storage_service.dart';

import '../models/deviceapproval.dart';
import '../models/staff.dart';
import '../modules/basket/basket_controller.dart';
import '../modules/home/home_page.dart';
import '../modules/products/product_controller.dart';
import '../modules/signup_temp/personal/personal_reject.dart';
import '../modules/signup_temp/personal/personal_waiting_approval.dart';
import '../themes/app_colors.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class BaseController extends GetxController {
  final storage = Get.find<StorageService>();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final urunEklemeBool = false.obs;
  final urunDuzenleBool = false.obs;

  /// 🔹 Barkod tamponu
  String _buffer = '';
  DateTime? _lastKeyTime;

  /// 🔹 Listener aktif mi
  bool _listening = false;

  @override
  void onInit() {
    super.onInit();
    _startListening();
    checkWindowsOwnerUid();
  }

  @override
  void onClose() {
    _stopListening();
    super.onClose();
  }

  // ✅ Mod değiştirme fonksiyonları
  void setEkleme(bool value) {
    urunEklemeBool.value = value;
    if (value) urunDuzenleBool.value = false;
  }

  void setDuzenle(bool value) {
    urunDuzenleBool.value = value;
    if (value) urunEklemeBool.value = false;
  }

  void reset() {
    urunEklemeBool.value = false;
    urunDuzenleBool.value = false;
  }

  // 🧠 Barkod dinleme başlat
  void _startListening() {
    if (_listening) return;
    _listening = true;
    HardwareKeyboard.instance.addHandler(_handleKeyEvent);
  }

  // 🧠 Barkod dinleme durdur
  void _stopListening() {
    if (!_listening) return;
    _listening = false;
    HardwareKeyboard.instance.removeHandler(_handleKeyEvent);
  }

  // 🧩 Klavye olaylarını dinler
  bool _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    final key = event.logicalKey;

    final now = DateTime.now();
    if (_lastKeyTime == null ||
        now.difference(_lastKeyTime!).inMilliseconds > 100) {
      _buffer = '';
    }
    _lastKeyTime = now;

    if (key == LogicalKeyboardKey.enter) {
      final barkod = _buffer.trim();
      if (barkod.isNotEmpty) _processBarcode(barkod);
      _buffer = '';
    } else {
      _buffer += key.keyLabel;
    }

    return false;
  }

  // 🧩 Barkod okunduğunda çalışır
  void _processBarcode(String barkod) {
    final productCtrl = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : null;
    final basketCtrl = Get.isRegistered<BasketController>()
        ? Get.find<BasketController>()
        : null;

    if (urunEklemeBool.value) {
      basketCtrl?.processBarcode(barkod);
    } else if (urunDuzenleBool.value) {
      productCtrl?.barkodUrunArama(barkod);
    }
  }

  Future<void> storageClean() async {
    storage.remove("ownerUid");
    storage.remove("staffUid");
  }

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
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfoPlugin.windowsInfo;
      return 'Windows-${windowsInfo.computerName}-${windowsInfo.numberOfCores}C';
    } else if (Platform.isMacOS) {
      final macInfo = await deviceInfoPlugin.macOsInfo;
      return 'macOS-${macInfo.computerName}-${macInfo.osRelease}';
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfoPlugin.linuxInfo;
      return 'Linux-${linuxInfo.name}-${linuxInfo.id}';
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
              if (isWindows()) {
                return const DesktopPage();
              }
              return const HomePage();
            } else {
              return const PersonalCanLogin();
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

  Future<String> bringNameAndSurname() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return user.displayName ?? "Dükkan Sahibi bulunamadı";
      } else {
        final ownerUid = storage.getValue<String>("ownerUid");
        final staffUid = storage.getValue<String>("staffUid");
        Staff personel;
        if (ownerUid != null && staffUid != null) {
          final snap = await FirebaseFirestore.instance
              .collection("users")
              .doc(ownerUid)
              .collection("staff")
              .doc(staffUid)
              .get();
          if (snap.exists) {
            final data = snap.data();
            if (data != null) {
              personel = Staff.fromMap(data, docId: snap.id);
              return "${personel.name} ${personel.surname}".trim();
            }
          } else {
            return "Personel İsmi Bulunamadı";
          }
        }
      }
      return "İsim Getirilemedi";
    } catch (e) {
      showErrorSnackbar(message: "Hata: $e");
      return "Hata";
    }
  }

  Future<String> bringOwnerUid() async {
    final user = auth.currentUser;
    String bringOwner =
        (storage.getValue<String>("ownerUid") ?? user?.uid ?? "");
    return bringOwner;
  }

  Future<String?> bringStaffUid() async {
    final staffUid = storage.getValue<String>("staffUid");
    return staffUid;
  }

  bool isWindows() {
    if (Platform.isWindows) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateFavorite({
    required String uid,
    required bool isFavorited,
  }) async {
    try {
      String ownerUid = await bringOwnerUid();
      await db
          .collection("users")
          .doc(ownerUid)
          .collection("urunler")
          .doc(uid)
          .update({"isFavorited": isFavorited});
      final pc = Get.find<ProductController>();
      final index = pc.urunListesi.indexWhere((e) => e.urun_id == uid);
      if (index != -1) {
        final updated = pc.urunListesi[index].copyWith(
          isFavorited: isFavorited,
        );
        pc.urunListesi[index] = updated;
        pc.urunListesi.refresh(); // 🔁 UI’ı yeniden build et
      }
    } catch (e) {
      showErrorSnackbar(message: "Favori İşleminde Hata: $e");
    }
  }

  final isWindowsOwnerUidSet = false.obs;

  Future<void> checkWindowsOwnerUid() async {
    if (isWindows()) {
      final uid = await bringOwnerUid();
      isWindowsOwnerUidSet.value = uid.isNotEmpty;
    } else {
      isWindowsOwnerUidSet.value = true;
    }
  }
}
