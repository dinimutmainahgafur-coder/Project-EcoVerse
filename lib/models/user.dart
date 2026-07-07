class User {
  final String id;
  final String name;
  final String email;
  final String username;
  final String password;
  final int level;
  final int ecoPoint;
  final int xp;
  final int maxXp;
  final List<String> badges;
  final String avatar;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    this.level = 1,
    this.ecoPoint = 0,
    this.xp = 0,
    this.maxXp = 100,
    this.badges = const [],
    this.avatar = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      level: int.tryParse(json['level'].toString()) ?? 1,
      ecoPoint: int.tryParse(json['ecoPoint'].toString()) ?? 0,
      xp: int.tryParse(json['xp'].toString()) ?? 0,
      maxXp: int.tryParse(json['maxXp'].toString()) ?? 100,
      badges: json['badges'] != null
          ? List<String>.from(json['badges'])
          : <String>[],
      avatar: json['avatar']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'level': level,
      'ecoPoint': ecoPoint,
      'xp': xp,
      'maxXp': maxXp,
      'badges': badges,
      'avatar': avatar,
    };
  }

  double get xpProgress => maxXp == 0 ? 0 : xp / maxXp;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    String? password,
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
      password: password ?? this.password,
      level: level ?? this.level,
      ecoPoint: ecoPoint ?? this.ecoPoint,
      xp: xp ?? this.xp,
      maxXp: maxXp ?? this.maxXp,
      badges: badges ?? this.badges,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  String toString() {
    return 'User('
        'id: $id, '
        'name: $name, '
        'email: $email, '
        'username: $username, '
        'level: $level, '
        'ecoPoint: $ecoPoint, '
        'xp: $xp'
        ')';
  }
}
