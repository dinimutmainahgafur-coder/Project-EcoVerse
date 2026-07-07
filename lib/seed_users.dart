/// Script untuk seed data users ke MockAPI
/// Jalankan: dart run lib/seed_users.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'https://6a44fe22aab3faec3f692f84.mockapi.io/users';

Future<void> main() async {
  print('🌱 Mulai seed data users ke MockAPI...\n');

  for (var user in defaultUsers) {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user),
      );

      if (response.statusCode == 201) {
        print('✅ ${user["name"]} berhasil ditambahkan');
      } else {
        print('❌ ${user["name"]} gagal: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ ${user["name"]} error: $e');
    }
  }

  print('\n🌱 Seed data selesai!');
}
