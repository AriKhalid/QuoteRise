import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:easy_localization/easy_localization.dart';

import '../components/app_text_styles.dart';
import '../components/theme_provider.dart';
import 'language_bottom_sheet.dart';
// TODO: Replace with In-App Purchase
// import 'coffee_info_sheet.dart';
import 'legal_bottom_sheet.dart';
import 'font_bottom_sheet.dart';
import 'category_bottom_sheet.dart';
import 'quote_mode_bottom_sheet.dart';
import 'notification_bottom_sheet.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  // Wird als const im PageView verwendet
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const List<LinearGradient> _iconGradients = [
    LinearGradient(
      colors: [Color(0xFF00C6FB), Color(0xFF005BEA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF654ea3), Color(0xFFeaafc8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFC33764), Color(0xFF1D2671)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF56ab2f), Color(0xFFa8e063)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFDA22FF), Color(0xFF9733EE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFFFDC830), Color(0xFFF37335)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF414345), Color(0xFF232526)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF6a11cb), Color(0xFF2575fc)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF4D330C), Color(0xFFD4AF37)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  static const _darkModeGradient = LinearGradient(
    colors: [Color(0xFF141E30), Color(0xFF243B55)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
                  _buildSectionHeader('settings'.tr(), theme),
                  _buildSettingsGroup(
                    theme: theme,
                    children: [
                      _buildDarkModeItem(themeProvider, theme, isDark),
                      _buildDivider(theme),
                      _buildGradientListItem(
                        icon: Icons.language,
                        text: 'language'.tr(),
                        gradient: _iconGradients[2],
                        theme: theme,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => const LanguageBottomSheet(),
                          );
                        },
                      ),
                      _buildDivider(theme),
                      _buildGradientListItem(
                        icon: Icons.text_fields_rounded,
                        text: 'font_style'.tr(),
                        gradient: _iconGradients[1],
                        theme: theme,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          FontBottomSheet.show(context);
                        },
                      ),
                      _buildDivider(theme),
                      _buildGradientListItem(
                        icon: Icons.push_pin_outlined,
                        text: 'quote_mode'.tr(),
                        gradient: _iconGradients[3],
                        theme: theme,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          QuoteModeBottomSheet.show(context);
                        },
                      ),
                      _buildDivider(theme),
                      _buildGradientListItem(
                        icon: Icons.category_outlined,
                        text: 'categories'.tr(),
                        gradient: _iconGradients[4],
                        theme: theme,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          CategoryBottomSheet.show(context);
                        },
                      ),
                    ],
                  ),
                  _buildSectionHeader('notifications'.tr(), theme),
                  _buildSettingsGroup(
                    theme: theme,
                    children: [
                      _buildGradientListItem(
                        icon: Icons.notifications_outlined,
                        text: 'daily_reminder'.tr(),
                        gradient: _iconGradients[6],
                        theme: theme,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          NotificationBottomSheet.show(context);
                        },
                      ),
                    ],
                  ),
                  // TODO: Replace with In-App Purchase
                  // _buildSectionHeader('support'.tr(), theme),
                  // _buildSettingsGroup(
                  //   theme: theme,
                  //   children: [
                  //     _buildGradientListItem(
                  //       icon: Icons.coffee_rounded,
                  //       text: 'buy_me_a_coffee'.tr(),
                  //       gradient: _iconGradients[11],
                  //       theme: theme,
                  //       onTap: () {
                  //         HapticFeedback.mediumImpact();
                  //         CoffeeInfoSheet.show(context);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  _buildSectionHeader('others'.tr(), theme),
                  _buildSettingsGroup(
                    theme: theme,
                    children: [
                      _buildGradientListItem(
                        icon: Icons.gavel_outlined,
                        text: 'legal_and_credits'.tr(),
                        gradient: _iconGradients[0],
                        theme: theme,
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          LegalBottomSheet.show(context);
                        },
                      ),
                    ],
                  ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // 1:1 aus stay_alive
  Widget _buildSettingsGroup({
    required List<Widget> children,
    required ThemeData theme,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (theme.brightness == Brightness.light)
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Column(children: children),
      ),
    );
  }

  // 1:1 aus stay_alive
  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.small.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface.withOpacity(0.8),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // 1:1 aus stay_alive
  Widget _buildGradientListItem({
    required IconData icon,
    required String text,
    required LinearGradient gradient,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: AppTextStyles.medium.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15.5,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: theme.iconTheme.color?.withOpacity(0.2),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 1:1 aus stay_alive
  Widget _buildDarkModeItem(
    ThemeProvider themeProvider,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: _darkModeGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Dark Mode',
              style: AppTextStyles.medium.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 15.5,
              ),
            ),
          ),
          CupertinoSwitch(
            value: isDark,
            activeTrackColor: theme.colorScheme.primary,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
    );
  }

  // 1:1 aus stay_alive
  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 0.8,
      indent: 64,
      endIndent: 0,
      color: theme.colorScheme.onSurface.withOpacity(0.1),
    );
  }
}
