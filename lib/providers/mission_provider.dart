import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../services/api_service.dart';

class MissionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Mission> _missions = [];
  List<Mission> _filteredMissions = [];
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;

  List<Mission> get missions =>
      _searchQuery.isEmpty && _selectedCategory == 'Semua'
          ? _missions
          : _filteredMissions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  /// Mengambil semua misi dari API
  Future<void> fetchMissions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _missions = await _apiService.getMissions();
      _filteredMissions = List.from(_missions);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter misi berdasarkan kategori
  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// Search misi berdasarkan judul
  void searchMissions(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Apply semua filter
  void _applyFilters() {
    _filteredMissions = _missions.where((mission) {
      final matchesCategory =
          _selectedCategory == 'Semua' || mission.category == _selectedCategory;
      final matchesSearch =
          mission.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              mission.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
    notifyListeners();
  }

  /// Update status misi
  Future<void> updateMissionStatus(String id, String status) async {
    try {
      final updated = await _apiService.updateMissionStatus(id, status);
      final index = _missions.indexWhere((m) => m.id == id);
      if (index != -1) {
        _missions[index] = updated;
        _applyFilters();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Refresh data misi
  Future<void> refreshMissions() async {
    await fetchMissions();
  }
}
