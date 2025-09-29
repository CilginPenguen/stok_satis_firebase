class Permissions {
  final bool addProduct;
  final bool editProduct;
  final bool deleteProduct;

  Permissions({
    this.addProduct = false,
    this.editProduct = false,
    this.deleteProduct = false,
  });

  factory Permissions.fromMap(Map<String, dynamic> map) {
    return Permissions(
      addProduct: map['addProduct'] ?? false,
      editProduct: map['editProduct'] ?? false,
      deleteProduct: map['deleteProduct'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'addProduct': addProduct,
      'editProduct': editProduct,
      'deleteProduct': deleteProduct,
    };
  }
}
