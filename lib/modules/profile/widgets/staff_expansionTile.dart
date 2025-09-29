import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stok_satis_firebase/modules/profile/profile_controller.dart';

class StaffExpansiontile extends GetView<ProfilePageController> {
  const StaffExpansiontile({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: controller.checkOwner(),
      child: Obx(() {
        if (controller.personelList.isEmpty) {
          return const Center(
            child: ListTile(title: Text("Henüz personel eklenmemiş")),
          );
        }

        return Card(
          child: ExpansionTile(
            title: Text("Aktif Personel: ${controller.personelList.length}"),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.personelList.length,
                itemBuilder: (context, index) {
                  final staff = controller.personelList[index];
                  return Dismissible(
                    key: ValueKey(staff.staffUid),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      return null;
                    },
                    child: ExpansionTile(
                      key: ValueKey(staff.staffUid),
                      title: Text("${staff.firstName} ${staff.lastName}"),
                      subtitle: Text(
                        "Katılım: ${staff.joinedAt.toLocal().toString().split(' ')[0]}",
                      ),
                      children: [
                        Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _permissionCheckbox(
                                "Ürün Ekleme",
                                staff.permissions.addProduct,
                                (val) {
                                  controller.updatePermission(
                                    uid: staff.staffUid ?? "",
                                    permission: "addProduct",
                                    value: val ?? false,
                                  );
                                },
                              ),
                              _permissionCheckbox(
                                "Ürün Düzenleme",
                                staff.permissions.editProduct,
                                (val) {
                                  controller.updatePermission(
                                    uid: staff.staffUid ?? "",
                                    permission: "editProduct",
                                    value: val ?? false,
                                  );
                                },
                              ),
                              _permissionCheckbox(
                                "Ürün Silme",
                                staff.permissions.deleteProduct,
                                (val) {
                                  controller.updatePermission(
                                    uid: staff.staffUid ?? "",
                                    permission: "deleteProduct",
                                    value: val ?? false,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _permissionCheckbox(
    String title,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Card(
      child: CheckboxListTile(
        value: value,
        title: Text(title),
        activeColor: Colors.blue,
        onChanged: onChanged,
      ),
    );
  }
}
