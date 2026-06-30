import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'components/app_colors.dart';
import 'components/app_text_styles.dart';
import 'components/quote_provider.dart';
import 'settings/quote_mode_bottom_sheet.dart';
import 'settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  String _lastLang = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final lang = context.locale.languageCode;
    if (lang != _lastLang) {
      _lastLang = lang;
      context.read<QuoteProvider>().load(lang);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index != _currentPage) {
      HapticFeedback.mediumImpact();
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    if (index != _currentPage) HapticFeedback.lightImpact();
                    setState(() => _currentPage = index);
                  },
                  children: const [
                    _QuotesView(),
                    SettingsPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.onSurface;
    final inactiveColor = theme.colorScheme.onSurface.withOpacity(0.4);

    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 16, top: 16, bottom: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _onTabTapped(0),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.large.copyWith(
                color: _currentPage == 0 ? activeColor : inactiveColor,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
              child: const Text('QuoteRise'),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _onTabTapped(1),
            child: AnimatedRotation(
              turns: _currentPage == 1 ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedScale(
                scale: _currentPage == 1 ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  CupertinoIcons.settings,
                  size: 26,
                  color: _currentPage == 1 ? activeColor : inactiveColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuotesView extends StatelessWidget {
  const _QuotesView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuoteProvider>();

    if (!provider.isLoaded) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryButtonColor),
      );
    }

    final quote = provider.current!;

    return Stack(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          child: _QuoteCard(key: ValueKey(provider.currentIndex), quote: quote),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (provider.mode == QuoteMode.fixed) {
                QuoteModeBottomSheet.show(context);
              } else {
                final next = (provider.currentIndex + 1) % provider.quotes.length;
                provider.goTo(next);
              }
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: provider.mode == QuoteMode.fixed
                    ? AppColors.primaryButtonColor.withOpacity(0.4)
                    : AppColors.primaryButtonColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryButtonColor.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                provider.mode == QuoteMode.fixed
                    ? Icons.push_pin_rounded
                    : Icons.refresh_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuoteCard extends StatelessWidget {
  final Quote quote;
  const _QuoteCard({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
      child: Column(
        children: [
          // Zitat + Autor zusammen zentriert
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quote.text,
                    textAlign: TextAlign.left,
                    style: AppTextStyles.large.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '— ${quote.author}',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.medium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
