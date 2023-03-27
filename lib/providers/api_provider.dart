import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:perpustakaan/global/my_global.dart';
import 'package:perpustakaan/main.dart';
import 'package:perpustakaan/models/pagination_model.dart';
import 'package:perpustakaan/models/user_model.dart';
import 'package:perpustakaan/pages/dashboard.dart';
import 'package:perpustakaan/pages/login_page.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ApiProvider with ChangeNotifier {
  final Dio _dio = Dio();
  List<UserModel> _dataMember = [];
  List<UserModel> _dataUser = [];
  bool _isSuccess = false;
  bool _isLoading = false;
  bool _isNull = false;
  String? _token, _userId, _roleUser, _name, _email;
  String _nameError = 'kosong';
  String _usernameError = 'kosong';
  String _emailError = 'kosong';
  String _passwordError = 'kosong';
  String _confirmPasswordError = 'kosong';

  List<UserModel> get dataMember => _dataMember;
  List<UserModel> get dataUser => _dataUser;
  bool get isSuccess => _isSuccess;
  bool get isLoading => _isLoading;
  bool get isNull => _isNull;
  String get idToken => _token!;
  String get userId => _userId!;
  String get roleUser => _roleUser!;
  String get name => _name!;
  String get email => _email!;
  String get nameError => _nameError;
  String get usernameError => _usernameError;
  String get emailError => _emailError;
  String get passwordError => _passwordError;
  String get confirmPasswordError => _confirmPasswordError;

  // variabel pagination
  List<PaginationModel> _dataPaginations = [];
  int _currentPage = 0;
  List<PaginationModel> get dataPaginations => _dataPaginations;
  int get currentPage => _currentPage;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return _token!;
    } else {
      return null;
    }
  }

  login(String username, String password) async {
    _isLoading = true;
    _isSuccess = false;
    var dataForm = FormData.fromMap({
      'username': username,
      'password': password,
    });
    try {
      Response response =
          await _dio.post('${GLobalVar.api}login', data: dataForm);
      var data = response.data['data'];
      log(data.toString());

      if (response.statusCode == 200) {
        _isSuccess = true;
        _isLoading = false;

        _token = (data['token']).toString();
        _userId = (data['user']['id']).toString();
        _roleUser = (data['user']['roles'][0]['name']).toString();
        _name = (data['user']['name']).toString();
        _email = (data['user']['email']).toString();
        // log(_token.toString());
        notifyListeners();
      } else if (response.statusCode == 500) {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      }

      // log(response.toString());

      // log(idToken);
      // log(data['token'].toString());
      notifyListeners();
    } catch (e) {
      // throw Exception(e.toString());
      _isSuccess = false;
      _isLoading = false;
      log('gagal');
      log(e.toString());
      log(isSuccess.toString());
      log(isLoading.toString());
      notifyListeners();
    }
    log(isSuccess.toString());
  }

  register(String name, String username, String email, String password,
      String confirmPassword) async {
    _isLoading = true;
    _isSuccess = false;
    var dataForm = FormData.fromMap({
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    });
    try {
      Response response =
          await _dio.post('${GLobalVar.api}register', data: dataForm);

      var data = response.data;

      if (data['status'] == 200) {
        _isSuccess = true;
        _isLoading = false;
        notifyListeners();
      } else if (data['status'] == 500) {
        _isSuccess = false;
        _isLoading = false;
        notifyListeners();
      } else if (data['status'] == 409) {
        _isSuccess = false;
        _isLoading = false;
        _nameError = data['message']['name'] != null
            ? data['message']['name']!
            : 'kosong';
        _usernameError = data['message']['username'] != null
            ? data['message']['username']!
            : 'kosong';
        _emailError = data['message']['email'] != null
            ? data['message']['email']!
            : 'kosong';
        _passwordError = data['message']['password'] != null
            ? data['message']['password']!
            : 'kosong';
        _confirmPasswordError = data['message']['confirm_password'] != null
            ? data['message']['confirm_password']!
            : 'kosong';
        log(confirmPasswordError);
        notifyListeners();
      }

      // log(data.toString());
      notifyListeners();
    } catch (e) {
      // throw Exception(e.toString());
      _isSuccess = false;
      _isLoading = false;
      log('gagal');
      log(e.toString());
      log(isSuccess.toString());
      log(isLoading.toString());
      notifyListeners();
    }
    // log(isSuccess.toString());
  }

  logout(context) async {
    _isLoading = true;
    _isSuccess = false;
    notifyListeners();

    log(idToken);
    try {
      Response response = await _dio.get(
        '${GLobalVar.api}logout',
        options: Options(
          headers: {
            "Accept": "application/json",
            "Authorization": "Bearer $idToken"
          },
        ),
      );
      var data = response.data;
      // log(data.toString());
      if (data != null) {
        if (data['status'] == 200) {
          _isSuccess = true;
          _isLoading = false;
          // _token = null;
          // _userId = null;
          // _roleUser = null;
          // _name = null;
          // _email = null;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: ((context) => const MyApp()),
            ),
          );
        } else if (data['status'] == 500) {
          _isSuccess = false;
          _isLoading = false;
        }
      }
      // log(data['message'].toString());
      notifyListeners();
      // log(response.data.message);
    } catch (e) {
      _isSuccess = false;
      _isLoading = false;
      log('gagal');
      log(e.toString());
      log(isSuccess.toString());
      log(isLoading.toString());
      notifyListeners();
    }
  }

  getMembers([url = '${GLobalVar.api}user/member/all']) async {
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
        List member = data['data']['users']['data'];
        dataMember.clear();
        member.forEach((m) {
          _dataMember.add(UserModel(
              id: m['id'],
              name: m['name'],
              username: m['username'],
              email: m['email'],
              role: 'member'));
        });

        List dataPaginate = data['data']['users']['links'];
        _dataPaginations.clear();
        dataPaginate.forEach((p) {
          _dataPaginations.add(
            PaginationModel(
                url: p['url'], label: p['label'], active: p['active']),
          );
        });
        _currentPage = data['data']['users']['current_page'];
        // log(jsonEncode(dataMember));
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
      log("gagal");
      log(e.toString());
      notifyListeners();
    }
  }

  // getUsers() async {
  //   try {
  //     Response response = await _dio.get(
  //       '${GLobalVar.api}user/all',
  //       options: Options(
  //         headers: {
  //           "Accept": "*/*",
  //           "Authorization": "Bearer $idToken",
  //         },
  //       ),
  //     );

  //     var data = response.data;
  //     if (data['status'] == 200) {
  //       List member = data['data']['users'];
  //       dataMember.clear();
  //       member.forEach((m) {
  //         _dataMember.add(UserModel(
  //             id: m['id'],
  //             name: m['name'],
  //             username: m['username'],
  //             email: m['email'],
  //             role: 'member'));
  //       });
  //       // log(jsonEncode(dataMember));
  //       _isSuccess = true;
  //       _isLoading = false;
  //     } else {
  //       _isSuccess = false;
  //       _isLoading = false;
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     log("gagal");
  //     log(e.toString());
  //     notifyListeners();
  //   }
  // }
}
