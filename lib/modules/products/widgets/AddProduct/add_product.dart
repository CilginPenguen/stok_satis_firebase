import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../product_controller.dart';
import '../Product/barcode_scanner.dart';
import 'product_barcode.dart';
import 'product_brand.dart';
import 'product_category.dart';
import 'product_count.dart';
import 'product_description.dart';
import 'product_price.dart';
import 'save_button.dart';

class AddProduct extends GetView<ProductController> {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ürün Ekle")),
      body: FutureBuilder<bool>(
        future: controller.checkPermission(permissionName: "addProduct"),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == false) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Yetkiniz Bulunmamaktadır")],
              ),
            );
          }

          // Yetkisi varsa formu göster
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: ProductBarcode()),
                      IconButton(
                        onPressed: () {
                          Get.to(() => BarcodeScanner(mod: 2));
                        },
                        icon: Icon(Icons.qr_code_scanner),
                      ),
                    ],
                  ),
                  ProductBrand(),
                  SizedBox(height: 8),
                  ProductCategory(),
                  SizedBox(height: 8),
                  ProductDescription(),
                  SizedBox(height: 8),
                  ProductPrice(),
                  SizedBox(height: 8),
                  ProductCount(),
                  SizedBox(height: 8),
                  SaveButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
