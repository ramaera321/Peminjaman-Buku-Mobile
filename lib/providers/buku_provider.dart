import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/models/buku_model.dart';
import 'package:perpustakaan/models/kategori_buku_model.dart';
import 'package:perpustakaan/models/pagination_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BookProvider with ChangeNotifier {
  final Dio _dio = Dio();
  String? _token;
  List<BookKategoriModel> _kategoriBuku = [];
  List<BukuModel> _buku = [];
  List<BukuModel> _listBuku = [];
  bool _isSuccess = false;
  bool _isLoading = false;

  String? get idToken => _token;
  List<BookKategoriModel> get kategoriBuku => _kategoriBuku;
  List<BukuModel> get buku => _buku;
  List<BukuModel> get listBuku => _listBuku;
  bool get isSuccess => _isSuccess;
  bool get isLoading => _isLoading;

  //data pagination
  List<PaginationModel> _dataPaginations = [];
  List<BookKategoriModel> _listKategori = [];
  int _currentPage = 1;
  int _lastPageBook = 0;
  int _currentPageBook = 1;
  List<BookKategoriModel> get listKategori => _listKategori;
  List<PaginationModel> get dataPaginations => _dataPaginations;
  int get currentPage => _currentPage;
  int get lastPageBook => _lastPageBook;
  int get currentPageBook => _currentPageBook;

  getToken(token) {
    _token = token;
    notifyListeners();
  }

  paginationKategori(url) async {
    try {
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        List dataCategoryPaginate = data['data']['categories']['data'];
        _listKategori.clear();
        dataCategoryPaginate.forEach((k) {
          _listKategori.add(
            BookKategoriModel(id: k['id'], namaKategori: k['nama_kategori']),
          );
        });
        // get data pagination
        List dataPage = data['data']['categories']['links'];
        _dataPaginations.clear();
        dataPage.forEach((p) {
          _dataPaginations.add(
            PaginationModel(
              url: p['url'],
              label: p['label'],
              active: p['active'],
            ),
          );
        });
        _currentPage = data['data']['categories']['current_page'];
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  getAllKategori() async {
    try {
      Response response = await _dio.get(
        "${GLobalVar.api}category/all/all",
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        // get data kategori (all)
        List dataCategoryAll = data['data']['categories'];
        // log(jsonEncode(dataCategoryAll));
        // for (var i = 0; i < dataCategoryAll.length; i++) {
        //   _kategoriBuku.add(BookKategoriModel(
        //       id: dataCategoryAll[i]['id'],
        //       namaKategori: dataCategoryAll[i]['nama_kategori']));
        // }
        dataCategoryAll.forEach((c) {
          _kategoriBuku.add(
              BookKategoriModel(id: c['id'], namaKategori: c['nama_kategori']));
        });
      }
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  getKategoriBook() async {
    try {
      Response response = await _dio.get('${GLobalVar.api}category/all',
          options: Options(
            headers: {
              "Accept": "application/json",
              "Authorization": "Bearer $idToken"
            },
          ));

      var data = response.data;
      if (data['status'] == 200) {
        _kategoriBuku.clear();
        _kategoriBuku.add(
          BookKategoriModel(id: 0, namaKategori: 'Semua'),
        );
        //get all kategori
        await getAllKategori();
        // get data kategori pagination
        List dataCategoryPaginate = data['data']['categories']['data'];
        _listKategori.clear();
        dataCategoryPaginate.forEach((k) {
          _listKategori.add(
            BookKategoriModel(id: k['id'], namaKategori: k['nama_kategori']),
          );
        });
        // get data pagination
        List dataPage = data['data']['categories']['links'];
        _dataPaginations.clear();
        dataPage.forEach((p) {
          _dataPaginations.add(
            PaginationModel(
              url: p['url'],
              label: p['label'],
              active: p['active'],
            ),
          );
        });
        // log(jsonEncode(dataPaginations));
        _currentPage = data['data']['categories']['current_page'];
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  createKategoriBuku(nama_kategori) async {
    var dataForm = FormData.fromMap({
      'nama_kategori': nama_kategori,
    });

    try {
      Response response = await _dio.post(
        '${GLobalVar.api}category/create',
        data: dataForm,
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );

      var data = response.data;
      // log(data.toString());

      if (data['status'] == 201) {
        getKategoriBook();
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
    }
  }

  updateKategoriBuku(id, String nama_kategori) async {
    var dataForm = FormData.fromMap({
      'nama_kategori': nama_kategori,
    });
    try {
      Response response = await _dio.post(
        '${GLobalVar.api}category/update/$id',
        data: dataForm,
        options: Options(
          headers: {
            "Accept": "*/*",
            "Content-Type": "multipart/form-data;",
            "Authorization": "Bearer $idToken"
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        getKategoriBook();
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  deleteKategoriBuku(int id) async {
    log(id.toString());
    log('${GLobalVar.api}category/$id/delete');
    try {
      Response response = await _dio.delete(
        '${GLobalVar.api}category/$id/delete',
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        getKategoriBook();
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  getBuku() async {
    try {
      Response response = await _dio.get(
        '${GLobalVar.api}book/',
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        _buku.clear();
        List dataBuku = data['data']['books'];
        dataBuku.forEach((data) {
          _buku.add(
            BukuModel(
              id: data['id'],
              kodeBuku: data['kode_buku'],
              categoryId: data['category_id'],
              judul: data['judul'],
              slug: data['slug'],
              penerbit: data['penerbit'],
              pengarang: data['pengarang'],
              tahun: data['tahun'],
              stok: data['stok'],
              path: data['path'],
            ),
          );
        });

        _listBuku = _buku;
        // log(dataBuku.toString());
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  getBukuPaginate(page, perPage,
      [String search = "null", int filter = 0]) async {
    log(search);
    String url = '${GLobalVar.api}book/all?page=$page&per_page=$perPage';
    if (search != "null") {
      url += '&search=$search';
    }
    if (filter != 0) {
      url += '&filter=$filter';
    }
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
        _buku.clear();
        List dataBuku = data['data']['books']['data'];
        dataBuku.forEach((data) {
          _buku.add(
            BukuModel(
              id: data['id'],
              kodeBuku: data['kode_buku'],
              categoryId: data['category_id'],
              judul: data['judul'],
              slug: data['slug'],
              penerbit: data['penerbit'],
              pengarang: data['pengarang'],
              tahun: data['tahun'],
              stok: data['stok'],
              path: data['path'],
            ),
          );
        });

        _lastPageBook = data['data']['books']['last_page'];
        _currentPage = data['data']['books']['current_page'];
        notifyListeners();
        return _buku;
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  getKategoriDetail(int id) {
    return _kategoriBuku[
            _kategoriBuku.indexWhere((element) => element.id == id)]
        .namaKategori;
    // log(id.toString());
  }

  getDetailBuku(id) async {
    _isLoading = true;
    try {
      Response response = await _dio.get(
        '${GLobalVar.api}book/$id',
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        // log(data.toString());
        _isSuccess = true;
        _isLoading = false;
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      log('gagal');
      log(e.toString());
      notifyListeners();
    }
  }

  createBuku(
      judul, kategori, pengarang, penerbit, tahun, stok, File image) async {
    // _isLoading = true;
    log(image.toString());
    var filepicker = await MultipartFile.fromFile(image.path);
    var dataForm = FormData.fromMap({
      'judul': judul,
      'category_id': kategori,
      'pengarang': pengarang,
      'penerbit': penerbit,
      'tahun': tahun,
      'stok': stok,
      'path': filepicker
    });
    // log(judul);
    // log(kategori!);
    // log(pengarang);
    // log(penerbit);
    // log(tahun);
    // log(stok);

    try {
      Response response = await _dio.post(
        '${GLobalVar.api}book/create',
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
        _isSuccess = true;
        _isLoading = false;
        getBuku();
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

  updateBuku(id, judul, kategori, pengarang, penerbit, tahun, stok,
      File? image) async {
    _isLoading = true;
    var filepicker = null;
    if (image != null) {
      filepicker = await MultipartFile.fromFile(image.path);
    }
    var dataForm = FormData.fromMap({
      'judul': judul,
      'category_id': kategori,
      'pengarang': pengarang,
      'penerbit': penerbit,
      'tahun': tahun,
      'stok': stok,
      'path': filepicker
    });
    log(image.toString());
    // log(id);
    // log(judul);
    // log(kategori!);
    // log(pengarang);
    // log(penerbit);
    // log(tahun);
    // log(stok);

    try {
      Response response = await _dio.post(
        '${GLobalVar.api}book/$id/update',
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
        _isLoading = false;
        getBuku();
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
      log(data.toString());

      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  deleteBuku(id) async {
    _isLoading = true;
    try {
      Response response = await _dio.delete(
        '${GLobalVar.api}book/$id/delete',
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      if (data['status'] == 200) {
        _isSuccess = true;
        _isLoading = false;
        getBuku();
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  downloadBukuPdf() async {
    _isLoading = true;
    // log(idToken.toString());
    try {
      Response response = await _dio.get(
        '${GLobalVar.api}book/export/pdf',
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      log(data.toString());
      if (data['status'] == 200) {
        _isSuccess = true;
        _isLoading = false;
        await launch(GLobalVar.base_url + data['path']);
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  downloadBukuExcel() async {
    _isLoading = true;
    try {
      Response response = await _dio.get(
        '${GLobalVar.api}book/export/excel',
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      log(data.toString());
      if (data['status'] == 200) {
        _isSuccess = true;
        _isLoading = false;
        Uri url = Uri.parse(GLobalVar.base_url + data['path']);
        log(url.toString());
        await launch(GLobalVar.base_url + data['path']);
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  downloadTemplateExcel() async {
    _isLoading = true;
    // log(idToken.toString());
    try {
      Response response = await _dio.get(
        '${GLobalVar.api}book/download/template',
        options: Options(
          headers: {
            "Accept": "*/*",
            "Authorization": "Bearer $idToken",
          },
        ),
      );

      var data = response.data;
      // log(data.toString());
      if (data['status'] == 200) {
        _isSuccess = true;
        _isLoading = false;
        await launch(GLobalVar.base_url + data['path']);
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  importBuku(File file) async {
    _isLoading = true;
    var _fileImport = await MultipartFile.fromFile(file.path);
    // log(file.path);
    var dataForm = FormData.fromMap({'file_import': _fileImport});
    try {
      Response response = await _dio.post(
        "${GLobalVar.api}book/import/excel",
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
        _isLoading = false;
        getBuku();
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

  searchKategori(kategori) async {
    var dataFrom = FormData.fromMap({'search': kategori});
    _isLoading = true;
    try {
      Response response = await _dio.post(
        '${GLobalVar.api}category/search',
        data: dataFrom,
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
        log(data.toString());
        List dataSearch = data['data']['categories'];
        _listKategori.clear();
        dataSearch.forEach((k) {
          _listKategori.add(
            BookKategoriModel(
              id: k['id'],
              namaKategori: k['nama_kategori'],
            ),
          );
        });
        _listKategori = _listKategori
          ..removeWhere((element) => element.id == 0);
        log(jsonEncode(_listKategori));
        _isSuccess = true;
        _isLoading = false;
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  searchBuku(buku) async {
    var dataFrom = FormData.fromMap({'search': buku});
    _isLoading = true;
    try {
      Response response = await _dio.post(
        '${GLobalVar.api}book/search',
        data: dataFrom,
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
        log(data.toString());
        List dataSearch = data['data']['books'];
        _listBuku.clear();
        dataSearch.forEach((b) {
          _listBuku.add(
            BukuModel(
              id: b['id'],
              kodeBuku: b['kode_buku'],
              categoryId: b['category_id'],
              judul: b['judul'],
              slug: b['slug'],
              penerbit: b['penerbit'],
              pengarang: b['pengarang'],
              tahun: b['tahun'],
              stok: b['stok'],
              path: b['path'],
            ),
          );
        });
        _isSuccess = true;
        _isLoading = false;
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  filterBuku(category) async {
    _isLoading = true;
    try {
      Response response = await _dio.get(
        '${GLobalVar.api}book/filter/$category',
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
        log(data.toString());
        List dataSearch = data['data']['books'];
        _listBuku.clear();
        dataSearch.forEach((b) {
          _listBuku.add(
            BukuModel(
              id: b['id'],
              kodeBuku: b['kode_buku'],
              categoryId: b['category_id'],
              judul: b['judul'],
              slug: b['slug'],
              penerbit: b['penerbit'],
              pengarang: b['pengarang'],
              tahun: b['tahun'],
              stok: b['stok'],
              path: b['path'],
            ),
          );
        });
        _isSuccess = true;
        _isLoading = false;
        notifyListeners();
      } else {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }
}
