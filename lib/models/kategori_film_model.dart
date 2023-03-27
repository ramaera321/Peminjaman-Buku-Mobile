class FilmKategoriModel {
  final String id;
  final String kategori;

  FilmKategoriModel({required this.id, required this.kategori});

  Map<String, String> toJson() {
    return {
      "id": id,
      "kategori": kategori,
    };
  }
}
