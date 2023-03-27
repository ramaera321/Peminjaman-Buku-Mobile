import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/models/kategori_buku_model.dart';
import 'package:perpustakaan/models/peminjaman_model.dart';
import 'package:perpustakaan/models/user_model.dart';

class PeminjamanProvider with ChangeNotifier {
  final Dio _dio = Dio();
  String? _token, _userId, _userRole;
  List<PeminjamanModel> _dataPeminjaman = [];
  List<PeminjamanModel> _listPeminjaman = [];
  List<BukuModel> _dataBuku = [];
  List<UserModel> _dataUser = [];
  int _dipinjam = 0;
  int _dikembalikan = 0;
  bool _isSuccess = false;
  bool _isLoading = false;
  Color _colorText = Colors.black;
  UserModel? _user;
  BukuModel? _buku;

  List<PeminjamanModel> _bukuDipinjam = [];

  List<PeminjamanModel> get dataPeminjaman => _dataPeminjaman;
  List<PeminjamanModel> get listPeminjaman => _listPeminjaman;
  List<BukuModel> get dataBuku => _dataBuku;
  List<UserModel> get dataUser => _dataUser;
  String? get idToken => _token;
  String? get userId => _userId;
  String? get userRole => _userRole;
  int get dipinjam => _dipinjam;
  int get dikembalikan => _dikembalikan;
  bool get isSuccess => _isSuccess;
  bool get isLoading => _isLoading;
  Color get colorText => _colorText;
  UserModel get user => _user!;
  BukuModel get buku => _buku!;

  List<PeminjamanModel> get bukuDipinjam => _bukuDipinjam;

  getToken(
      token, List<BukuModel> buku, List<UserModel> user, userId, userRole) {
    _token = token;
    _userId = userId;
    _userRole = userRole;
    _dataUser = user;
    _dataBuku = buku;
    notifyListeners();
  }

