import 'package:flutter/material.dart';

class LeaderboardProvider extends ChangeNotifier {
  String _selectedFilter = 'Semua';
  String get selectedFilter => _selectedFilter;

  final List<Map<String, dynamic>> _leaderboardData = [
    {'rank': 1, 'name': 'Andi Saputra', 'avatar': '', 'point': 2500, 'level': 15, 'badges': 8},
    {'rank': 2, 'name': 'Budi Santoso', 'avatar': '', 'point': 2200, 'level': 13, 'badges': 7},
    {'rank': 3, 'name': 'Citra Dewi', 'avatar': '', 'point': 1950, 'level': 12, 'badges': 6},
    {'rank': 4, 'name': 'Dian Permata', 'avatar': '', 'point': 1700, 'level': 11, 'badges': 5},
    {'rank': 5, 'name': 'Eka Wulandari', 'avatar': '', 'point': 1500, 'level': 10, 'badges': 5},
    {'rank': 6, 'name': 'Fajar Nugroho', 'avatar': '', 'point': 1300, 'level': 9, 'badges': 4},
    {'rank': 7, 'name': 'Gita Sari', 'avatar': '', 'point': 1100, 'level': 8, 'badges': 4},
    {'rank': 8, 'name': 'Hendra Kusuma', 'avatar': '', 'point': 950, 'level': 7, 'badges': 3},
    {'rank': 9, 'name': 'Indah Lestari', 'avatar': '', 'point': 800, 'level': 6, 'badges': 3},
    {'rank': 10, 'name': 'Joko Pratama', 'avatar': '', 'point': 650, 'level': 5, 'badges': 2},
  ];

  List<Map<String, dynamic>> get leaderboardData => _leaderboardData;

  List<Map<String, dynamic>> get podiumData =>
      _leaderboardData.take(3).toList();

  /// Filter leaderboard
  void filterLeaderboard(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }
}
