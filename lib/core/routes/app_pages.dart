import 'package:get/get.dart';
import 'package:universal_video_downloader/core/routes/app_routes.dart';
import 'package:universal_video_downloader/features/downloader/bindings/download_binding.dart';
import 'package:universal_video_downloader/features/downloader/views/downloader_page.dart';
import 'package:universal_video_downloader/features/home/bindings/home_binding.dart';
import 'package:universal_video_downloader/features/home/views/home_page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.download,
      page: () => const DownloaderPage(),
      binding: DownloadBinding(),
    ),
  ];
}
