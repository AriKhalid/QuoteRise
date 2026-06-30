import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../components/app_button.dart';
import '../components/app_colors.dart';
import '../components/app_drag_handle.dart';
import '../components/app_text_styles.dart';
import '../components/notification_service.dart';
import '../components/quote_provider.dart';

class NotificationBottomSheet extends StatefulWidget {
  const NotificationBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const NotificationBottomSheet(),
    );
  }

  @override
  State<NotificationBottomSheet> createState() => _NotificationBottomSheetState();
}

class _NotificationBottomSheetState extends State<NotificationBottomSheet> {
  bool _enabled = false;
  int _hour = 9;
  int _minute = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final data = await NotificationService.load();
    setState(() {
      _enabled = data['enabled'];
      _hour = data['hour'];
      _minute = data['minute'];
      _loading = false;
    });
  }

  Future<void> _save() async {
    HapticFeedback.mediumImpact();
    final provider = context.read<QuoteProvider>();
    final quote = provider.current;

    if (_enabled && quote != null) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('notif_permission_denied'.tr())),
          );
        }
        return;
      }
      await NotificationService.schedule(
        hour: _hour,
        minute: _minute,
        quoteText: quote.text,
        author: quote.author,
      );
    } else {
      await NotificationService.cancel();
    }

    await NotificationService.save(enabled: _enabled, hour: _hour, minute: _minute);
    if (mounted) Navigator.pop(context);
  }

  void _showTimePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (_) => SizedBox(
        height: 250,
        child: CupertinoTimerPicker(
          mode: CupertinoTimerPickerMode.hm,
          initialTimerDuration: Duration(hours: _hour, minutes: _minute),
          onTimerDurationChanged: (duration) {
            setState(() {
              _hour = duration.inHours;
              _minute = duration.inMinutes % 60;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<QuoteProvider>();
    final quote = provider.current;
    final isFixed = provider.mode == QuoteMode.fixed;

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
      child: _loading
          ? const SizedBox(height: 100, child: Center(child: CircularProgressIndicator(color: AppColors.primaryButtonColor)))
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppDragHandle(),
                const SizedBox(height: 24),
                Text(
                  'daily_reminder'.tr(),
                  style: AppTextStyles.large.copyWith(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Card 1: Enable toggle
                _buildCard(
                  isDark: isDark,
                  theme: theme,
                  title: 'notif_enable'.tr(),
                  description: 'notif_enable_desc'.tr(),
                  bottomContent: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.notifications_outlined,
                          color: _enabled ? AppColors.primaryButtonColor : Colors.grey.shade500,
                          size: 20),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'notif_enable'.tr(),
                            style: AppTextStyles.medium.copyWith(fontSize: 15),
                          ),
                        ),
                        CupertinoSwitch(
                          value: _enabled,
                          activeTrackColor: AppColors.primaryButtonColor,
                          onChanged: (v) => setState(() => _enabled = v),
                        ),
                      ],
                    ),
                  ),
                ),

                if (_enabled) ...[
                  const SizedBox(height: 16),

                  // Card 2: Time picker
                  _buildCard(
                    isDark: isDark,
                    theme: theme,
                    title: 'notif_time'.tr(),
                    description: 'notif_time_desc'.tr(),
                    bottomContent: _buildActionRow(
                      isDark: isDark,
                      icon: Icons.access_time_rounded,
                      title: '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
                      subtitle: 'notif_tap_to_change'.tr(),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _showTimePicker();
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Card 3: Quote preview
                  if (quote != null)
                    _buildCard(
                      isDark: isDark,
                      theme: theme,
                      title: isFixed ? 'notif_fixed_quote'.tr() : 'notif_daily_quote'.tr(),
                      description: '"${quote.text}"\n— ${quote.author}',
                      bottomContent: null,
                    ),
                ],

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

  Widget _buildCard({
    required bool isDark,
    required ThemeData theme,
    required String title,
    required String description,
    Widget? bottomContent,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.transparent,
        ),
        boxShadow: isDark ? [] : [
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
          Text(title,
            style: AppTextStyles.medium.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(description,
            style: AppTextStyles.small.copyWith(
              color: Colors.grey.shade600, fontSize: 13.5, height: 1.4)),
          if (bottomContent != null) ...[
            const SizedBox(height: 14),
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
              Icon(icon, color: AppColors.primaryButtonColor, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                      style: AppTextStyles.medium.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 18,
                        color: AppColors.primaryButtonColor)),
                    Text(subtitle,
                      style: AppTextStyles.small.copyWith(
                        color: Colors.grey.shade500, fontSize: 12)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
