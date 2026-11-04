import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CyberButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color primaryColor;
  final bool isOutlined;
  final bool isFullWidth;
  final bool isLoading;
  final double height;

  const CyberButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.primaryColor = AppColors.cyan,
    this.isOutlined = false,
    this.isFullWidth = false,
    this.isLoading = false,
    this.height = 46,
  });

  @override
  Widget build(BuildContext context) {
    Widget buttonContent = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOutlined ? primaryColor : Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(
            icon,
            size: 17,
            color: isOutlined ? primaryColor : Colors.white,
          ),
          const SizedBox(width: 7),
        ],
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isOutlined ? primaryColor : Colors.white,
          ),
        ),
      ],
    );

    return Container(
      height: height,
      width: isFullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: !isOutlined && onPressed != null
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: isLoading ? null : onPressed,
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: !isOutlined && onPressed != null
                  ? LinearGradient(
                      colors: [primaryColor, primaryColor.withOpacity(0.9)],
                    )
                  : null,
              color: isOutlined
                  ? Colors.transparent
                  : (onPressed == null ? Colors.grey.shade800 : null),
              border: Border.all(
                color: isOutlined ? primaryColor : Colors.transparent,
                width: 1.2,
              ),
            ),
            child: Center(child: buttonContent),
          ),
        ),
      ),
    );
  }
}
