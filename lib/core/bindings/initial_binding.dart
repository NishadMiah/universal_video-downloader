import 'package:get/get.dart';
import 'package:universal_video_downloader/features/sharing/controllers/sharing_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SharingController());
  }
}
