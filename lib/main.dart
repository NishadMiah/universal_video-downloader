import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_video_downloader/core/bindings/initial_binding.dart';
import 'package:universal_video_downloader/core/di/locator.dart';
import 'package:universal_video_downloader/core/routes/app_pages.dart';
import 'package:universal_video_downloader/core/routes/app_routes.dart';
import 'package:universal_video_downloader/core/theme/app_theme.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Universal Video Downloader',
      theme: AppTheme.lightTheme,
      initialBinding: InitialBinding(),
      initialRoute: Routes.home,
      getPages: AppPages.pages,
    );
  }
}
