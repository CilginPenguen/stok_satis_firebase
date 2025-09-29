import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:stok_satis_firebase/modules/profile/profile_controller.dart';
import 'package:stok_satis_firebase/modules/profile/widgets/approve_staff.dart';
import 'package:stok_satis_firebase/modules/profile/widgets/staffCard.dart'
    show StaffCard;
import 'package:stok_satis_firebase/modules/profile/widgets/staff_expansionTile.dart';

import 'widgets/ownerCard.dart';
import 'widgets/qr_Button_Area.dart';

class ProfilePage extends GetView<ProfilePageController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profil")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              final o = controller.owner.value;
              return QrButtonArea(o: o);
            }),
            Obx(() {
              final o = controller.owner.value;
              if (o == null) {
                final s = controller.staff.value;
                if (s != null) {
                  return StaffCard(s: s);
                }
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              } else {
                return Column(
                  children: [
                    OwnerCard(o: o),
                    ApproveStaff(),
                    StaffExpansiontile(),
                  ],
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
