import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? get currentUser => _authService.currentUser;
  bool get isLoggedIn => _authService.isLoggedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Login user
  Future<bool> login(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(name, email, password);

    _isLoading = false;
    notifyListeners();
    return result;
  }

  /// Register user
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(name, email, password);

    _isLoading = false;
    notifyListeners();
    return result;
  }

  /// Load user dari storage
  Future<bool> loadUser() async {
    final result = await _authService.loadUser();
    notifyListeners();
    return result;
  }

  /// Update data user
  Future<void> updateUser(User user) async {
    await _authService.updateUser(user);
    notifyListeners();
  }

  /// Tambah eco point
  Future<void> addEcoPoint(int points) async {
    await _authService.addEcoPoint(points);
    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}
