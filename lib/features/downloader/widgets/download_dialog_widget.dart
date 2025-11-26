import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saver_gallery/saver_gallery.dart';

class DownloadDialogWidget extends StatefulWidget {
  final Function(String)
      isDownloaded; // Callback function to notify when download is completed
  final String videoUrl; // URL of the video to be downloaded

  const DownloadDialogWidget(
      {super.key, required this.isDownloaded, required this.videoUrl});

  @override
  State<DownloadDialogWidget> createState() => _DownloadDialogWidgetState();
}

class _DownloadDialogWidgetState extends State<DownloadDialogWidget> {
  double _progress = 0; // Variable to track download progress
  final Dio _dio = Dio(); // Dio instance for handling HTTP requests

  @override
  void initState() {
    super.initState();
    download(); // Start download automatically when widget is initialized
  }

  // Function to download the video
  download() async {
    String? filePath;
    try {
      final tempDir = Directory.systemTemp; // Get temporary directory
      filePath =
          '${tempDir.path}/downloaded_video.mp4'; // Set file path for download

      // Start the video download using Dio
      await _dio.download(
        widget.videoUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _progress = received / total; // Update progress percentage
            });
          }
        },
      );

      // Save the downloaded file to the device gallery
      await SaverGallery.saveFile(
          filePath: filePath,
          fileName: "insta_reel_${DateTime.now().toIso8601String()}",
          androidRelativePath:
              "Movies/Insta Downloads", // Path where file will be saved
          skipIfExists: false);
    } catch (e) {
      // Show error message if download fails
      Get.snackbar(
        "Error",
        "Download failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Close the download dialog and notify that download is complete
      Get.back();
      if (filePath != null) {
        widget.isDownloaded(filePath);
      }

      // Show success message after download completion
      Get.snackbar(
        "Success",
        "Downloaded Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *
          0.90, // Set dialog width to 90% of screen width
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Ensure column takes minimum required space
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Circular progress indicator to show download progress
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 2,
                ),
                // Download icon placed at the center of the progress indicator
                Icon(
                  Icons.download,
                  size: 21,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 15),
            // Displaying the download progress percentage
            Text(
              "Downloading ${(_progress * 100).toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
