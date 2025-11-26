import 'dart:async';
import 'package:get/get.dart';
import 'package:share_handler/share_handler.dart';
import 'package:universal_video_downloader/core/di/locator.dart';
import 'package:universal_video_downloader/core/routes/app_routes.dart';
import 'package:universal_video_downloader/core/services/navigation_service.dart';

class SharingController extends GetxController {
  Rx<SharedMedia?> media = Rx<SharedMedia?>(null);
  StreamSubscription<SharedMedia>? _streamSubscription;
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void onInit() {
    super.onInit();
    _initSharing();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }

  Future<void> _initSharing() async {
    // Get initial shared media
    final initialMedia = await ShareHandler.instance.getInitialSharedMedia();
    if (initialMedia != null) {
      media.value = initialMedia;
      _handleSharedMedia(initialMedia);
    }

    // Listen for new shared media
    _streamSubscription = ShareHandler.instance.sharedMediaStream
        .listen((SharedMedia sharedMedia) {
      media.value = sharedMedia;
      _handleSharedMedia(sharedMedia);
    });
  }

  void _handleSharedMedia(SharedMedia media) {
    String? url;
    if (media.content != null && media.content!.isNotEmpty) {
      url = media.content;
    } else if (media.attachments != null && media.attachments!.isNotEmpty) {
      url = media.attachments?.first?.path;
    }

    if (url != null) {
      _navigationService.navigateTo(Routes.download, arguments: url);
    }
  }
}
