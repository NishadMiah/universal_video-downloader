import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:universal_video_downloader/core/utils/permission_utils.dart';
import 'package:universal_video_downloader/features/downloader/widgets/download_dialog_widget.dart';

class DownloadController extends GetxController {
  late final WebViewController webViewController;

  final RxString videoUrl = ''.obs;
  final RxString thumbnailUrl = ''.obs;
  final RxBool isLoading = true.obs;
  final RxBool isDownloading = false.obs;
  final RxString downloadedFilePath = ''.obs;

  String? initialUrl;

  DownloadController();

  @override
  void onInit() {
    super.onInit();
    initialUrl = Get.arguments as String?;
    if (initialUrl != null) {
      _initializeWebView(initialUrl!);
    }
  }

  void _initializeWebView(String url) {
    // Set a timeout to stop loading if it takes too long
    Future.delayed(const Duration(seconds: 15), () {
      if (isLoading.value) {
        isLoading.value = false;
        videoUrl.value = 'no_video';
        Get.snackbar("Error", "Connection timed out. Please try again.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    });

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url.split('?').first))
      ..setUserAgent(
          "Mozilla/5.0 (Linux; Android 10; Mobile; rv:125.0) Gecko/125.0 Firefox/125.0") // Generic Mobile User Agent
      ..addJavaScriptChannel('VideoExtractor', onMessageReceived: (message) {
        final data = message.message.split('|');
        if (data[0] == 'debug') {
          return;
        }
        if (data[0] != 'no_video') {
          videoUrl.value = data[0];
          thumbnailUrl.value = data.length > 1 ? data[1] : 'Not Found';
          isLoading.value = false;
        }
      })
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          _parseVideo();
        },
        onWebResourceError: (error) {
          // Handle error
        },
      ));
  }

  Future<void> _parseVideo() async {
    const script = '''
    {
      console.log("Starting universal extraction script...");
      VideoExtractor.postMessage('debug|Starting extraction');
      
      function extractVideoData() {
        // Try to find ANY video tag
        const videoElements = document.getElementsByTagName('video');
        const thumbnailElement = document.querySelector('meta[property="og:image"]');
        const thumbnailSrc = thumbnailElement ? thumbnailElement.content : 'no_thumbnail';

        for (let i = 0; i < videoElements.length; i++) {
          const video = videoElements[i];
          if (video.src && video.src.startsWith('http')) {
             VideoExtractor.postMessage(video.src + '|' + thumbnailSrc);
             return true;
          }
          // Check for source children
          const sources = video.getElementsByTagName('source');
          for (let j = 0; j < sources.length; j++) {
            if (sources[j].src && sources[j].src.startsWith('http')) {
               VideoExtractor.postMessage(sources[j].src + '|' + thumbnailSrc);
               return true;
            }
          }
        }
        
        VideoExtractor.postMessage('debug|No valid video found yet');
        return false;
      }
      
      // Check every 1000ms for 15 seconds
      let attempts = 0;
      const interval = setInterval(() => {
        const found = extractVideoData();
        attempts++;
        if (found || attempts > 15) clearInterval(interval);
      }, 1000);
    }
    ''';
    try {
      await webViewController.runJavaScript(script);
    } catch (e) {
      // Handle error
    }
  }

  Future<void> downloadVideo() async {
    if (videoUrl.value.isEmpty || videoUrl.value == 'no_video') {
      Get.snackbar("Error", "No video URL found!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    bool permitted = await PermissionUtil.requestStoragePermission();
    if (!permitted) {
      Get.snackbar("Permission Denied", "Storage permission denied",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isDownloading.value = true;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: DownloadDialogWidget(
          videoUrl: videoUrl.value,
          isDownloaded: (path) {
            isDownloading.value = false;
            downloadedFilePath.value = path;
            print("DEBUG: Downloaded to $path");
          },
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> shareVideo() async {
    if (downloadedFilePath.value.isNotEmpty) {
      // ignore: deprecated_member_use
      await Share.shareXFiles([XFile(downloadedFilePath.value)],
          text: 'Check out this video!');
    } else {
      Get.snackbar("Error", "No video downloaded to share!",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