  getPeminjaman() async {
    _isLoading = true;
    try {
      Response response = await _dio.get(
        '${GLobalVar.api}peminjaman/all',
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        List peminjaman = data['data']['peminjaman'];
        _isSuccess = true;
        _isLoading = false;
        _dipinjam = 0;
        _dikembalikan = 0;
        _dataPeminjaman.clear();
        peminjaman.forEach(
          (p) {
            _user = UserModel(
              id: p['member']['id'],
              name: p['member']['name'],
              username: p['member']['username'],
              email: p['member']['email'],
              role: 'Member',
            );
            _buku = BukuModel(
              id: p['book']['id'],
              kodeBuku: p['book']['kode_buku'],
              categoryId: p['book']['category_id'],
              judul: p['book']['judul'],
              slug: p['book']['slug'],
              penerbit: p['book']['penerbit'],
              pengarang: p['book']['pengarang'],
              tahun: p['book']['tahun'],
              stok: p['book']['stok'],
            );
            if (_userRole == 'admin' || int.parse(_userId!) == p['id_member']) {
              _dataPeminjaman.add(
                PeminjamanModel(
                  id: p['id'],
                  idBuku: p['id_buku'],
                  idMember: p['id_member'],
                  tanggalPeminjaman: p['tanggal_peminjaman'],
                  tanggalPengembalian: p['tanggal_pengembalian'],
                  status: p['status'],
                  buku: buku,
                  member: user,
                ),
              );
              if (p['status'] == '2') {
                _dipinjam++;
              } else if (p['status'] == '3') {
                _dikembalikan++;
              }
            }

          },
        );
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
      // log(data.toString());
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  getPeminjamanPaginate(int page, int perPage) async {
    String url = '${GLobalVar.api}peminjaman?page=$page&per_page=$perPage';
    try {
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );
      var data = response.data;
      if (data['status'] == 200) {
        List dataPinjam = data['data']['peminjaman']['data'];
        log(jsonEncode(dataPinjam));
        _listPeminjaman.clear();
        dataPinjam.forEach(
          (p) {
            _user = UserModel(
              id: p['member']['id'],
              name: p['member']['name'],
              username: p['member']['username'],
              email: p['member']['email'],
              role: 'Member',
            );
            _buku = BukuModel(
              id: p['book']['id'],
              kodeBuku: p['book']['kode_buku'],
              categoryId: p['book']['category_id'],
              judul: p['book']['judul'],
              slug: p['book']['slug'],
              penerbit: p['book']['penerbit'],
              pengarang: p['book']['pengarang'],
              tahun: p['book']['tahun'],
              stok: p['book']['stok'],
            );
            if (_userRole == 'admin' || int.parse(_userId!) == p['id_member']) {
              _listPeminjaman.add(
                PeminjamanModel(
                  id: p['id'],
                  idBuku: p['id_buku'],
                  idMember: p['id_member'],
                  tanggalPeminjaman: p['tanggal_peminjaman'],
                  tanggalPengembalian: p['tanggal_pengembalian'],
                  status: p['status'],
                  buku: buku,
                  member: user,
                ),
              );
            }
          },
        );
        notifyListeners();
        return listPeminjaman;
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  getStatusPeminjaman(status, date) {
    var dateNow = DateTime.now();
    var datePengembalian = DateTime.parse(date)
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
    if (dateNow.isBefore(datePengembalian)) {
      if (status == "3") {
        _colorText = Colors.white;
        return "Dikembalikan";
      } else if (status == "2") {
        _colorText = Colors.white;
        return "Dipinjam";
      } else if (status == "1") {
        _colorText = Colors.black;
        return "Diproses";
      }
    } else if (status == "2") {
      _colorText = Colors.white;
      return "Terlambat";
    } else {
      return "No Accept";
    }
  }

  getStatusDate(date) {
    var dateNow = DateTime.now();
    var datePengembalian = DateTime.parse(date)
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
    if (dateNow.isBefore(datePengembalian)) {
      return false;
    } else {
      return true;
    }
  }

  getColor(status, date) {
    var dateNow = DateTime.now();
    var datePengembalian = DateTime.parse(date)
        .add(const Duration(hours: 23, minutes: 59, seconds: 59));
    if (dateNow.isBefore(datePengembalian)) {
      if (status == "3") {
        return Colors.grey;
      } else if (status == "2") {
        return Colors.green.shade600;
      } else if (status == "1") {
        return Colors.amber;
      }
    } else if (status == "2") {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  pinjamBuku(member, buku) async {
    _isLoading = true;
    var dataForm = FormData.fromMap({
      'tanggal_peminjaman': null,
      'tanggal_pengembalian': null,
    });
    try {
      Response response = await _dio.post(
        "${GLobalVar.api}peminjaman/book/$buku/member/$member",
        data: dataForm,
        options: Options(
          headers: {
            "Content-Type":
                "multipart/form-data; boundary=<calculated when request is sent>",
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 201) {
        _isLoading = false;
        _isSuccess = true;
        getPeminjaman();
        notifyListeners();
        return data['message'];
      } else {
        _isLoading = false;
        _isSuccess = false;
        notifyListeners();
        return data['message'];
      }
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
      return e.toString();
    }
  }

  acceptPinjamBuku(id) async {
    _isLoading = true;
    try {
      Response response = await _dio.get(
        "${GLobalVar.api}peminjaman/book/$id/accept",
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        _isLoading = false;
        _isSuccess = true;
        getPeminjaman();
        notifyListeners();
      } else {
        _isLoading = false;
        _isSuccess = false;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  returnPinjamBuku(id) async {
    _isLoading = true;
    var dataForm = FormData.fromMap({
      'tanggal_pengembalian': null,
    });
    try {
      Response response = await _dio.post(
        "${GLobalVar.api}peminjaman/book/$id/return",
        data: dataForm,
        options: Options(
          headers: {
            "Content-Type":
                "multipart/form-data; boundary=<calculated when request is sent>",
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        _isSuccess = true;
        getPeminjaman();
        notifyListeners();
      } else {
        _isSuccess = false;
        notifyListeners();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _isSuccess = false;
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }
}
