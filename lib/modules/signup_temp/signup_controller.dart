import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/core/base_controller.dart';
import 'package:stok_satis_firebase/models/deviceapproval.dart';
import 'package:stok_satis_firebase/models/owner.dart';
import 'package:stok_satis_firebase/models/permissions.dart';
import 'package:stok_satis_firebase/models/staff.dart';
import 'package:stok_satis_firebase/routes/app_pages.dart';
import 'package:stok_satis_firebase/services/storage_service.dart';
import 'package:uuid/uuid.dart';

class SignupController extends BaseController {
  final emailorNameController = TextEditingController();
  final passwordOrSurnameController = TextEditingController();
  final uidController = TextEditingController();
  final ownerName = TextEditingController();
  final ownerSurname = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  RxBool owner = false.obs;
  RxBool personal = false.obs;
  RxBool isSending = false.obs;
  RxBool isSigningUp = false.obs;

  Future<void> personalSignUp() async {
    final storage =
        Get.find<StorageService>(); // global StorageService instance

    try {
      // Owner dokümanını getir
      final ownerDoc = await _db
          .collection("users")
          .doc(uidController.text)
          .get();
      final staffRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uidController.text.trim())
          .collection("staff");

      final query = await staffRef
          .where("firstName", isEqualTo: emailorNameController.text.trim())
          .where("lastName", isEqualTo: passwordOrSurnameController.text.trim())
          .limit(1)
          .get();

      if (!ownerDoc.exists) {
        Get.snackbar("Hata", "Owner bulunamadı!");
        final storage = Get.find<StorageService>();
        storage.clear();
        return;
      }
      if (query.docs.isNotEmpty) {
        final existingStaffDoc = query.docs.first;

        // StorageService'e yaz
        await storage.setValue("staffUid", existingStaffDoc.id);
        await storage.setValue("ownerUid", uidController.text.trim());
        Get.offAllNamed(AppRoutes.auth);

        return;
      }

      // Yeni staff UID oluştur
      final staffUid = const Uuid().v4();
      final device = DeviceApproval(
        deviceId: await getDeviceId(),
        requestDate: DateTime.now(),
      );
      final staff = Staff(
        staffUid: staffUid,
        firstName: emailorNameController.text.trim(),
        lastName: passwordOrSurnameController.text.trim(),
        permissions: Permissions(),
        joinedAt: DateTime.now(),
        deviceApproval: device,
      );

      // Firestore'a ekle (await ile)
      await _db
          .collection("users")
          .doc(uidController.text) // owner UID
          .collection("staff")
          .doc(staffUid)
          .set(staff.toMap());
      clearForm();

      print("Staff UID: $staffUid (${staffUid.runtimeType})");
      print(
        "Owner UID: ${uidController.text} (${uidController.text.runtimeType})",
      );

      // SharedPreferences'e ekle ve hataları detaylı logla
      final staffSaved = await storage.setValue("staffUid", staffUid);
      final ownerSaved = await storage.setValue(
        "ownerUid",
        uidController.text.trim(),
      );
      final ownerUid = storage.getValue<String>("ownerUid");
      final staffUidd = storage.getValue<String>("staffUid");
      print(ownerUid);
      print(staffUidd);

      if (!staffSaved || !ownerSaved) {
        print("SharedPreferences'e veri eklenirken sorun oluştu.");
      }
      Get.offAllNamed(AppRoutes.auth);
    } catch (e, s) {
      print("personalSignUp sırasında hata oluştu: $e");
      print(s); // detaylı stack trace
      Get.snackbar("Hata", e.toString());
    }
  }

  Future<bool> ownerSignUp() async {
    final email = emailorNameController.text.trim();
    final password = passwordOrSurnameController.text.trim();

    try {
      isSigningUp.value = true;

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        final owner = Owner(
          uid: user.uid,
          name: ownerName.text,
          surname: ownerSurname.text,
          email: email,
          joinedAt: DateTime.now(),
        );

        await _db.collection('users').doc(user.uid).set({
          "profil": owner.toMap(),
        });

        if (!user.emailVerified) {
          await user.sendEmailVerification();
          Get.snackbar("E-Posta", "Lütfen E-Postanızı Onaylayın");
        }
        clearForm();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = "Geçersiz e-posta adresi girdiniz.";
          break;
        case 'email-already-in-use':
          message = "Bu e-posta zaten kayıtlı. Lütfen giriş yapın.";
          await _auth.signOut();
          Future.microtask(() => Get.offAllNamed(AppRoutes.login));
          break;
        case 'weak-password':
          message =
              "Şifre çok zayıf. Daha güçlü bir şifre seçin (en az 6 karakter).";
          break;
        case 'operation-not-allowed':
          message =
              "Bu kayıt yöntemi şu an devre dışı. Lütfen başka bir yol deneyin.";
          break;
        case 'too-many-requests':
          message =
              "Çok fazla deneme yaptınız. Lütfen bir süre sonra tekrar deneyin.";
          break;
        case 'network-request-failed':
          message =
              "İnternet bağlantınız yok veya zayıf. Lütfen tekrar deneyin.";
          break;
        case 'user-disabled':
          message = "Bu kullanıcı hesabı devre dışı bırakılmış.";
          break;
        case 'user-not-found':
          message = "Kullanıcı bulunamadı.";
          break;
        case 'wrong-password':
          message = "Şifre yanlış.";
          break;
        default:
          message = e.message ?? "Bilinmeyen bir hata oluştu: ${e.code}";
      }

      Get.snackbar("Hata", message);
    } finally {
      isSigningUp.value = false;
    }
    return false;
  }

  Future<void> onayMail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      isSending.value = true;
      await user.sendEmailVerification();
      isSending.value = false;

      Get.snackbar("Mail", "Doğrulama Maili Gönderildi");
    }
  }

  Future<void> onayKontrol() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        // AuthGate yönlendirecek
        Get.offAllNamed(AppRoutes.home);
        print("Başarılı");
        return;
      } else {
        Get.snackbar("Onay Durumu", "Henüz Doğrulanmadı");
      }
    }
  }

  void clearForm() {
    emailorNameController.clear();
    passwordOrSurnameController.clear();
    uidController.clear();
    ownerName.clear();
    ownerSurname.clear();
  }
}
