class User {
  final String id;
  final String name;
  final String email;
  final String username;
  final int level;
  final int ecoPoint;
  final int xp;
  final int maxXp;
  final List<String> badges;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    this.level = 1,
    this.ecoPoint = 0,
    this.xp = 0,
    this.maxXp = 100,
    this.badges = const [],
    this.avatar = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      level: json['level'] ?? 1,
      ecoPoint: json['ecoPoint'] ?? 0,
      xp: json['xp'] ?? 0,
      maxXp: json['maxXp'] ?? 100,
      badges: List<String>.from(json['badges'] ?? []),
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'level': level,
      'ecoPoint': ecoPoint,
      'xp': xp,
      'maxXp': maxXp,
      'badges': badges,
      'avatar': avatar,
    };
  }

  double get xpProgress => maxXp > 0 ? xp / maxXp : 0;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    int? level,
    int? ecoPoint,
    int? xp,
    int? maxXp,
    List<String>? badges,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      level: level ?? this.level,
      ecoPoint: ecoPoint ?? this.ecoPoint,
      xp: xp ?? this.xp,
      maxXp: maxXp ?? this.maxXp,
      badges: badges ?? this.badges,
      avatar: avatar ?? this.avatar,
    );
  }
}
