import 'dart:convert';

import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/models/user_model.dart';

class PeminjamanModel {
  final int id;
  final int idBuku;
  final int idMember;
  final String tanggalPeminjaman;
  final String tanggalPengembalian;
  final String status;
  final UserModel member;
  final BukuModel buku;

  PeminjamanModel({
    required this.id,
    required this.idBuku,
    required this.idMember,
    required this.tanggalPeminjaman,
    required this.tanggalPengembalian,
    required this.status,
    required this.member,
    required this.buku,
  });

  Map<String, String> toJson() {
    return {
      "id": id.toString(),
      "id_buku": idBuku.toString(),
      "id_member": idMember.toString(),
      "tanggal_peminjaman": tanggalPeminjaman,
      "tanggal_pengembalian": tanggalPengembalian,
      "status": status,
      "member": jsonEncode(member),
      "buku": jsonEncode(buku),
    };
  }
}
