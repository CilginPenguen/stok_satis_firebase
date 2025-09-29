class Urunler {
  final String urun_id; // Firestore doc.id -> asıl kimlik
  final String urun_barkod;
  final String urun_description;
  final int urun_adet;
  final double urun_fiyat;
  final String category;
  final String marka;

  Urunler({
    required this.urun_id,
    required this.urun_barkod,
    required this.urun_description,
    required this.urun_adet,
    required this.urun_fiyat,
    required this.category,
    required this.marka,
  });

  factory Urunler.fromMap(Map<String, dynamic> map, {required String docId}) {
    double toDouble(dynamic value) => value is int ? value.toDouble() : value;

    return Urunler(
      urun_id: docId, // 🔹 doc.id doğrudan atanıyor
      urun_barkod: map['urun_barkod'] ?? "",
      urun_description: map['urun_description'] ?? "",
      urun_adet: map['urun_adet'] ?? 0,
      urun_fiyat: toDouble(map['urun_fiyat']),
      category: map["category"] ?? "",
      marka: map["marka"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 🔹 urun_id’yi Firestore’a kaydetmiyoruz!
      "urun_id": urun_id,
      'urun_barkod': urun_barkod,
      'urun_description': urun_description,
      'urun_adet': urun_adet,
      'urun_fiyat': urun_fiyat,
      'category': category,
      'marka': marka,
    };
  }
}
