class EcoConstants {
  EcoConstants._();

  static const String appName = 'EcoVerse';
  static const String tagline = 'Small Actions, Big Impact';

  static const String baseUrl = 'https://68641c815b5a44b38edc8962.mockapi.io';

  static const String missionsEndpoint = '/missions';
  static const String usersEndpoint = '/users';

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
