import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:universal_video_downloader/core/di/locator.dart';
import 'package:universal_video_downloader/core/routes/app_routes.dart';
import 'package:universal_video_downloader/core/services/navigation_service.dart';
import 'package:universal_video_downloader/core/utils/permission_utils.dart';

class UrlInputController extends GetxController {
  final TextEditingController urlController = TextEditingController();
  final RxBool isValidUrl = false.obs;
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> pasteFromClipboard() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      urlController.text = data.text!;
      validateUrl(data.text!);
    }
  }

  void validateUrl(String url) {
    isValidUrl.value = Uri.tryParse(url)?.hasAbsolutePath ?? false;
  }

  Future<void> navigateToDownloadPage() async {
    bool permitted = await PermissionUtil.requestStoragePermission();

    if (permitted) {
      _navigationService.navigateTo(Routes.download,
          arguments: urlController.text);
    } else {
      Get.snackbar("Permission Denied", "Storage permission denied",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    urlController.dispose();
    super.onClose();
  }
}
