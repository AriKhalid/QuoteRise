import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../components/app_colors.dart';
import '../components/app_text_styles.dart';
import '../components/app_drag_handle.dart';
import '../components/font_provider.dart';

class FontBottomSheet extends StatelessWidget {
  const FontBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const FontBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final fontProvider = context.watch<FontProvider>();

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20, 12, 20,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppDragHandle(),
          const SizedBox(height: 16),
          Text(
            'font_style'.tr(),
            style: AppTextStyles.large.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          ...AppFont.values.map((font) => _buildFontTile(
            context: context,
            theme: theme,
            isDark: isDark,
            font: font,
            isSelected: fontProvider.font == font,
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<FontProvider>().setFont(font);
            },
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildFontTile({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required AppFont font,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryButtonColor.withOpacity(isDark ? 0.25 : 0.1)
              : (isDark ? const Color(0xFF1C1C1E) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryButtonColor
                : theme.colorScheme.onSurface.withOpacity(0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    font.displayName,
                    style: TextStyle(
                      fontFamily: font.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    font.previewText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: font.fontFamily,
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryButtonColor,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
