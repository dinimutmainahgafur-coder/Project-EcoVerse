import 'package:flutter/material.dart';
import '../models/mission.dart';

class JournalProvider extends ChangeNotifier {
  final List<Mission> _completedMissions = [];
  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  List<Mission> get completedMissions =>
      _searchQuery.isEmpty && _selectedCategory == 'Semua'
          ? _completedMissions
          : _filteredMissions;
  int get totalPoints =>
      _completedMissions.fold(0, (sum, m) => sum + m.point);
  String get selectedCategory => _selectedCategory;

  List<Mission> get _filteredMissions {
    return _completedMissions.where((mission) {
      final matchesCategory = _selectedCategory == 'Semua' ||
          mission.category == _selectedCategory;
      final matchesSearch =
          mission.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  /// Tambah misi yang selesai ke journal
  void addCompletedMission(Mission mission) {
    if (!_completedMissions.any((m) => m.id == mission.id)) {
      _completedMissions.insert(0, mission);
      notifyListeners();
    }
  }

  /// Filter berdasarkan kategori
  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Search journal
  void searchJournal(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
