class Urunler {
  final String urun_id;
  final String urun_barkod;
  final String urun_description;
  final int urun_adet;
  final double urun_fiyat;
  final String category;
  final String marka;
  final bool isFavorited;

  Urunler({
    required this.urun_id,
    required this.urun_barkod,
    required this.urun_description,
    required this.urun_adet,
    required this.urun_fiyat,
    required this.category,
    required this.marka,
    this.isFavorited = false,
  });

  factory Urunler.fromMap(Map<String, dynamic> map, {required String docId}) {
    double toDouble(dynamic value) => value is int ? value.toDouble() : value;

    return Urunler(
      urun_id: docId,
      urun_barkod: map['urun_barkod'] ?? "",
      urun_description: map['urun_description'] ?? "",
      urun_adet: map['urun_adet'] ?? 0,
      urun_fiyat: toDouble(map['urun_fiyat']),
      category: map["category"] ?? "",
      marka: map["marka"] ?? "",
      isFavorited: map["isFavorited"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "urun_id": urun_id,
      "urun_barkod": urun_barkod,
      "urun_description": urun_description,
      "urun_adet": urun_adet,
      "urun_fiyat": urun_fiyat,
      "category": category,
      "marka": marka,
      "isFavorited": isFavorited,
    };
  }

  Urunler copyWith({
    String? urun_id,
    String? urun_barkod,
    String? urun_description,
    int? urun_adet,
    double? urun_fiyat,
    String? category,
    String? marka,
    bool? isFavorited,
  }) {
    return Urunler(
      urun_id: urun_id ?? this.urun_id,
      urun_barkod: urun_barkod ?? this.urun_barkod,
      urun_description: urun_description ?? this.urun_description,
      urun_adet: urun_adet ?? this.urun_adet,
      urun_fiyat: urun_fiyat ?? this.urun_fiyat,
      category: category ?? this.category,
      marka: marka ?? this.marka,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }
}
