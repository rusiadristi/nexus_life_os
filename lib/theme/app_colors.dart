import 'package:flutter/material.dart';

class AppColors {
  // Soft, Modern Executive Slate Palette
  static const Color background = Color(0xFF0E131F);
  static const Color surface = Color(0xFF161E2E);
  static const Color surfaceLight = Color(0xFF202A3C);
  static const Color surfaceGlass = Color(0xEE161E2E);
  static const Color cardBorder = Color(0xFF283447);
  static const Color cardBorderGlow = Color(0x226366F1);

  // Soft, Professional Accents (Subtle & Elegant)
  static const Color cyan = Color(0xFF6366F1); // Primary: Soft Indigo (Modern Executive)
  static const Color neonBlue = Color(0xFF38BDF8); // Soft Sky Blue
  static const Color neonPurple = Color(0xFF818CF8); // Soft Muted Lavender
  static const Color neonViolet = Color(0xFF9333EA); // Gentle Violet
  static const Color neonEmerald = Color(0xFF10B981); // Soft Forest Emerald
  static const Color neonPink = Color(0xFFF43F5E); // Soft Rose
  static const Color neonAmber = Color(0xFFF59E0B); // Soft Warm Amber
  static const Color neonRed = Color(0xFFEF4444); // Soft Coral Red

  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Soft Professional Gradients
  static const LinearGradient cyberCyanGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleHoloGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient matrixEmeraldGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    colors: [Color(0xFF192233), Color(0xFF141B29)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fieryOrangeGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
