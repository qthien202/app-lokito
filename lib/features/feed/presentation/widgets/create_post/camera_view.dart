import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CameraView extends StatelessWidget {
  final CameraController? cameraController;
  final bool isCameraInitialized;
  final bool isFlashOn;
  final VoidCallback onTakePicture;
  final VoidCallback onPickFromGallery;
  final VoidCallback onFlipCamera;
  final VoidCallback onToggleFlash;
  final VoidCallback onShowHistory;

  const CameraView({
    super.key,
    required this.cameraController,
    required this.isCameraInitialized,
    required this.isFlashOn,
    required this.onTakePicture,
    required this.onPickFromGallery,
    required this.onFlipCamera,
    required this.onToggleFlash,
    required this.onShowHistory,
  });

  @override
  Widget build(BuildContext context) {
    // Luôn hiển thị UI giả lập để dev các tính năng khác mà không bị vướng bởi log camera
    /*
    if (!isCameraInitialized ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    */

    return Column(
      children: [
        // 1. Viewfinder (Placeholder mode to stop logs)
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(64),
                  color: const Color(0xFF1A1A1A),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.cameraOff,
                          color: Colors.white.withOpacity(0.2),
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Camera paused for development",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // 2. Control Row (Flash - SHUTTER - Flip)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Flash (Left side)
              Expanded(
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      isFlashOn ? LucideIcons.zap : LucideIcons.zapOff,
                      color: isFlashOn ? Colors.yellow : Colors.white,
                      size: 28,
                    ),
                    onPressed: onToggleFlash,
                  ),
                ),
              ),

              // Shutter (Center)
              GestureDetector(
                onTap: onTakePicture,
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),

              // Flip (Right side)
              Expanded(
                child: Center(
                  child: IconButton(
                    icon: const Icon(
                      LucideIcons.refreshCw,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: onFlipCamera,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 48),
      ],
    );
  }
}
