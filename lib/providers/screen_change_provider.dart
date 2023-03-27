import 'dart:developer';

import 'package:flutter/cupertino.dart';

class ScreenChangeProvider with ChangeNotifier {
  bool _passwordVisible = true;
  bool _confirmPasswordVisible = true;
  String _nameError = 'kosong';
  String _usernameError = 'kosong';
  String _emailError = 'kosong';
  String _passwordError = 'kosong';
  String _confirmPasswordError = 'kosong';

  bool get password => _passwordVisible;
  bool get consfirmPassword => _confirmPasswordVisible;
  String get nameError => _nameError;
  String get usernameError => _usernameError;
  String get emailError => _emailError;
  String get passwordError => _passwordError;
  String get confirmPasswordError => _confirmPasswordError;

  void changePassword() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  void getMessage(
    name,
    username,
    email,
    password,
    confirmPassword,
  ) {
    _nameError = name;
    _usernameError = username;
    _emailError = email;
    _passwordError = password;
    _confirmPasswordError = confirmPassword;
    log(nameError);
    log(usernameError);
    log(emailError);
    notifyListeners();
  }

  void changeConfirmPassword() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }
}
