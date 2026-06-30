import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

import '../components/app_colors.dart';
import '../components/app_text_styles.dart';
import '../components/app_drag_handle.dart';
import '../components/app_button.dart';

class CoffeeInfoSheet extends StatelessWidget {
  const CoffeeInfoSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const CoffeeInfoSheet(),
    );
  }

  // TODO: Replace with In-App Purchase
  // Future<void> _launchCoffeeUrl() async {
  //   final Uri url = Uri.parse('https://www.buymeacoffee.com/AriKhalidd1');
  //   if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
  //     debugPrint('Konnte Link nicht öffnen');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppDragHandle(),
            const SizedBox(height: 24),
            Text(
              'buy_me_a_coffee'.tr(),
              style: AppTextStyles.large.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'coffee_desc'.tr(),
              style: AppTextStyles.medium.copyWith(
                color: theme.hintColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.primaryButtonColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primaryButtonColor.withOpacity(0.15),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'coffee_label'.tr(),
                      style: AppTextStyles.small.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryButtonColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primaryButtonColor,
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: Lottie.asset(
                'lib/images/cat_standing.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 32),
            // TODO: Replace with In-App Purchase
            // SizedBox(
            //   width: double.infinity,
            //   child: AppButton(
            //     text: 'support_now'.tr(),
            //     icon: Icons.coffee_rounded,
            //     backgroundColor: AppColors.primaryButtonColor,
            //     textColor: Colors.white,
            //     onPressed: () {
            //       Navigator.pop(context);
            //       _launchCoffeeUrl();
            //     },
            //   ),
            // ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'got_it'.tr(),
                style: AppTextStyles.medium.copyWith(color: theme.hintColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
