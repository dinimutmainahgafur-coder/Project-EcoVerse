import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/colors.dart';
import '../../providers/mission_provider.dart';
import '../../widgets/bottom_navbar.dart';

class MissionScreen extends StatefulWidget {
  const MissionScreen({super.key});

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  final _categories = ['Semua', 'Daily Mission', 'Sampah', 'Air', 'Energi'];
  String _selectedCat = 'Semua';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MissionProvider>();
    final missions = provider.missions;

    return Scaffold(
      backgroundColor: EcoColors.background,
      appBar: AppBar(
        title: Text(
          'Daily Mission',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: EcoColors.text, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: EcoColors.text),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                _buildSearchBar(provider),
                const SizedBox(height: 12),
                _buildCategoryChips(),
              ],
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator(color: EcoColors.primary))
                : missions.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: () => provider.refreshMissions(),
                        color: EcoColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: missions.length,
                          itemBuilder: (context, index) {
                            final m = missions[index];
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(context, '/mission_detail', arguments: m),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 14),
                                decoration: BoxDecoration(
                                  color: EcoColors.card,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: m.image,
                                        width: double.infinity,
                                        height: 160,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(
                                          width: double.infinity,
                                          height: 160,
                                          color: EcoColors.greyLight,
                                          child: const Icon(Icons.eco_rounded, color: EcoColors.accent, size: 48),
                                        ),
                                        errorWidget: (_, __, ___) => Container(
                                          width: double.infinity,
                                          height: 160,
                                          color: EcoColors.greyLight,
                                          child: const Icon(Icons.eco_rounded, color: EcoColors.accent, size: 48),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: EcoColors.text,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            m.description,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: EcoColors.subtitle,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: EcoColors.primary.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '+${m.point} Poin',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: EcoColors.primary,
                                                  ),
                                                ),
                                              ),
                                              if (!m.isCompleted)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                  decoration: BoxDecoration(
                                                    color: EcoColors.primary,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                    'Mulai',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              else
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: EcoColors.success.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Text(
                                                    'Selesai',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      color: EcoColors.success,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: EcoBottomNavbar(
        currentIndex: 2,
        onTap: (i) {
          if (i == 0) Navigator.pushReplacementNamed(context, '/dashboard');
          if (i == 1) Navigator.pushNamed(context, '/journal');
          if (i == 3) Navigator.pushNamed(context, '/leaderboard');
          if (i == 4) Navigator.pushNamed(context, '/profile');
        },
      ),
    );
  }

  Widget _buildSearchBar(MissionProvider provider) {
    return TextField(
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: 'Cari misi...',
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: EcoColors.subtitle),
        prefixIcon: const Icon(Icons.search_rounded, color: EcoColors.subtitle, size: 22),
        filled: true,
        fillColor: const Color(0xFFF5F7F5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (v) => provider.searchMissions(v),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final selected = _selectedCat == cat;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCat = cat);
              context.read<MissionProvider>().filterByCategory(cat);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? EcoColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? EcoColors.primary : EcoColors.divider,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                cat,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : EcoColors.text,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: EcoColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.eco_rounded,
              size: 40,
              color: EcoColors.primary.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Tidak ada misi ditemukan',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: EcoColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
