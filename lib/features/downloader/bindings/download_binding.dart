import 'package:get/get.dart';
import 'package:universal_video_downloader/features/downloader/controllers/download_controller.dart';

class DownloadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownloadController>(() => DownloadController());
  }
}
