import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components/app_colors.dart';
import '../components/app_text_styles.dart';
import '../components/app_drag_handle.dart';

class LegalBottomSheet extends StatelessWidget {
  const LegalBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const LegalBottomSheet(),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Konnte Link nicht öffnen');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.75,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 16, 16),
            child: Column(
              children: [
                const AppDragHandle(),
                const SizedBox(height: 16),
                Text(
                  'legal_and_credits'.tr(),
                  style: AppTextStyles.large.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- DSGVO ---
                  _buildSectionHeader('dsgvo_title'.tr(), Icons.privacy_tip_outlined, const Color(0xFF5856D6), theme),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    theme: theme,
                    isDark: isDark,
                    children: [
                      _buildPrivacyRow(Icons.storage_outlined, 'dsgvo_no_server'.tr(), theme),
                      _buildDivider(theme),
                      _buildPrivacyRow(Icons.person_off_outlined, 'dsgvo_no_personal'.tr(), theme),
                      _buildDivider(theme),
                      _buildPrivacyRow(Icons.phone_android_outlined, 'dsgvo_local_only'.tr(), theme),
                      _buildDivider(theme),
                      _buildPrivacyRow(Icons.visibility_off_outlined, 'dsgvo_no_tracking'.tr(), theme),
                      _buildDivider(theme),
                      _buildPrivacyRow(Icons.text_fields_rounded, 'dsgvo_fonts_local'.tr(), theme),
                      _buildDivider(theme),
                      _buildPrivacyRow(Icons.wifi_off_rounded, 'dsgvo_offline'.tr(), theme),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- FONTS ---
                  _buildSectionHeader('credits_fonts'.tr(), Icons.text_fields_rounded, const Color(0xFF34C759), theme),
                  const SizedBox(height: 10),
                  _buildInfoCard(
                    theme: theme,
                    isDark: isDark,
                    children: [
                      _buildFontRow('Lato', 'Łukasz Dziedzic', theme),
                      _buildDivider(theme),
                      _buildFontRow('Playfair Display', 'Claus Eggers Sørensen', theme),
                      _buildDivider(theme),
                      _buildFontRow('Nunito', 'Vernon Adams', theme),
                      _buildDivider(theme),
                      _buildFontRow('Raleway', 'Matt McInerney et al.', theme),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 24),
                    child: Text(
                      'credits_fonts_license'.tr(),
                      style: AppTextStyles.small.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        fontSize: 11,
                      ),
                    ),
                  ),

                  // --- CREDITS ---
                  _buildSectionHeader('credits_title'.tr(), Icons.favorite_outline_rounded, Colors.orange, theme),
                  const SizedBox(height: 10),
                  _buildCreditCard(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.pets_rounded,
                    iconColor: Colors.orange,
                    title: 'credit_cat_title'.tr(),
                    subtitle: 'credit_cat_author'.tr(),
                    onViewAnimation: () => _launchUrl('https://lottiefiles.com/6opvp22e1jxk6qq1'),
                    onViewAuthor: () => _launchUrl('https://lottiefiles.com/diane_soko'),
                    authorName: 'Diane Soko',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color, ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 15),
        ),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: AppTextStyles.small.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withOpacity(0.55),
            letterSpacing: 1.1,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildPrivacyRow(IconData icon, String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryButtonColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.medium.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 14.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 0.5,
      indent: 52,
      endIndent: 0,
      color: theme.colorScheme.onSurface.withOpacity(0.08),
    );
  }

  Widget _buildFontRow(String fontName, String author, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.font_download_outlined, color: Color(0xFF34C759), size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              fontName,
              style: AppTextStyles.medium.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 14.5,
              ),
            ),
          ),
          Text(
            author,
            style: AppTextStyles.small.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.45),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreditCard({
    required ThemeData theme,
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onViewAnimation,
    required VoidCallback onViewAuthor,
    required String authorName,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.medium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTextStyles.small.copyWith(color: theme.hintColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onViewAnimation,
            icon: const Icon(Icons.animation_outlined, size: 17),
            label: Text('credit_view_animation'.tr()),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              foregroundColor: theme.primaryColor,
              side: BorderSide(color: theme.primaryColor.withOpacity(0.4)),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onViewAuthor,
            icon: const Icon(Icons.person_outline, size: 17),
            label: Text(authorName),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              foregroundColor: theme.hintColor,
              side: BorderSide(color: theme.dividerColor),
            ),
          ),
        ],
      ),
    );
  }
}
