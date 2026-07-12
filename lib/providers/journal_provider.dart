import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../services/api_service.dart';

class JournalProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Mission> _completedMissions = [];

  bool _isLoading = false;

  String _searchQuery = '';
  String _selectedCategory = 'Semua';

  // ================= GETTER =================

  bool get isLoading => _isLoading;

  String get selectedCategory => _selectedCategory;

  List<Mission> get completedMissions {
    List<Mission> data = List.from(_completedMissions);

    // FIX: Menggunakan toLowerCase() agar tidak error jika API mengembalikan huruf kecil
    if (_selectedCategory != 'Semua') {
      data = data.where((m) {
        return m.category.toLowerCase() == _selectedCategory.toLowerCase();
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      data = data.where((m) {
        return m.title
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()) ||
            m.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return data;
  }

  int get totalPoints =>
      _completedMissions.fold(
        0,
        (sum, m) => sum + m.point,
      );

  // ================= LOAD MOCK API =================

  Future<void> fetchJournal() async {
    _isLoading = true;
    notifyListeners();

    try {
      _completedMissions = await _apiService.getJournal();
    } catch (e) {
      debugPrint(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshJournal() async {
    await fetchJournal();
  }

  // ================= TAMBAH DARI MISSION =================

  void addCompletedMission(Mission mission) {
    final index = _completedMissions.indexWhere(
      (m) => m.id == mission.id,
    );

    if (index == -1) {
      _completedMissions.insert(0, mission);
    } else {
      _completedMissions[index] = mission;
    }

    notifyListeners();
  }

  // ================= FILTER =================

  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ================= SEARCH =================

  void searchJournal(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ================= RESET =================

  void resetFilter() {
    _selectedCategory = 'Semua';
    _searchQuery = '';
    notifyListeners();
  }

  // ================= CLEAR =================

  void clearJournal() {
    _completedMissions.clear();
    notifyListeners();
  }

  // ================= GET BY ID =================

  Mission? getJournalById(String id) {
    try {
      return _completedMissions.firstWhere(
        (m) => m.id == id,
      );
    } catch (_) {
      return null;
    }
  }
}