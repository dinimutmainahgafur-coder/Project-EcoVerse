class EcoConstants {
  EcoConstants._();

  // ================= APP =================

  static const String appName = 'EcoVerse';
  static const String tagline = 'Small Actions, Big Impact';

  // ================= BASE URL =================

  /// Mission API
  static const String baseUrl =
      'https://6a44fe22aab3faec3f692f84.mockapi.io';

  /// User API
  static const String usersBaseUrl =
      'https://6a44fe22aab3faec3f692f84.mockapi.io';

  /// Journal API
  static const String journalBaseUrl =
      'https://6a4e1b6de785c9ef536c4cb6.mockapi.io';

  // ================= ENDPOINT =================

  static const String missionsEndpoint = '/missions';
  static const String usersEndpoint = '/users';
  static const String journalEndpoint = '/journal';

  // ================= MISSION CATEGORY =================

  static const List<String> missionCategories = [
    'Semua',
    'Daily Mission',
    'Sampah',
    'Air',
    'Energi',
    'Plastik',
  ];

  static const List<String> academyCategories = [
    'Semua',
    'Sampah',
    'Air',
    'Energi',
    'Plastik',
  ];

  static const List<String> badgeList = [
    'Pemula Hijau',
    'Pejuang Bumi',
    'Eco Warrior',
    'Planet Guardian',
    'Legend of Earth',
  ];

  static const Map<int, String> levelMap = {
    1: 'Pemula Hijau',
    5: 'Pejuang Bumi',
    10: 'Eco Warrior',
    20: 'Planet Guardian',
    50: 'Legend of Earth',
  };
}