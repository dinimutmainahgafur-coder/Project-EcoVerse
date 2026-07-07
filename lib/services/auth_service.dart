import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();

  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ===========================
  // LOGIN
  // ===========================
  Future<bool> login(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await _apiService.loginUser(
        email.trim(),
        password,
      );

      if (user == null) {
        return false;
      }

      _currentUser = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _userKey,
        jsonEncode(user.toJson()),
      );
      await prefs.setBool(
        _isLoggedInKey,
        true,
      );

      return true;
    } catch (e) {
      debugPrint('Login Error : $e');
      return false;
    }
  }

  // ===========================
  // REGISTER
  // ===========================
  Future<bool> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final users = await _apiService.getUsers();

      final exists = users.any(
        (u) =>
            u.email.toLowerCase() ==
            email.trim().toLowerCase(),
      );

      if (exists) {
        return false;
      }

      final newUser = User(
        id: '',
        name: name.trim(),
        email: email.trim(),
        username: name
            .trim()
            .toLowerCase()
            .replaceAll(' ', '_'),
        password: password,
        level: 1,
        ecoPoint: 0,
        xp: 0,
        maxXp: 100,
        badges: const [
          'Pemula Hijau',
        ],
        avatar: '',
      );

      final registeredUser =
          await _apiService.registerUser(
        newUser,
      );

      _currentUser = registeredUser;

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(
        _userKey,
        jsonEncode(
          registeredUser.toJson(),
        ),
      );

      await prefs.setBool(
        _isLoggedInKey,
        true,
      );

      return true;
    } catch (e) {
      debugPrint('Register Error : $e');
      return false;
    }
  }

  // ===========================
  // LOAD SESSION
  // ===========================
  Future<bool> loadUser() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      final loggedIn =
          prefs.getBool(_isLoggedInKey) ??
              false;

      if (!loggedIn) {
        return false;
      }

      final data =
          prefs.getString(_userKey);

      if (data == null) {
        return false;
      }

      _currentUser =
          User.fromJson(jsonDecode(data));

      return true;
    } catch (e) {
      debugPrint('Load User Error : $e');
      return false;
    }
  }

  // ===========================
  // UPDATE USER
  // ===========================
  Future<void> updateUser(
    User user,
  ) async {
    try {
      final updated =
          await _apiService.updateUser(user);

      _currentUser = updated;

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        _userKey,
        jsonEncode(updated.toJson()),
      );
    } catch (e) {
      debugPrint('Update User Error : $e');
      rethrow;
    }
  }

  // ===========================
  // ADD ECO POINT
  // ===========================
  Future<void> addEcoPoint(
    int points,
  ) async {
    if (_currentUser == null) return;

    int level = _currentUser!.level;
    int xp = _currentUser!.xp + points;

    while (xp >= _currentUser!.maxXp) {
      xp -= _currentUser!.maxXp;
      level++;
    }

    final updatedUser =
        _currentUser!.copyWith(
      ecoPoint:
          _currentUser!.ecoPoint + points,
      xp: xp,
      level: level,
    );

    await updateUser(updatedUser);
  }

  // ===========================
  // LOGOUT
  // ===========================
  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_userKey);

    await prefs.setBool(
      _isLoggedInKey,
      false,
    );

    _currentUser = null;
  }
}