import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/app_colors.dart';
import '../components/app_drag_handle.dart';
import '../components/app_text_styles.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AppDragHandle(),
          const SizedBox(height: 24),
          Text(
            'language'.tr(),
            style: AppTextStyles.large.copyWith(
              fontSize: 20,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.black, Colors.transparent],
                    stops: [0.0, 0.85, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstIn,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageOption(context, label: "English",    code: "en", flagEmoji: "🇺🇸"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "Deutsch",    code: "de", flagEmoji: "🇩🇪"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "Español",    code: "es", flagEmoji: "🇪🇸"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "Français",   code: "fr", flagEmoji: "🇫🇷"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "Italiano",   code: "it", flagEmoji: "🇮🇹"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "Português",  code: "pt", flagEmoji: "🇵🇹"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "Русский",    code: "ru", flagEmoji: "🇷🇺"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "हिन्दी",      code: "hi", flagEmoji: "🇮🇳"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "中文",        code: "zh", flagEmoji: "🇨🇳"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "日本語",      code: "ja", flagEmoji: "🇯🇵"),
                        const SizedBox(height: 12),
                        _buildLanguageOption(context, label: "العربية",    code: "ar", flagEmoji: "🇸🇦"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String label,
    required String code,
    required String flagEmoji,
  }) {
    final theme = Theme.of(context);
    final isSelected = context.locale.languageCode == code;
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: () async {
        HapticFeedback.mediumImpact();
        await context.setLocale(Locale(code));
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_language', code);
        if (context.mounted) Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryButtonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? Colors.white24 : Colors.grey.shade200),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(flagEmoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Text(
              label,
              style: AppTextStyles.medium.copyWith(
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 22),
          ],
        ),
      ),
    );
  }
}
