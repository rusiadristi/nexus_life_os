import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CyberCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? glowColor;
  final double borderWidth;
  final double borderRadius;
  final Gradient? gradient;

  const CyberCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.glowColor,
    this.borderWidth = 1.0,
    this.borderRadius = 14.0,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient ??
            LinearGradient(
              colors: [
                AppColors.surface.withOpacity(0.95),
                AppColors.surfaceLight.withOpacity(0.4),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        border: Border.all(
          color: glowColor != null
              ? glowColor!.withOpacity(0.25)
              : AppColors.cardBorder,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onTap,
          splashColor: (glowColor ?? AppColors.cyan).withOpacity(0.08),
          highlightColor: (glowColor ?? AppColors.cyan).withOpacity(0.04),
          child: content,
        ),
      );
    }

    return content;
  }
}
