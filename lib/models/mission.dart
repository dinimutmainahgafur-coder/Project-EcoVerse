class Mission {
  final String id;
  final String title;
  final String description;
  final String category;
  final int point;
  final String status;
  final String image;

  Mission({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.point,
    required this.status,
    required this.image,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      point: json['point'] ?? 0,
      status: json['status'] ?? 'Belum Selesai',
      image: json['image'] ?? '',
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
  }) {
    return Mission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      point: point ?? this.point,
      status: status ?? this.status,
      image: image ?? this.image,
    );
  }
}
