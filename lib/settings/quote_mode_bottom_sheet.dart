import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../components/app_colors.dart';
import '../components/app_button.dart';
import '../components/app_text_styles.dart';
import '../components/app_drag_handle.dart';
import '../components/quote_provider.dart';

class QuoteModeBottomSheet extends StatefulWidget {
  const QuoteModeBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const QuoteModeBottomSheet(),
    );
  }

  @override
  State<QuoteModeBottomSheet> createState() => _QuoteModeBottomSheetState();
}

class _QuoteModeBottomSheetState extends State<QuoteModeBottomSheet> {
  late QuoteMode _selectedMode;
  late int _selectedFixedIndex;

  @override
  void initState() {
    super.initState();
    final provider = context.read<QuoteProvider>();
    _selectedMode = provider.mode;
    _selectedFixedIndex = provider.fixedIndex;
  }

  void _save() {
    final provider = context.read<QuoteProvider>();
    if (_selectedMode == QuoteMode.fixed) {
      provider.setFixedQuote(_selectedFixedIndex);
    } else {
      provider.setMode(QuoteMode.daily);
    }
    Navigator.pop(context);
  }

  void _showQuotePicker() {
    final provider = context.read<QuoteProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _QuotePickerSheet(
        quotes: provider.quotes,
        selectedIndex: _selectedFixedIndex,
        onSelected: (index) {
          setState(() => _selectedFixedIndex = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.read<QuoteProvider>();

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        24, 12, 24,
        MediaQuery.of(context).viewInsets.bottom + 40,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppDragHandle(),
          const SizedBox(height: 24),
          Text(
            'quote_mode'.tr(),
            style: AppTextStyles.large.copyWith(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Card 1: Täglich
          _buildSettingsCard(
            isDark: isDark,
            theme: theme,
            isSelected: _selectedMode == QuoteMode.daily,
            title: 'mode_daily'.tr(),
            description: 'mode_daily_desc'.tr(),
            bottomContent: _buildActionRow(
              isDark: isDark,
              icon: Icons.calendar_today_outlined,
              title: 'mode_daily'.tr(),
              subtitle: 'mode_daily_sub'.tr(),
              isActive: _selectedMode == QuoteMode.daily,
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _selectedMode = QuoteMode.daily);
              },
            ),
          ),

          const SizedBox(height: 16),

          // Card 2: Fest
          _buildSettingsCard(
            isDark: isDark,
            theme: theme,
            isSelected: _selectedMode == QuoteMode.fixed,
            title: 'mode_fixed'.tr(),
            description: 'mode_fixed_desc'.tr(),
            bottomContent: _buildActionRow(
              isDark: isDark,
              icon: Icons.push_pin_outlined,
              title: _selectedMode == QuoteMode.fixed && provider.quotes.isNotEmpty && _selectedFixedIndex < provider.quotes.length
                  ? '"${provider.quotes[_selectedFixedIndex].text.substring(0, provider.quotes[_selectedFixedIndex].text.length.clamp(0, 30))}…"'
                  : 'mode_fixed'.tr(),
              subtitle: 'fixed_quote_pick'.tr(),
              isActive: _selectedMode == QuoteMode.fixed,
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() => _selectedMode = QuoteMode.fixed);
                _showQuotePicker();
              },
            ),
          ),

          const SizedBox(height: 32),

          AppButton(
            text: 'save'.tr(),
            onPressed: _save,
            backgroundColor: AppColors.primaryButtonColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required bool isDark,
    required ThemeData theme,
    required bool isSelected,
    required String title,
    required String description,
    Widget? bottomContent,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryButtonColor
              : (isDark ? Colors.white10 : Colors.transparent),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.medium.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: AppTextStyles.small.copyWith(
              color: Colors.grey.shade600,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          if (bottomContent != null) ...[
            const SizedBox(height: 16),
            bottomContent,
          ],
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon,
                color: isActive ? AppColors.primaryButtonColor : Colors.grey.shade500,
                size: 20,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.medium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isActive ? AppColors.primaryButtonColor : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTextStyles.small.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuotePickerSheet extends StatefulWidget {
  final List<Quote> quotes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _QuotePickerSheet({
    required this.quotes,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  State<_QuotePickerSheet> createState() => _QuotePickerSheetState();
}

class _QuotePickerSheetState extends State<_QuotePickerSheet> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          children: [
            const AppDragHandle(),
            const SizedBox(height: 16),
            Text(
              'fixed_quote_pick'.tr(),
              style: AppTextStyles.large.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.quotes.length,
                itemBuilder: (_, index) {
                  final quote = widget.quotes[index];
                  final isSelected = _selected == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selected = index);
                      widget.onSelected(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryButtonColor.withOpacity(isDark ? 0.2 : 0.08)
                            : (isDark ? const Color(0xFF1C1C1E) : Colors.white),
                        borderRadius: BorderRadius.circular(14),
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
                                  quote.text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.small.copyWith(
                                    fontSize: 13.5,
                                    height: 1.4,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '— ${quote.author}',
                                  style: AppTextStyles.small.copyWith(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurface.withOpacity(0.45),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 10),
                            const Icon(Icons.push_pin_rounded,
                                color: AppColors.primaryButtonColor, size: 18),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
