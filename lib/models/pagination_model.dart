class PaginationModel {
  final dynamic url;
  final String label;
  final bool active;

  PaginationModel({
    required this.url,
    required this.label,
    required this.active,
  });

  Map<String, dynamic> toJson() {
    return {
      "url": url,
      "label": label,
      "active": active,
    };
  }
}
