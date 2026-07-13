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
        // Mengambil properti langsung dari objek User (anti-typo)
        final int userPoint = user.ecoPoint; 
        final int userLevel = user.level;

        return {
          'id': user.id,
          'name': user.name,
          'point': userPoint,
          'level': userLevel, 
        };
      }).toList();

      filterLeaderboard(_selectedFilter);
    } catch (e) {
      debugPrint("Error fetching leaderboard: $e");
    } finally { 
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

    // Mengurutkan poin dari yang TERBESAR ke TERKECIL
    _filteredData.sort((a, b) => (b['point'] as int).compareTo(a['point'] as int));

    // Membuat penomoran peringkat (#1, #2, #3, dst) berdasarkan urutan poin terbaru
    for (int i = 0; i < _filteredData.length; i++) {
      _filteredData[i]['rank'] = i + 1;
    }

    notifyListeners();
  }
}