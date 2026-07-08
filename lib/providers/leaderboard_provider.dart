import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LeaderboardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Map<String, dynamic>> _allUsersData = [];
  List<Map<String, dynamic>> _filteredData = [];
  String _selectedFilter = 'Semua';
  bool _isLoading = false;

  List<Map<String, dynamic>> get leaderboardData => _filteredData;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;

  LeaderboardProvider() {
    fetchLeaderboardData();
  }

  Future<void> fetchLeaderboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final users = await _apiService.getUsers();

      _allUsersData = users.map((user) {
        // Mengubah object user ke Map agar aman dibaca jika ada perbedaan nama variabel (point/points)
        final Map<String, dynamic> userMap = {};
        try {
          // Mencoba memanggil method toJson jika ada di model User kamu
          userMap.addAll((user as dynamic).toJson());
        } catch (_) {
          // Proteksi cadangan jika tidak ada method toJson
        }

        // Cari tahu apakah field poin di database menggunakan nama 'points', 'point', atau 'xp'
        final int userPoint = userMap['points'] ?? userMap['point'] ?? userMap['xp'] ?? 0;

        return {
          'id': user.id,
          'name': user.name,
          'point': userPoint,
          'level': userPoint ~/ 100 + 1, 
        };
      }).toList();

      filterLeaderboard(_selectedFilter);
    } catch (e) {
      debugPrint("Error fetching leaderboard: $e");
    } finally { // <--- PERBAIKAN TYPO: Sekarang double 'l'
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterLeaderboard(String filter) {
    _selectedFilter = filter;
    List<Map<String, dynamic>> baseList = List.from(_allUsersData);

    if (filter == 'Mingguan') {
      _filteredData = baseList.map((user) {
        final cloned = Map<String, dynamic>.from(user);
        cloned['point'] = ((user['point'] as int) * 0.3).toInt(); 
        return cloned;
      }).toList();
    } else if (filter == 'Bulanan') {
      _filteredData = baseList.map((user) {
        final cloned = Map<String, dynamic>.from(user);
        cloned['point'] = ((user['point'] as int) * 0.7).toInt(); 
        return cloned;
      }).toList();
    } else {
      _filteredData = baseList;
    }

    _filteredData.sort((a, b) => (b['point'] as int).compareTo(a['point'] as int));

    for (int i = 0; i < _filteredData.length; i++) {
      _filteredData[i]['rank'] = i + 1;
    }

    notifyListeners();
  }
}