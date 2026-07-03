import 'package:flutter/material.dart';

class AcademyProvider extends ChangeNotifier {
  String _selectedCategory = 'Semua';
  String get selectedCategory => _selectedCategory;

  final List<Map<String, dynamic>> _articles = [
    {
      'id': '1',
      'title': 'Panduan Memilah Sampah dengan Benar',
      'category': 'Sampah',
      'duration': '5 menit',
      'thumbnail': 'https://picsum.photos/seed/sampah1/400/250',
      'content': 'Memilah sampah adalah langkah pertama dalam pengelolaan limbah yang bertanggung jawab.',
    },
    {
      'id': '2',
      'title': 'Cara Menghemat Air di Rumah',
      'category': 'Air',
      'duration': '4 menit',
      'thumbnail': 'https://picsum.photos/seed/air1/400/250',
      'content': 'Air adalah sumber daya yang sangat berharga. Berikut tips menghemat air.',
    },
    {
      'id': '3',
      'title': 'Tips Mengurangi Penggunaan Listrik',
      'category': 'Energi',
      'duration': '6 menit',
      'thumbnail': 'https://picsum.photos/seed/energi1/400/250',
      'content': 'Menghemat energi tidak hanya menghemat tagihan tapi juga menjaga bumi.',
    },
    {
      'id': '4',
      'title': 'Bahaya Plastik bagi Lingkungan',
      'category': 'Plastik',
      'duration': '5 menit',
      'thumbnail': 'https://picsum.photos/seed/plastik1/400/250',
      'content': 'Plastik membutuhkan waktu ratusan tahun untuk terurai. Mari kurangi penggunaannya.',
    },
    {
      'id': '5',
      'title': 'Mendaur Ulang Kertas dengan Mudah',
      'category': 'Sampah',
      'duration': '3 menit',
      'thumbnail': 'https://picsum.photos/seed/kertas1/400/250',
      'content': 'Kertas bisa didaur ulang hingga 5-7 kali. Pelajari cara mendaur ulangnya.',
    },
    {
      'id': '6',
      'title': 'Menghemat Air saat Musim Kemarau',
      'category': 'Air',
      'duration': '4 menit',
      'thumbnail': 'https://picsum.photos/seed/air2/400/250',
      'content': 'Strategi efektif untuk menghemat air saat musim kemarau tiba.',
    },
    {
      'id': '7',
      'title': 'Energi Terbarukan untuk Rumah Tangga',
      'category': 'Energi',
      'duration': '7 menit',
      'thumbnail': 'https://picsum.photos/seed/energi2/400/250',
      'content': 'Pelajari cara menggunakan energi terbarukan di rumah Anda.',
    },
    {
      'id': '8',
      'title': 'Alternatif Pengganti Plastik Sekali Pakai',
      'category': 'Plastik',
      'duration': '5 menit',
      'thumbnail': 'https://picsum.photos/seed/plastik2/400/250',
      'content': 'Banyak alternatif ramah lingkungan yang bisa menggantikan plastik sekali pakai.',
    },
  ];

  List<Map<String, dynamic>> get articles => _selectedCategory == 'Semua'
      ? _articles
      : _articles.where((a) => a['category'] == _selectedCategory).toList();

  /// Filter berdasarkan kategori
  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
