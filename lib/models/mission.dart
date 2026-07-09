class Mission {
  final String id;
  final String title;
  final String description;
  final String category;
  final int point;
  final String status;
  final String image;

  // Khusus Journal
  final String completedDate;
  final String link;
  final String createdAt;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.point,
    required this.status,
    required this.image,
    this.completedDate = '',
    this.link = '',
    this.createdAt = '',
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      point: json['point'] is int
          ? json['point']
          : int.tryParse(json['point'].toString()) ?? 0,
      status: json['status'] ?? 'Belum Selesai',
      image: json['image'] ?? '',
      completedDate: json['completedDate'] ?? '',
      link: json['link'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'point': point,
      'status': status,
      'image': image,
      'completedDate': completedDate,
      'link': link,
      'createdAt': createdAt,
    };
  }

  bool get isCompleted => status == 'Selesai';

  Mission copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? point,
    String? status,
    String? image,
    String? completedDate,
    String? link,
    String? createdAt,
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      point: point ?? this.point,
      status: status ?? this.status,
      image: image ?? this.image,
      completedDate: completedDate ?? this.completedDate,
      link: link ?? this.link,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}