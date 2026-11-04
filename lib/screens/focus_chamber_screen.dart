import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../providers/focus_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/cyber_card.dart';
import '../widgets/cyber_button.dart';

class FocusChamberScreen extends StatelessWidget {
  const FocusChamberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focusProv = context.watch<FocusProvider>();
    final profile = context.watch<UserProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Sesi Fokus & Deep Work',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cyan.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_outlined, color: AppColors.cyan, size: 15),
                const SizedBox(width: 4),
                Text(
                  '${focusProv.todayMinutes}m Hari Ini',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              // Presets selector
              _buildPresetModes(focusProv),
              const SizedBox(height: 20),

              // Circular HUD Timer
              _buildCircularHUD(focusProv),
              const SizedBox(height: 20),

              // Action Buttons
              _buildControls(context, focusProv, profile),
              const SizedBox(height: 24),

              // Ambient Frequency Selector
              _buildAmbientSelector(focusProv),
              const SizedBox(height: 20),

              // Session History Log
              _buildSessionLog(focusProv),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetModes(FocusProvider focusProv) {
    return SizedBox(
      height: 74,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: focusProv.modes.length,
        itemBuilder: (context, index) {
          final mode = focusProv.modes[index];
          final isSelected = focusProv.selectedModeIndex == index;

          return GestureDetector(
            onTap: () => focusProv.selectMode(index),
            child: Container(
              width: 135,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.cyan.withOpacity(0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.cyan : AppColors.cardBorder,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${mode['minutes']} Menit',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.cyan : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    mode['name'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.textPrimary : AppColors.textMuted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCircularHUD(FocusProvider focusProv) {
    final progress = focusProv.progress;
    final currentMode = focusProv.modes[focusProv.selectedModeIndex];

    return CyberCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 210,
                height: 210,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.cardBorder,
                    width: 2,
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 6,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    focusProv.isRunning ? AppColors.cyan : AppColors.neonPurple,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentMode['name'].toString().toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.cyan,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    focusProv.formattedTime,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      letterSpacing: -1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: focusProv.isRunning
                          ? AppColors.neonEmerald.withOpacity(0.12)
                          : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: focusProv.isRunning ? AppColors.neonEmerald : AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          focusProv.isRunning ? 'Sesi Aktif' : 'Standby',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: focusProv.isRunning ? AppColors.neonEmerald : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControls(
    BuildContext context,
    FocusProvider focusProv,
    UserProfileProvider profile,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CyberButton(
          text: focusProv.isRunning ? 'Jeda' : 'Mulai Sesi',
          icon: focusProv.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          primaryColor: focusProv.isRunning ? AppColors.neonAmber : AppColors.cyan,
          onPressed: () {
            if (focusProv.isRunning) {
              focusProv.pauseTimer();
            } else {
              focusProv.startTimer(
                onComplete: (xp) {
                  profile.addXp(xp);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.surface,
                      content: Text(
                        'Sesi Fokus Selesai! +$xp Poin berhasil diperoleh.',
                        style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        const SizedBox(width: 12),
        CyberButton(
          text: 'Reset',
          icon: Icons.refresh_rounded,
          isOutlined: true,
          primaryColor: AppColors.textSecondary,
          onPressed: () => focusProv.resetTimer(),
        ),
      ],
    );
  }

  Widget _buildAmbientSelector(FocusProvider focusProv) {
    return CyberCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SUARA LATAR & AMBIENCE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const Icon(Icons.graphic_eq_rounded, color: AppColors.cyan, size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: focusProv.ambientFrequencies.map((freq) {
              final isSel = focusProv.selectedAmbient == freq;
              return ChoiceChip(
                label: Text(freq),
                selected: isSel,
                selectedColor: AppColors.cyan,
                backgroundColor: AppColors.surfaceLight.withOpacity(0.4),
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: isSel ? Colors.white : AppColors.textPrimary,
                ),
                onSelected: (_) => focusProv.selectAmbient(freq),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionLog(FocusProvider focusProv) {
    if (focusProv.sessions.isEmpty) {
      return CyberCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Belum ada sesi fokus tercatat hari ini.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RIWAYAT SESI HARI INI',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        ...focusProv.sessions.take(3).map((s) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s.modeName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${s.ambientMode} • Skor: ${s.flowScore}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  '+${s.durationMinutes}m',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.neonEmerald,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
