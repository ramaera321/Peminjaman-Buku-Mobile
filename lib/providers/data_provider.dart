import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpustakaan/models/film_model.dart';
import 'package:perpustakaan/models/kategori_film_model.dart';

class DataProvider with ChangeNotifier {
  List<FilmModel> _data = [];
  List<FilmModel> _data2 = [];
  List<FilmKategoriModel> _kategori = [];
  List<FilmKategoriModel> _dataCategory = [];
  List<FilmKategoriModel> _kategoriFilter = [];

  List<FilmModel> get data => _data;
  List<FilmModel> get data2 => _data2;
  List<FilmKategoriModel> get kategori => _kategori;
  List<FilmKategoriModel> get dataCategory => _dataCategory;
  List<FilmKategoriModel> get kategoriFilter => _kategoriFilter;

  String? dropdownValue = null;

  void addData(FilmModel data) {
    log(jsonEncode(data));
    _data.add(data);
    notifyListeners();
  }

  void filterCategory(String? data) {
    _dataCategory.clear();
    _dataCategory.addAll(_kategori);
    if (data != "semua") {
      _dataCategory = _dataCategory
        ..removeWhere((element) => element.id != data);
    }
    // log(jsonEncode(_dataCategory));
    notifyListeners();
  }

  void selectDropdown({required String value}) {
    dropdownValue = value;
    notifyListeners();
  }

  void addAllCategory() {
    _dataCategory.clear();
    _data2.clear();
    _dataCategory.addAll(_kategori);
    _data2.addAll(_data);
    notifyListeners();
  }

  void removeData(FilmModel data) {
    // _data = _data.where((element) => element.id != data.id).toList();
    _data = _data..removeWhere((element) => element.id == data.id);
    print(_data);
    notifyListeners();
  }

  void updateData(FilmModel data) {
    _data[_data.indexWhere((element) => element.id == data.id)] = data;
    notifyListeners();
  }

  void addKategori(FilmKategoriModel kategori) {
    if (_kategoriFilter.isEmpty) {
      _kategoriFilter.add(FilmKategoriModel(id: "semua", kategori: "Semua"));
    }
    _kategoriFilter.add(kategori);
    _kategori.add(kategori);
    notifyListeners();
  }

  void removeKategori(FilmKategoriModel kategori) {
    _kategori = _kategori..removeWhere((element) => element.id == kategori.id);
    _dataCategory = _dataCategory
      ..removeWhere((element) => element.id == kategori.id);
    _kategoriFilter = _kategoriFilter
      ..removeWhere((element) => element.id == kategori.id);
    _data = _data..removeWhere((element) => element.kategori == kategori.id);
    notifyListeners();
  }

  void updateKategori(FilmKategoriModel kategori) {
    _kategori[_kategori.indexWhere((element) => element.id == kategori.id)] =
        kategori;
    _kategoriFilter[_kategoriFilter
        .indexWhere((element) => element.id == kategori.id)] = kategori;
    notifyListeners();
  }
}
