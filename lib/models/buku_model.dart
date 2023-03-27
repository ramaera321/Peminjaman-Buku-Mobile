class BukuModel {
  final int id;
  final String kodeBuku;
  final int categoryId;
  final String judul;
  final String slug;
  final String penerbit;
  final String pengarang;
  final String tahun;
  final int stok;
  String? path;

  BukuModel({
    required this.id,
    required this.kodeBuku,
    required this.categoryId,
    required this.judul,
    required this.slug,
    required this.penerbit,
    required this.pengarang,
    required this.tahun,
    required this.stok,
    this.path,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "kode_buku": kodeBuku,
      "category_id": categoryId,
      "judul": judul,
      "slug": slug,
      "penerbit": penerbit,
      "pengarang": pengarang,
      "tahun": tahun,
      "stok": stok,
      "path": path!,
    };
  }
}
