import 'package:get/get.dart';
import 'package:universal_video_downloader/features/home/controllers/url_input_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UrlInputController>(() => UrlInputController());
  }
}
