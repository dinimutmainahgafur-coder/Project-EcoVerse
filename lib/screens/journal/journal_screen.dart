import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../providers/journal_provider.dart';
import '../../widgets/bottom_navbar.dart';
import 'journal_detail_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'Semua',
    'Sampah',
    'Air',
    'Energi',
  ];

  String _selectedCat = 'Semua';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<JournalProvider>().fetchJournal();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final journal = context.watch<JournalProvider>();
    final items = journal.completedMissions;

    return Scaffold(
      backgroundColor: EcoColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Eco Journal',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: EcoColors.text,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: EcoColors.text,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 12),
                _buildCategoryChips(),
              ],
            ),
          ),
          Expanded(
            child: journal.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : items.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: journal.refreshJournal,
                        child: ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final m = items[index];

                            return InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => JournalDetailScreen(
                                      mission: m,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: EcoColors.card,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        m.image,
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return const SizedBox(
                                            width: 55,
                                            height: 55,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 55,
                                            height: 55,
                                            color: Colors.grey.shade200,
                                            child: const Icon(Icons.image),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: EcoColors.text,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            m.description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: EcoColors.subtitle,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today_rounded,
                                                size: 12,
                                                color: EcoColors.subtitle,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                m.completedDate.isEmpty
                                                    ? 'Hari ini'
                                                    : m.completedDate,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  color: EcoColors.subtitle,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                width: 3,
                                                height: 3,
                                                decoration: BoxDecoration(
                                                  color: EcoColors.subtitle.withValues(
                                                    alpha: 0.4,
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  m.category,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: EcoColors.subtitle,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: EcoColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '+${m.point}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: EcoColors.primary,
                                        ),
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
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                context,
                '/dashboard',
              );
              break;
            case 2:
              Navigator.pushNamed(
                context,
                '/mission',
              );
              break;
            case 3:
              Navigator.pushNamed(
                context,
                '/leaderboard',
              );
              break;
            case 4:
              Navigator.pushNamed(
                context,
                '/profile',
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      style: GoogleFonts.poppins(
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'Cari aktivitas...',
        hintStyle: GoogleFonts.poppins(
          fontSize: 13,
          color: EcoColors.subtitle,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: EcoColors.subtitle,
          size: 22,
        ),
        filled: true,
        fillColor: const Color(0xFFF5F7F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: (value) {
        context
            .read<JournalProvider>()
            .searchJournal(value);
      },
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final selected = category == _selectedCat;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCat = category;
              });
              context
                  .read<JournalProvider>()
                  .filterByCategory(category);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? EcoColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? EcoColors.primary : EcoColors.divider,
                ),
              ),
              child: Text(
                category,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 80,
              color: EcoColors.primary.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum ada jurnal',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: EcoColors.text,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selesaikan misi atau tunggu data dari MockAPI.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: EcoColors.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}