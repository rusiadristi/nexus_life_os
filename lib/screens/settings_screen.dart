import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/cyber_card.dart';
import '../widgets/cyber_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Pengaturan Sistem',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          children: [
            // User Profile Card
            CyberCard(
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.cyberCyanGradient,
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.userName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${profile.userRank} • Level ${profile.cyberLevel}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.cyan,
                          ),
                        ),
                        Text(
                          'ID: NX-9024',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.textSecondary, size: 20),
                    onPressed: () => _showEditNameDialog(context, profile),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Security & Preferences
            Text(
              'KEAMANAN & PREFERENSI',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            CyberCard(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(
                      'Kunci Keamanan Biometrik',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Verifikasi Face ID / Sidik Jari saat membuka aplikasi',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    value: profile.biometricLock,
                    activeColor: AppColors.cyan,
                    onChanged: (val) => profile.setBiometricLock(val),
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  SwitchListTile(
                    title: Text(
                      'Respon Getaran Taktil (Haptic)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Getaran halus saat menyelesaikan tugas atau aksi',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    value: profile.hapticFeedback,
                    activeColor: AppColors.cyan,
                    onChanged: (val) => profile.setHapticFeedback(val),
                  ),
                  const Divider(color: AppColors.cardBorder, height: 1),
                  SwitchListTile(
                    title: Text(
                      'Efek Audio Ambience',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Suara latar lembut saat timer fokus berjalan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    value: profile.neuralSoundFx,
                    activeColor: AppColors.cyan,
                    onChanged: (val) => profile.setNeuralSoundFx(val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // System Diagnostics
            Text(
              'INFORMASI & DIAGNOSTIK APLIKASI',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            CyberCard(
              child: Column(
                children: [
                  _buildDiagRow('Versi Aplikasi', 'Nexus Life OS v2.4 (Build 2026)'),
                  _buildDiagRow('Framework Core', 'Flutter 3.24 / Dart 3.5'),
                  _buildDiagRow('Arsitektur State', 'Clean Multi-Provider'),
                  _buildDiagRow('Penyimpanan Data', 'Offline-First Local Cache'),
                  _buildDiagRow('Status Sinkronisasi', 'Terkoneksi & Optimal'),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Philosophy Card
            CyberCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_outlined, color: AppColors.cyan, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Desain Profesional & Berkelanjutan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Aplikasi ini dirancang untuk mempermudah navigasi produktivitas harian, fokus deep work, dan manajemen portofolio dengan tampilan visual yang elegan, bersih, dan menenangkan.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    '© 2026 Rusi Adristi. All rights reserved.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hak Cipta Dilindungi Undang-Undang',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: AppColors.textMuted.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, UserProfileProvider profile) {
    final controller = TextEditingController(text: profile.userName);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: AppColors.cardBorder),
          ),
          title: Text(
            'Ubah Nama Profil',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(labelText: 'Nama Lengkap'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal', style: TextStyle(color: AppColors.textMuted)),
            ),
            CyberButton(
              text: 'Simpan',
              height: 36,
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  profile.updateName(controller.text.trim());
                }
                Navigator.pop(ctx);
              },
            ),
          ],
        );
      },
    );
  }
}
