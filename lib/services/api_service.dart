import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';
import '../models/mission.dart';
import '../models/user.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final String _baseUrl = EcoConstants.baseUrl;
  final String _usersBaseUrl = EcoConstants.usersBaseUrl;

  // ==================== MISSIONS ====================

  /// Mengambil semua misi dari MockAPI
  Future<List<Mission>> getMissions() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl${EcoConstants.missionsEndpoint}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Mission.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat misi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Mengambil misi berdasarkan ID
  Future<Mission> getMissionById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl${EcoConstants.missionsEndpoint}/$id'),
      );

      if (response.statusCode == 200) {
        return Mission.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat detail misi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Mengupdate status misi
  Future<Mission> updateMissionStatus(String id, String status) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl${EcoConstants.missionsEndpoint}/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        return Mission.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal update status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Membuat misi baru
  Future<Mission> createMission(Mission mission) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl${EcoConstants.missionsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(mission.toJson()),
      );

      if (response.statusCode == 201) {
        return Mission.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal membuat misi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Menghapus misi
  Future<void> deleteMission(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl${EcoConstants.missionsEndpoint}/$id'),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus misi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // ==================== USERS ====================

  /// Mengambil semua users dari MockAPI
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$_usersBaseUrl${EcoConstants.usersEndpoint}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Mengambil user berdasarkan ID
  Future<User> getUserById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_usersBaseUrl${EcoConstants.usersEndpoint}/$id'),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal memuat user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Login user berdasarkan email
  Future<User?> loginUser(String email, String password) async {
    try {
      final users = await getUsers();
      for (var user in users) {
        if (user.email == email) {
          return user;
        }
      }
      return null;
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Register user baru ke MockAPI
  Future<User> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$_usersBaseUrl${EcoConstants.usersEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 201) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal register user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  /// Update data user di MockAPI
  Future<User> updateUser(User user) async {
    try {
      final response = await http.put(
        Uri.parse('$_usersBaseUrl${EcoConstants.usersEndpoint}/${user.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        throw Exception('Gagal update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
