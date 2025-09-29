import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:stok_satis_firebase/core/base_controller.dart';

import '../../routes/app_pages.dart';
import '../../services/storage_service.dart';

class LoginController extends BaseController {
  final emailorNameController = TextEditingController();
  final passwordOrSurnameController = TextEditingController();
  final uidController = TextEditingController();
  RxBool owner = false.obs;
  RxBool personal = false.obs;

  final _auth = FirebaseAuth.instance;
  //final _db = FirebaseFirestore.instance;

  MobileScannerController qrController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    detectionTimeoutMs: 500,
    autoZoom: true,
    formats: [BarcodeFormat.qrCode],
  );

  Future<void> ownerSignIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailorNameController.text.trim(),
        password: passwordOrSurnameController.text.trim(),
      );

      if (!userCredential.user!.emailVerified) {
        Get.snackbar(
          "Doğrulama",
          "Lütfen Giriş Yapmadan Önce Doğrulama Yapınız",
        );
        await _auth.signOut();
        return;
      }
      clearForm();

      // giriş başarılı, yönlendirme yapılabilir
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        Get.snackbar("Hata", "Mailiniz veya Şifreniz Hatalı");
      }
    } catch (e) {
      Get.snackbar("Hata", e.toString());
    }
  }

  void personalSignIn() async {
    final storage = Get.find<StorageService>();

    final ownerUid = uidController.text.trim(); // QR’dan gelen
    final name = emailorNameController.text.trim();
    final surname = passwordOrSurnameController.text.trim();

    if (ownerUid.isEmpty || name.isEmpty || surname.isEmpty) {
      Get.snackbar("Hata", "Lütfen tüm alanları doldurun");
      return;
    }

    try {
      // Firestore’da staff arıyoruz
      final staffRef = FirebaseFirestore.instance
          .collection("users")
          .doc(ownerUid)
          .collection("staff");

      final query = await staffRef
          .where("firstName", isEqualTo: name)
          .where("lastName", isEqualTo: surname)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        Get.snackbar("Hata", "Personel kaydı bulunamadı");
        return;
      }

      final staffDoc = query.docs.first;
      print("staffDoc.id:  ${staffDoc.id}");
      print(staffDoc.id.runtimeType);

      // StorageService’e kaydet
      await storage.setValue<String>("ownerUid", ownerUid);
      await storage.setValue<String>("staffUid", staffDoc.id);
      print("owner Uid: ${storage.getValue<String>("ownerUid")}");
      print("staff Uid: ${storage.getValue<String>("staffUid")}");
      clearForm();
      // AuthPage’e dön
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      Get.snackbar("Hata", "Personel girişinde hata: $e");
    }
  }

  void clearForm() {
    emailorNameController.clear();
    passwordOrSurnameController.clear();
    uidController.clear();
  }
}
