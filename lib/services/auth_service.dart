import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Login user dan simpan data ke SharedPreferences
  Future<bool> login(String name, String email, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        username: name.toLowerCase().replaceAll(' ', '_'),
        level: 1,
        ecoPoint: 0,
        xp: 0,
        maxXp: 100,
        badges: ['Pemula Hijau'],
      );

      await prefs.setString(_userKey, json.encode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);

      _currentUser = user;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Register user baru
  Future<bool> register(String name, String email, String password) async {
    return login(name, email, password);
  }

  /// Load user dari SharedPreferences
  Future<bool> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;

      if (!isLoggedIn) return false;

      final userData = prefs.getString(_userKey);
      if (userData != null) {
        _currentUser = User.fromJson(json.decode(userData));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Update data user
  Future<void> updateUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentUser = user;
      await prefs.setString(_userKey, json.encode(user.toJson()));
    } catch (e) {
      rethrow;
    }
  }

  /// Tambah Eco Point
  Future<void> addEcoPoint(int points) async {
    if (_currentUser == null) return;

    final newXp = _currentUser!.xp + points;
    var newLevel = _currentUser!.level;
    var remainingXp = newXp;

    if (newXp >= _currentUser!.maxXp) {
      remainingXp = newXp - _currentUser!.maxXp;
      newLevel += 1;
    }

    final updatedUser = _currentUser!.copyWith(
      ecoPoint: _currentUser!.ecoPoint + points,
      xp: remainingXp,
      level: newLevel,
    );

    await updateUser(updatedUser);
  }

  /// Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
    _currentUser = null;
  }
}
