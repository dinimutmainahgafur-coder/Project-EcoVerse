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
  final String _journalBaseUrl = EcoConstants.journalBaseUrl;

  // =====================================================
  // MISSIONS
  // =====================================================

  Future<List<Mission>> getMissions() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl${EcoConstants.missionsEndpoint}',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((json) => Mission.fromJson(json))
            .toList();
      }

      throw Exception(
          'Gagal memuat misi (${response.statusCode})');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Mission> getMissionById(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_baseUrl${EcoConstants.missionsEndpoint}/$id',
        ),
      );

      if (response.statusCode == 200) {
        return Mission.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception('Mission tidak ditemukan');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Mission> updateMissionStatus(
    String id,
    String status,
  ) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$_baseUrl${EcoConstants.missionsEndpoint}/$id',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        return Mission.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception('Gagal update status');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Mission> createMission(
    Mission mission,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$_baseUrl${EcoConstants.missionsEndpoint}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          mission.toJson(),
        ),
      );

      if (response.statusCode == 201) {
        return Mission.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception('Gagal membuat mission');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<void> deleteMission(String id) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '$_baseUrl${EcoConstants.missionsEndpoint}/$id',
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal menghapus mission');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // =====================================================
  // JOURNAL
  // =====================================================

  Future<List<Mission>> getJournal() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_journalBaseUrl${EcoConstants.journalEndpoint}',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((json) => Mission.fromJson(json))
            .toList();
      }

      throw Exception(
          'Gagal memuat journal (${response.statusCode})');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<Mission> getJournalById(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_journalBaseUrl${EcoConstants.journalEndpoint}/$id',
        ),
      );

      if (response.statusCode == 200) {
        return Mission.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception('Journal tidak ditemukan');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // =====================================================
  // USERS
  // =====================================================

  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_usersBaseUrl${EcoConstants.usersEndpoint}',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data
            .map((json) => User.fromJson(json))
            .toList();
      }

      throw Exception(
          'Gagal memuat users (${response.statusCode})');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<User> getUserById(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$_usersBaseUrl${EcoConstants.usersEndpoint}/$id',
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception('User tidak ditemukan');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<User?> loginUser(
    String email,
    String password,
  ) async {
    try {
      final users = await getUsers();

      for (final user in users) {
        if (user.email == email) {
          return user;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<User> registerUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$_usersBaseUrl${EcoConstants.usersEndpoint}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          user.toJson(),
        ),
      );

      if (response.statusCode == 201) {
        return User.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception('Gagal register user');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<User> updateUser(User user) async {
    try {
      final response = await http.put(
        Uri.parse(
          '$_usersBaseUrl${EcoConstants.usersEndpoint}/${user.id}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          user.toJson(),
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(
          jsonDecode(response.body),
        );
      }

      throw Exception('Gagal update user');
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}