import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quoterise/components/app_colors.dart';
import 'package:quoterise/components/app_text_styles.dart';
import '../components/theme_provider.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  // Design & Icons
  final bool isSecondary;
  final IconData? icon;
  final IconData? trailingIcon;
  final double? width;

  // Anpassbare Höhe und Schriftgröße
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  final Color? backgroundColor;
  final Color? textColor;

  // States
  final bool isLoading;
  final bool isDisabled;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
    this.icon,
    this.trailingIcon,
    this.width,
    this.height = 54.0,
    this.fontSize = 18.0,
    this.padding,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isLoading && !isDisabled;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // In stay_alive we don't currently have a palette.getPrimaryGradient() 
    // mechanism, so we default to standard container coloring below:
    Gradient? targetGradient; 

    final Color effectiveBgColor = isDisabled
        ? (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300)
        : (backgroundColor ??
              (isSecondary
                  ? (isDarkMode
                        ? AppColors.backgroundDarkSecondary
                        : AppColors.backgroundLightSecondary)
                  : theme.primaryColor));

    final effectiveTextColor = isDisabled
        ? (isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600)
        : (textColor ??
              (isSecondary
                  ? (isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight)
                  : Colors.white));

    // Glow Effekt
    final shadow = (isSecondary || isDisabled)
        ? const BoxShadow(color: Colors.transparent)
        : BoxShadow(
            color: theme.primaryColor.withOpacity(isDarkMode ? 0.6 : 0.4),
            blurRadius: 15,
            offset: Offset.zero,
            spreadRadius: 1,
          );

    final borderRadius = BorderRadius.circular(height / 2);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [shadow],
        gradient: targetGradient,
        color: targetGradient == null ? effectiveBgColor : null,

        // ✨ UPDATED: Dickerer Rand (1.5 statt 1.0)
        border: Border.all(
          color: isDarkMode
              ? Colors.white.withOpacity(
                  0.15,
                ) // Etwas sichtbarer im Dark Mode
              : Colors.black.withOpacity(
                  0.08,
                ), // Etwas sichtbarer im Light Mode
          width: 1.5, // Hier dicker gemacht
        ),
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: effectiveTextColor,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: effectiveTextColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24.0),
          splashFactory: NoSplash.splashFactory,
        ),
        child: isLoading
            ? SizedBox(
                height: height * 0.5,
                width: height * 0.5,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                  color: effectiveTextColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        style: AppTextStyles.medium.copyWith(
                          color: effectiveTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      ),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 6),
                    Icon(icon, size: fontSize + 2, color: effectiveTextColor),
                  ],
                ],
              ),
      ),
    );
  }
}
