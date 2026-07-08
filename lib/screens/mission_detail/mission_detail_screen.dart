import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../models/mission.dart';
import '../../providers/mission_provider.dart';
import '../../providers/journal_provider.dart';
import '../../providers/auth_provider.dart';

class MissionDetailScreen extends StatefulWidget {
  // 1. Tambahkan parameter mission di constructor agar sinkron dengan screen sebelumnya
  final Mission mission;
  const MissionDetailScreen({super.key, required this.mission});

  @override
  State<MissionDetailScreen> createState() => _MissionDetailScreenState();
}

class _MissionDetailScreenState extends State<MissionDetailScreen> {
  // 2. Gunakan late widget.mission untuk inisialisasi lokal jika datanya ingin dimutasi di state ini
  late Mission mission;
  bool _proofUploaded = false;
  int _selectedDateIndex = 4;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data mission dari widget constructor
    mission = widget.mission;
  }

  void _completeMission() async {
    final missionProvider = context.read<MissionProvider>();
    final journalProvider = context.read<JournalProvider>();
    final authProvider = context.read<AuthProvider>();

    await missionProvider.updateMissionStatus(mission.id, 'Selesai');
    await authProvider.addEcoPoint(mission.point);

    final updatedMission = mission.copyWith(status: 'Selesai');
    journalProvider.addCompletedMission(updatedMission);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Misi selesai! +${mission.point} Eco Points', style: GoogleFonts.poppins()),
          backgroundColor: EcoColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildDatePicker(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildMissionCard(),
                  const SizedBox(height: 20),
                  _buildUploadSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: EcoColors.text),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Daily Mission',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: EcoColors.text,
          fontSize: 17,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline_rounded, size: 22, color: EcoColors.subtitle),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    final now = DateTime.now();
    final dates = List.generate(9, (i) {
      final day = now.day - 4 + i;
      return DateTime(now.year, now.month, day);
    });

    final dayLabels = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: SizedBox(
        height: 76,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final isSelected = index == _selectedDateIndex;
            final dayLabel = dayLabels[date.weekday % 7];

            return GestureDetector(
              onTap: () => setState(() => _selectedDateIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? EcoColors.primary : const Color(0xFFF5F7F5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: EcoColors.primary.withAlpha((0.3 * 255).round()),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${date.day}',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : EcoColors.text,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dayLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? Colors.white.withAlpha((0.8 * 255).round())
                            : EcoColors.subtitle,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMissionCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: EcoColors.card,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.06 * 255).round()),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          _buildMissionImage(),
          const SizedBox(height: 24),
          _buildMissionTitle(),
          const SizedBox(height: 10),
          _buildMissionDescription(),
          const SizedBox(height: 20),
          _buildPointBadge(),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _buildMissionImage() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: EcoColors.primary.withAlpha((0.06 * 255).round()),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            imageUrl: mission.image,
            width: 130,
            height: 130,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              width: 130,
              height: 130,
              color: EcoColors.greyLight,
              child: const Icon(Icons.eco_rounded, color: EcoColors.accent, size: 56),
            ),
            errorWidget: (_, __, ___) => Container(
              width: 130,
              height: 130,
              color: EcoColors.greyLight,
              child: const Icon(Icons.eco_rounded, color: EcoColors.accent, size: 56),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMissionTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        mission.title,
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: EcoColors.text,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMissionDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        mission.description,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: EcoColors.subtitle,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildPointBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: EcoColors.primary.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on_rounded, size: 18, color: EcoColors.gold),
          const SizedBox(width: 6),
          Text(
            '+${mission.point} Poin',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: EcoColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: EcoColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: EcoColors.primary.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: EcoColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Bukti',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: EcoColors.text,
                      ),
                    ),
                    Text(
                      'Kirim tumbler yang kamu gunakan',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: EcoColors.subtitle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.pushNamed(context, '/upload');
              if (result == true) {
                setState(() => _proofUploaded = true);
              }
            },
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: _proofUploaded
                    ? EcoColors.success.withAlpha((0.08 * 255).round())
                    : const Color(0xFFF8FFF8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _proofUploaded
                      ? EcoColors.success.withAlpha((0.3 * 255).round())
                      : EcoColors.divider,
                  width: 1.5,
                ),
              ),
              child: _proofUploaded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: EcoColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Bukti sudah diupload',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: EcoColors.success,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 32,
                          color: EcoColors.subtitle.withAlpha((0.5 * 255).round()),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap untuk upload bukti',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: EcoColors.subtitle,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final isCompleted = mission.isCompleted;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: isCompleted ? null : _showConfirmDialog,
          style: ElevatedButton.styleFrom(
            backgroundColor: isCompleted
                ? EcoColors.primary.withAlpha((0.5 * 255).round())
                : EcoColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: EcoColors.primary.withAlpha((0.5 * 255).round()),
            disabledForegroundColor: Colors.white.withAlpha((0.8 * 255).round()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: isCompleted ? 0 : 4,
            shadowColor: EcoColors.primary.withAlpha((0.3 * 255).round()),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isCompleted) ...[
                const Icon(Icons.check_circle_rounded, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                isCompleted ? 'Selesai' : 'Selesai',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Selesaikan Misi?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        content: Text(
          'Pastikan kamu sudah upload bukti sebelum menyelesaikan misi ini. Poin akan otomatis ditambahkan ke akun kamu.',
          style: GoogleFonts.poppins(fontSize: 13, color: EcoColors.subtitle, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(color: EcoColors.subtitle, fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeMission();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: EcoColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Ya, Selesai',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}