import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/app_colors.dart';
import 'components/theme_provider.dart';
import 'components/font_provider.dart';
import 'components/quote_provider.dart';
import 'components/notification_service.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await NotificationService.init();

  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('selected_language') ?? 'en';

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'), Locale('de'), Locale('es'), Locale('fr'),
        Locale('it'), Locale('pt'), Locale('ru'), Locale('hi'),
        Locale('zh'), Locale('ja'), Locale('ar'),
      ],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      startLocale: Locale(savedLang),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => FontProvider()),
          ChangeNotifierProvider(create: (_) => QuoteProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final fontProvider = context.watch<FontProvider>();
    final fontFamily = fontProvider.font.fontFamily;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ...context.localizationDelegates,
      ],
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        cardColor: AppColors.blockLight,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryButtonColor,
          surface: AppColors.blockLight,
          onSurface: AppColors.textPrimaryLight,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: fontFamily,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        cardColor: AppColors.blockDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryButtonColor,
          surface: AppColors.blockDark,
          onSurface: AppColors.textPrimaryDark,
        ),
      ),
      home: const HomePage(),
    );
  }
}
