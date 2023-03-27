class FilmModel {
  final String id;
  final String name;
  final String kategori;

  FilmModel({required this.id, required this.name, required this.kategori});

  Map<String, String> toJson() {
    return {"id": id, "name": name};
  }
}
