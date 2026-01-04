import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/features/feed/presentation/controllers/feed_controller.dart';
import 'package:lokito/features/feed/presentation/widgets/create_post/index.dart';
import 'package:lokito/i18n/strings.g.dart';
import 'package:lokito/shared/media_capture/media_capture_controller.dart';
import 'package:lokito/shared/media_capture/media_capture_state.dart';
import 'package:permission_handler/permission_handler.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen>
    with WidgetsBindingObserver {
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() => _initializeCamera());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _captionController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    } else {
      // Inactive, Paused, Detached: KILL the camera to stop dropped frame logs
      ref.read(mediaCaptureControllerProvider.notifier).disposeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    // Temporarily disable camera to stop log spam while developing other features
    /*
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      if (mounted) _showPermissionDialog();
      return;
    }
    await ref.read(mediaCaptureControllerProvider.notifier).initializeCamera();
    */
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.feed.createPost.cameraPermissionDenied),
        content: Text(t.feed.createPost.cameraPermissionRequired),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.feed.createPost.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text(t.feed.createPost.openSettings),
          ),
        ],
      ),
    );
  }

  void _handleBack() {
    final state = ref.read(mediaCaptureControllerProvider);
    if (state.capturedImage != null) {
      ref.read(mediaCaptureControllerProvider.notifier).retakePhoto();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _handleShare() async {
    final state = ref.read(mediaCaptureControllerProvider);
    final image = state.capturedImage;
    if (image == null) return;

    // Trigger creation in FeedController (Optimistic)
    ref
        .read(feedControllerProvider.notifier)
        .createPost(content: _captionController.text, file: image);

    // Close screen immediately
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mediaCaptureControllerProvider);
    final notifier = ref.read(mediaCaptureControllerProvider.notifier);

    ref.listen(mediaCaptureControllerProvider.select((s) => s.error), (
      prev,
      next,
    ) {
      if (next != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next), backgroundColor: Colors.red),
        );
        notifier.clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (state.capturedImage != null)
            Positioned.fill(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(state.capturedImage!, fit: BoxFit.cover),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(color: Colors.black.withOpacity(0.85)),
                  ),
                ],
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                TopControls(
                  currentStep: state.capturedImage != null
                      ? MediaCaptureStep.preview
                      : MediaCaptureStep.camera,
                  hasImage: state.capturedImage != null,
                  onBack: _handleBack,
                  onSend: _handleShare,
                  onGallery: notifier.pickFromGallery,
                ),
                Expanded(
                  child: state.capturedImage != null
                      ? SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: AspectRatio(
                                    aspectRatio: 1.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: PreviewView(
                                        capturedImage: state.capturedImage,
                                        onRetake: notifier.retakePhoto,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 48),
                                CaptionInput(
                                  controller: _captionController,
                                  onSend: _handleShare,
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: CameraView(
                                  cameraController: state.cameraController,
                                  isCameraInitialized:
                                      state.isCameraInitialized,
                                  isFlashOn: state.isFlashOn,
                                  onTakePicture: notifier.takePicture,
                                  onPickFromGallery: notifier.pickFromGallery,
                                  onFlipCamera: notifier.flipCamera,
                                  onToggleFlash: notifier.toggleFlash,
                                  onShowHistory: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
