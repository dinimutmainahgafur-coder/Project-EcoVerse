import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/colors.dart';
import '../../models/mission.dart';

class JournalDetailScreen extends StatelessWidget {
  final Mission mission;

  const JournalDetailScreen({
    super.key,
    required this.mission,
  });

  Future<void> _openLink(BuildContext context) async {
    if (mission.link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Link artikel tidak tersedia"),
        ),
      );
      return;
    }

    final uri = Uri.parse(mission.link);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak dapat membuka link"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Detail Journal",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: EcoColors.text,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: EcoColors.text,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            /// IMAGE
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(18),
              child: Image.network(
                mission.image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,

                errorBuilder:
                    (_, __, ___) {
                  return Container(
                    height: 220,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(
                        Icons.image,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Text(
              mission.title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: EcoColors.text,
              ),
            ),

            const SizedBox(height: 15),

            /// CATEGORY + POINT
            Row(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: EcoColors.primary
                        .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    mission.category,
                    style: GoogleFonts.poppins(
                      color: EcoColors.primary,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange
                        .withValues(alpha: 0.15),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    "+${mission.point} Point",
                    style: GoogleFonts.poppins(
                      color: Colors.orange,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// DATE
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: EcoColors.subtitle,
                ),

                const SizedBox(width: 8),

                Text(
                  mission.completedDate.isEmpty
                      ? "-"
                      : mission.completedDate,
                  style: GoogleFonts.poppins(
                    color: EcoColors.subtitle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              "Deskripsi",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              mission.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: EcoColors.text,
              ),
            ),

            const SizedBox(height: 35),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _openLink(context),

                icon: const Icon(
                  Icons.open_in_new,
                  color: Colors.white,
                ),

                label: Text(
                  "Buka Artikel",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      EcoColors.primary,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}