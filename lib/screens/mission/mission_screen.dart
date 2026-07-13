import 'package:flutter/material.dart';
import 'package:ecoverse/models/mission.dart';
import 'package:ecoverse/services/api_service.dart';
// IMPORT DIPERBAIKI KE FOLDER mission_detail
import 'package:ecoverse/screens/mission_detail/mission_detail_screen.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Mission>> futureMission;

  @override
  void initState() {
    super.initState();
    loadMission();
  }

  void loadMission() {
    futureMission = apiService.getMissions();
  }

  Future<void> refreshMission() async {
    if (!mounted) return;
    setState(() {
      loadMission();
    });
  }

  Color getStatusColor(String status) {
    if (status == "Selesai") {
      return Colors.green;
    }
    return Colors.orange;
  }

  IconData getMissionIcon(String category) {
    switch (category) {
      case "Daily Mission":
        return Icons.eco;
      case "Challenge":
        return Icons.flag;
      case "Academy":
        return Icons.menu_book;
      default:
        return Icons.eco;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Daily Mission",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.green,
        onRefresh: refreshMission,
        child: FutureBuilder<List<Mission>>(
          future: futureMission,
          builder: (context, snapshot) {
            /// Status Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            /// Status Error
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 80,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Terjadi Kesalahan",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        snapshot.error.toString(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: refreshMission,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Coba Lagi"),
                      ),
                    ],
                  ),
                ),
              );
            }

            final missions = snapshot.data ?? [];

            /// Status Data Kosong
            if (missions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.eco,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Belum Ada Daily Mission",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            /// Menampilkan Daftar Mission
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Daily Eco Mission",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Selesaikan misi hari ini dan kumpulkan Eco Point 🌿",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 25),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: missions.length,
                  itemBuilder: (context, index) {
                    final mission = missions[index];
                    return _buildMissionCard(mission);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Widget Helper Card (FIXED OVERFLOW)
  Widget _buildMissionCard(Mission mission) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MissionDetailScreen(
              mission: mission,
            ),
          ),
        );

        if (!mounted) return;
        refreshMission();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.04 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Sejajarkan rata atas
          children: [
            // 1. Icon Kategori Misi
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                getMissionIcon(mission.category),
                color: Colors.green,
                size: 30,
              ),
            ),
            const SizedBox(width: 15),

            // 2. Konten Tengah (Judul, Deskripsi, Badge & Kategori)
            // Dibungkus Expanded agar memaksa teks mengalah pada lebar layar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    mission.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mission.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Menggunakan Wrap menggantikan Row agar badge aman dari overflow vertikal/horizontal
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "+${mission.point} Point",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: getStatusColor(mission.status)
                              .withAlpha((0.15 * 255).round()),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          mission.status,
                          style: TextStyle(
                            color: getStatusColor(mission.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    mission.category,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // 3. Icon Panah Kanan
            const Padding(
              padding: EdgeInsets.only(top: 4), // Penyelarasan visual sedikit ke bawah
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}