class BookKategoriModel {
  final int id;
  final String namaKategori;

  BookKategoriModel({required this.id, required this.namaKategori});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nama_kategori": namaKategori,
    };
  }
}
