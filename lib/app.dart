import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class REDvsBLUEApp extends ConsumerWidget {
  const REDvsBLUEApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X dimensions
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'REDvsBLUE',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light, // Can be controlled by provider later
          routerConfig: router,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            // Ensure text scaling doesn't break UI
            final mediaQueryData = MediaQuery.of(context);
            final scale = mediaQueryData.textScaleFactor.clamp(0.8, 1.2);

            return MediaQuery(
              data: MediaQueryData(
                size: mediaQueryData.size,
                devicePixelRatio: mediaQueryData.devicePixelRatio,
                textScaleFactor: scale,
                padding: mediaQueryData.padding,
                viewInsets: mediaQueryData.viewInsets,
                systemGestureInsets: mediaQueryData.systemGestureInsets,
                viewPadding: mediaQueryData.viewPadding,
                alwaysUse24HourFormat: mediaQueryData.alwaysUse24HourFormat,
                accessibleNavigation: mediaQueryData.accessibleNavigation,
                invertColors: mediaQueryData.invertColors,
                highContrast: mediaQueryData.highContrast,
                disableAnimations: mediaQueryData.disableAnimations,
                boldText: mediaQueryData.boldText,
                navigationMode: mediaQueryData.navigationMode,
                gestureSettings: mediaQueryData.gestureSettings,
                displayFeatures: mediaQueryData.displayFeatures,
              ),
              child: widget!,
            );
          },
        );
      },
    );
  }
}