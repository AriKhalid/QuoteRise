import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../components/app_colors.dart';
import '../components/app_text_styles.dart';
import '../components/app_drag_handle.dart';
import '../components/quote_provider.dart';

const Map<String, IconData> _categoryIcons = {
  'mindset':    Icons.psychology_outlined,
  'hustle':     Icons.bolt_outlined,
  'growth':     Icons.trending_up_rounded,
  'resilience': Icons.shield_outlined,
  'wisdom':     Icons.menu_book_outlined,
  'faith':      Icons.favorite_border_rounded,
};

const Map<String, Color> _categoryColors = {
  'mindset':    Color(0xFF5856D6),
  'hustle':     Color(0xFFFF9500),
  'growth':     Color(0xFF34C759),
  'resilience': Color(0xFFFF3B30),
  'wisdom':     Color(0xFF2193b0),
  'faith':      Color(0xFFFF2D55),
};

class CategoryBottomSheet extends StatelessWidget {
  const CategoryBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const CategoryBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<QuoteProvider>();

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
            'categories'.tr(),
            style: AppTextStyles.large.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'categories_subtitle'.tr(),
            style: AppTextStyles.small.copyWith(
              color: theme.hintColor,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ...allCategories.map((cat) => _buildCategoryTile(
            context, cat, provider, isDark, theme,
          )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, String cat,
      QuoteProvider provider, bool isDark, ThemeData theme) {
    final isSelected = provider.selectedCategories.contains(cat);
    final color = _categoryColors[cat]!;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        provider.toggleCategory(cat);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(isDark ? 0.2 : 0.08)
              : (isDark ? const Color(0xFF1C1C1E) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : theme.colorScheme.onSurface.withOpacity(0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_categoryIcons[cat], color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'category_$cat'.tr(),
                style: AppTextStyles.medium.copyWith(
                  fontSize: 15.5,
                  color: theme.colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? color
                      : theme.colorScheme.onSurface.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
