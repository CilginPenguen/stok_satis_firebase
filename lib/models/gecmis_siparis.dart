import 'urunler_liste.dart';

class Gecmis extends Urunler {
  final String? gecmis_id;
  final int sepet_birim;
  final double toplam_tutar;
  final String tarih;

  Gecmis({
    this.gecmis_id,
    required super.urun_id,
    required super.urun_barkod,
    required super.urun_description,
    required super.urun_adet,
    required super.urun_fiyat,
    required super.category,
    required super.marka,
    required this.sepet_birim,
    required this.toplam_tutar,
    required this.tarih,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    if (gecmis_id != null) map['gecmis_id'] = gecmis_id;
    map['sepet_birim'] = sepet_birim;
    map['toplam_tutar'] = toplam_tutar;
    map['tarih'] = tarih;
    return map;
  }

  /// 🔹 Firestore docId’yi kullanarak güvenli map dönüşümü
  factory Gecmis.fromMap(Map<String, dynamic> map, {required String docId}) {
    double toDouble(dynamic value) => value is int ? value.toDouble() : value;

    return Gecmis(
      gecmis_id: map['gecmis_id'] ?? docId,
      urun_id: map['urun_id'],
      urun_barkod: map['urun_barkod'] ?? "",
      urun_description: map['urun_description'] ?? "",
      urun_adet: map['urun_adet'] ?? 0,
      urun_fiyat: toDouble(map['urun_fiyat'] ?? 0),
      marka: map['marka'] ?? "",
      category: map['category'] ?? "",
      sepet_birim: map['sepet_birim'] ?? 0,
      toplam_tutar: toDouble(map['toplam_tutar'] ?? 0),
      tarih: map['tarih'] ?? "",
    );
  }
}
