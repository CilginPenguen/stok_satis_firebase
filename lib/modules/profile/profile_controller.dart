import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/core/base_controller.dart';
import 'package:stok_satis_firebase/models/owner.dart';
import 'package:stok_satis_firebase/models/permissions.dart';
import 'package:stok_satis_firebase/models/staff.dart';
import 'package:stok_satis_firebase/services/storage_service.dart';

class ProfilePageController extends BaseController {
  var owner = Rxn<Owner>();
  var staffInfo = <Staff>[].obs;
  var permis = Rxn<Permissions>();
  var qr = false.obs;
  var staff = Rxn<Staff>();
  final strg = Get.find<StorageService>();
  var personelList = <Staff>[].obs;
  var approvePersonel = <Staff>[].obs;
  @override
  final auth = FirebaseAuth.instance;
  @override
  final db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    profilGetir();
    personelleriGetir();
  }

  Future<void> profilGetir() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Giriş yapmış kullanıcı Owner ise
        final snap = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();

        if (snap.exists) {
          final data = snap.data();
          final profile = data?['profil'];
          if (profile != null) {
            owner.value = Owner.fromMap(snap.id, profile);
            print("Owner profil yüklendi: ${owner.value}");
          }
        }
      } else {
        // user null ise staff profilini çek
        final ownerUid = strg.getValue<String>("ownerUid");
        final staffUid = strg.getValue<String>("staffUid");

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
              staff.value = Staff.fromMap(data, docId: snap.id);
              print("Staff profil yüklendi: ${staff.value!.permissions}");
            }
          } else {
            print("Staff dokümanı bulunamadı.");
          }
        } else {
          print("ownerUid veya staffUid bulunamadı.");
        }
      }
    } catch (e) {
      Get.snackbar("Hata", "Profil gelirken hata oluştu");
      print("Profil getirirken hata: $e");
    }
  }

  Future<void> personelleriGetir() async {
    final user = auth.currentUser;
    if (user != null) {
      db
          .collection("users")
          .doc(user.uid)
          .collection("staff")
          .snapshots()
          .listen((s) {
            final persons = s.docs.map((e) {
              return Staff.fromMap(e.data(), docId: e.id);
            }).toList();
            final onayliPers = persons
                .where((e) => e.deviceApproval.approved == true)
                .toList();
            personelList.value = onayliPers;
            print(personelList);
            final bekleyenler = persons
                .where((p) => p.deviceApproval.approved == null)
                .toList();

            approvePersonel.value = bekleyenler;
          });
    }
  }

  String uidGetir() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid ?? "";
  }

  Future<void> updatePermission({
    required String uid,
    required String permission,
    required bool value,
  }) async {
    String ownerUid = uidGetir();
    await db
        .collection("users")
        .doc(ownerUid)
        .collection("staff")
        .doc(uid)
        .update({'permissions.$permission': value});
  }

  Future<void> updateApproval({
    required String? uid,
    required bool approveStatus,
    required bool forDelete,
  }) async {
    try {
      String ownerUid = await bringOwnerUid();
      await db
          .collection("users")
          .doc(ownerUid)
          .collection("staff")
          .doc(uid)
          .update({"deviceApproval.approved": approveStatus});
      if (!approveStatus) {
        if (forDelete) {
          Future.delayed(const Duration(seconds: 10), () async {
            await db
                .collection("users")
                .doc(ownerUid)
                .collection("staff")
                .doc(uid)
                .delete();
            showSuccessSnackbar(message: "Personel Silindi");
          });
        }
      }
    } on Exception catch (e) {
      showErrorSnackbar(message: "Hata ${e.toString()}");
    }
  }

  Future<void> deletePersonalDialog({
    required String isim,
    required String id,
  }) async {
    diyalog(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text("Silmek İstiyor Musunuz?"),
            subtitle: Text(isim),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: () => Get.back(result: false),
                label: Text("Hayır"),
                icon: Icon(Icons.cancel_outlined, color: Colors.green),
              ),
              OutlinedButton.icon(
                onPressed: () async {
                  await updateApproval(
                    uid: id,
                    approveStatus: false,
                    forDelete: true,
                  );
                  Get.back();
                },
                label: Text("Evet"),
                icon: Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
