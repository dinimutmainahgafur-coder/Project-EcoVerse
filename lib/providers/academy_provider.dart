import 'package:flutter/material.dart';

class AcademyProvider with ChangeNotifier {
  String _selectedCategory = 'Semua';
  String get selectedCategory => _selectedCategory;

  // Data artikel dengan judul dan gambar ilustrasi asli bertema lingkungan (EcoVerse)
  final List<Map<String, dynamic>> _articles = [
    {
      'id': '1',
      'title': 'Panduan Memilah Sampah dengan Benar',
      'category': 'Sampah',
      'duration': '5 menit',
      'thumbnail': 'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?q=80&w=400&auto=format&fit=crop',
      'content': 'Memilah sampah adalah langkah pertama dalam pengelolaan limbah yang bertanggung jawab.',
    },
    {
      'id': '2',
      'title': 'Cara Menghemat Air di Rumah',
      'category': 'Air',
      'duration': '4 menit',
      'thumbnail': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?q=80&w=400&auto=format&fit=crop',
      'content': 'Air adalah sumber daya yang sangat berharga. Berikut tips menghemat air sehari-hari.',
    },
    {
      'id': '3',
      'title': 'Tips Mengurangi Penggunaan Listrik',
      'category': 'Energi',
      'duration': '6 menit',
      'thumbnail': 'https://images.unsplash.com/photo-1473341304170-971dccb5ac1e?q=80&w=400&auto=format&fit=crop',
      'content': 'Menghemat energi tidak hanya menghemat tagihan tapi juga menjaga kelestarian bumi.',
    },
    {
      'id': '4',
      'title': 'Bahaya Plastik bagi Lingkungan',
      'category': 'Plastik',
      'duration': '5 menit',
      'thumbnail': 'https://images.unsplash.com/photo-1618477388954-7852f32655ec?q=80&w=400&auto=format&fit=crop',
      'content': 'Plastik membutuhkan waktu ratusan tahun untuk terurai. Mari kurangi penggunaannya.',
    },
    {
      'id': '5',
      'title': 'Mendaur Ulang Kertas dengan Mudah',
      'category': 'Sampah',
      'duration': '3 menit',
      'thumbnail': 'https://images.unsplash.com/photo-1582408926005-12e790b533d1?q=80&w=400&auto=format&fit=crop',
      'content': 'Kertas bisa didaur ulang hingga 5-7 kali. Pelajari cara mendaur ulangnya di rumah.',
    },
    {
      'id': '6',
      'title': 'Menghemat Air saat Musim Kemarau',
      'category': 'Air',
      'duration': '4 menit',
      'thumbnail': 'https://images.unsplash.com/photo-1518156677180-95a2893f3e9f?q=80&w=400&auto=format&fit=crop',
      'content': 'Strategi efektif untuk menghemat air bersih saat musim kemarau panjang tiba.',
    },
    {
      'id': '7',
      'title': 'Energi Terbarukan untuk Rumah Tangga',
      'category': 'Energi',
      'duration': '7 menit',
      'thumbnail': 'https://images.unsplash.com/photo-1509391366360-2e959784a276?q=80&w=400&auto=format&fit=crop',
      'content': 'Pelajari cara memanfaatkan panel surya dan energi terbarukan lainnya di rumah Anda.',
    },
    {
      'id': '8',
      'title': 'Alternatif Pengganti Plastik Sekali Pakai',
      'category': 'Plastik',
      'duration': '5 menit',
      'thumbnail': 'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?q=80&w=400&auto=format&fit=crop',
      'content': 'Banyak alternatif ramah lingkungan (totebag, tumbler) yang bisa menggantikan plastik sekali pakai.',
    },
  ];

  List<Map<String, dynamic>> get articles => _selectedCategory == 'Semua'
      ? _articles
      : _articles.where((a) => a['category'] == _selectedCategory).toList();

  /// Filter berdasarkan kategori artikel
  void filterByCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}