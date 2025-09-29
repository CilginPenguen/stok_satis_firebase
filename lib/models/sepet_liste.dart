import 'urunler_liste.dart';

class Sepet extends Urunler {
  int sepet_birim;
  double ilkToplam;

  Sepet({
    required super.urun_id,
    required super.urun_barkod,
    required super.urun_description,
    required super.urun_adet,
    required super.urun_fiyat,
    required super.category,
    required super.marka,
    required this.sepet_birim,
    required this.ilkToplam,
  });

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['sepet_birim'] = sepet_birim;
    map['ilkToplam'] = ilkToplam;
    return map;
  }

  factory Sepet.fromMap(Map<String, dynamic> map) {
    double toDouble(dynamic value) => value is int ? value.toDouble() : value;

    return Sepet(
      urun_id: map['urun_id'],
      urun_barkod: map['urun_barkod'],
      urun_description: map['urun_description'],
      urun_adet: map['urun_adet'],
      urun_fiyat: toDouble(map['urun_fiyat']),
      category: map['category'],
      marka: map['marka'],
      sepet_birim: map['sepet_birim'],
      ilkToplam: toDouble(map['ilkToplam']),
    );
  }
}
