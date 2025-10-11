import 'package:flutter/material.dart';


enum UserType { tea, caregiver }

class AuthController with ChangeNotifier {
  String? _loggedInUserEmail;
  UserType? _userType; 
  bool _isLoading = false;

  String? get loggedInUserEmail => _loggedInUserEmail;
  UserType? get userType => _userType;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _loggedInUserEmail != null;

  void setUserType(UserType type) {
    _userType = type;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.length >= 6) {
      _loggedInUserEmail = email;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.length >= 6) {
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> recoverPassword(String email) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    if (email.contains('@')) {
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _loggedInUserEmail = null;
    _userType = null;
    notifyListeners();
  }
}