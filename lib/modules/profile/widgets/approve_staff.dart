import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/profile/profile_controller.dart';

class ApproveStaff extends GetView<ProfilePageController> {
  const ApproveStaff({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.checkOwner(),
      child: Obx(() {
        if (controller.approvePersonel.isEmpty) {
          return Card(
            child: ExpansionTile(
              title: ListTile(
                title: Text(
                  "Onay Bekleyen Personel: ${controller.approvePersonel.length}",
                ),
              ),
            ),
          );
        }
        return Card(
          child: ExpansionTile(
            title: Text(
              "Onay Bekleyen Personel: ${controller.approvePersonel.length}",
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.approvePersonel.length,
                itemBuilder: (context, index) {
                  final approve = controller.approvePersonel[index];
                  return Card(
                    child: ListTile(
                      key: ValueKey(approve.staffUid),
                      title: Text("${approve.firstName} ${approve.lastName}"),
                      subtitle: Text(
                        "Cihaz: ${approve.deviceApproval.deviceId}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton.outlined(
                            onPressed: () async => controller.updateApproval(
                              uid: approve.staffUid,
                              approveStatus: false,
                              forDelete: true,
                            ),
                            icon: Icon(
                              Icons.cancel_outlined,
                              color: Colors.red,
                            ),
                          ),
                          IconButton.outlined(
                            onPressed: () async => controller.updateApproval(
                              uid: approve.staffUid,
                              approveStatus: true,
                              forDelete: false,
                            ),
                            icon: Icon(Icons.done, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
