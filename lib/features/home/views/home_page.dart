import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_video_downloader/core/theme/app_theme.dart';
import 'package:universal_video_downloader/features/home/controllers/url_input_controller.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends GetView<UrlInputController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Hero Section
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.primaryGradient.scale(0.1),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) =>
                        AppTheme.primaryGradient.createShader(bounds),
                    child: const Icon(
                      Icons.download_for_offline_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Universal Video Downloader',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Download Videos instantly',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 48),

              // Input Section
              TextField(
                controller: controller.urlController,
                decoration: InputDecoration(
                  hintText: 'Paste Video Link here...',
                  prefixIcon: const Icon(Icons.link_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.paste_rounded),
                    onPressed: () async {
                      await controller.pasteFromClipboard();
                    },
                  ),
                ),
                onChanged: controller.validateUrl,
              ),
              const SizedBox(height: 24),

              // Action Button
              Obx(() => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: controller.isValidUrl.value
                          ? AppTheme.primaryGradient
                          : null,
                      color:
                          controller.isValidUrl.value ? null : Colors.grey[300],
                      boxShadow: controller.isValidUrl.value
                          ? [
                              BoxShadow(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              )
                            ]
                          : [],
                    ),
                    child: ElevatedButton(
                      onPressed: controller.isValidUrl.value
                          ? controller.navigateToDownloadPage
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        disabledForegroundColor: Colors.grey[500],
                      ),
                      child: const Text("Download Now"),
                    ),
                  )),

              const SizedBox(height: 60),

              // Instructions
              ...[
                _buildInstructionStep(
                  context,
                  "1",
                  "Copy Link",
                  "Open the video and copy the link.",
                ),
                _buildInstructionStep(
                  context,
                  "2",
                  "Paste Link",
                  "Paste the link in the box above.",
                ),
                _buildInstructionStep(
                  context,
                  "3",
                  "Download",
                  "Click Download and save it to your gallery.",
                ),
              ].animate(interval: 200.ms).fadeIn().slideX(begin: -0.2, end: 0),

              const SizedBox(height: 40),
              Center(
                child: Text(
                  "© ${DateTime.now().year} BlazeAura App Studio",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(
      BuildContext context, String step, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              step,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
