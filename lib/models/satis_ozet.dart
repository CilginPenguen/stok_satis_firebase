class SatisOzeti {
  final String satis_id;
  final double toplamTutar;
  final double alinanTutar;
  final String tarih;

  SatisOzeti({
    required this.satis_id,
    required this.toplamTutar,
    required this.alinanTutar,
    required this.tarih,
  });

  Map<String, dynamic> toMap() {
    return {
      'satis_id': satis_id,
      'toplamTutar': toplamTutar,
      'alinanTutar': alinanTutar,
      'tarih': tarih,
    };
  }

  factory SatisOzeti.fromMap(Map<String, dynamic> map) {
    return SatisOzeti(
      satis_id: map['satis_id'] ?? '',
      toplamTutar: (map['toplamTutar'] ?? 0).toDouble(),
      alinanTutar: (map['alinanTutar'] ?? 0).toDouble(),
      tarih: map['tarih'] ?? '',
    );
  }
}
