import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/colors.dart';

/// Halaman upload bukti misi
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  /// Ambil gambar dari kamera
  Future<void> _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  /// Ambil gambar dari galeri
  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  /// Submit bukti dan kirim status sukses ke halaman sebelumnya
  void _submit() {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih foto terlebih dahulu', style: GoogleFonts.poppins()),
          backgroundColor: EcoColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bukti berhasil diupload!', style: GoogleFonts.poppins()),
        backgroundColor: EcoColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
    
    // Kembali ke halaman detail dengan membawa nilai 'true'
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EcoColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: EcoColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Upload Bukti',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: EcoColors.text,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Sumber Foto',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: EcoColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickFromCamera,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              color: EcoColors.primary.withAlpha((0.08 * 255).round()),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: EcoColors.primary.withAlpha((0.3 * 255).round()),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 36,
                                  color: EcoColors.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Kamera',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: EcoColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickFromGallery,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              color: EcoColors.blue.withAlpha((0.08 * 255).round()),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: EcoColors.blue.withAlpha((0.3 * 255).round()),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.photo_library_rounded,
                                  size: 36,
                                  color: EcoColors.blue,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Galeri',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: EcoColors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Preview Bukti',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: EcoColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 280,
                    decoration: BoxDecoration(
                      color: EcoColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: EcoColors.divider),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((0.03 * 255).round()),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_outlined,
                                size: 56,
                                color: EcoColors.subtitle.withAlpha((0.3 * 255).round()),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Belum ada foto yang dipilih',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: EcoColors.subtitle,
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final hasImage = _imageFile != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasImage
                ? EcoColors.primary
                : EcoColors.primary.withAlpha((0.5 * 255).round()),
            foregroundColor: Colors.white,
            disabledBackgroundColor: EcoColors.primary.withAlpha((0.5 * 255).round()),
            disabledForegroundColor: Colors.white.withAlpha((0.8 * 255).round()),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: hasImage ? 4 : 0,
            shadowColor: EcoColors.primary.withAlpha((0.3 * 255).round()),
          ),
          child: Text(
            'Submit Bukti',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}