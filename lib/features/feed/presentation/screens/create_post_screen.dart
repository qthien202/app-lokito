import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lokito/features/feed/presentation/controllers/create_post_controller.dart';
import 'package:lokito/features/feed/presentation/controllers/create_post_state.dart';
import 'package:lokito/features/feed/presentation/widgets/create_post/index.dart';
import 'package:lokito/i18n/strings.g.dart';
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
    // CRITICAL: Stop the camera immediately when leaving the screen
    ref.read(createPostControllerProvider.notifier).disposeCamera();
    _captionController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    } else {
      // Inactive, Paused, Detached: KILL the camera to stop dropped frame logs
      ref.read(createPostControllerProvider.notifier).disposeCamera();
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
    await ref.read(createPostControllerProvider.notifier).initializeCamera();
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
    final state = ref.read(createPostControllerProvider);
    if (state.capturedImage != null) {
      ref.read(createPostControllerProvider.notifier).retakePhoto();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _handleShare() async {
    final success = await ref
        .read(createPostControllerProvider.notifier)
        .createPost(_captionController.text);
    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createPostControllerProvider);
    final notifier = ref.read(createPostControllerProvider.notifier);

    ref.listen(createPostControllerProvider.select((s) => s.error), (
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
      body: SafeArea(
        child: Column(
          children: [
            TopControls(
              currentStep: state.capturedImage != null
                  ? CreatePostStep.preview
                  : CreatePostStep.camera,
              hasImage: state.capturedImage != null,
              onBack: _handleBack,
              onSend: _handleShare,
              onGallery: notifier.pickFromGallery,
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state.capturedImage != null)
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: const Color(0xFF1A1A1A),
                            ),
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
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
                        ],
                      )
                    else
                      Expanded(
                        child: CameraView(
                          cameraController: state.cameraController,
                          isCameraInitialized: state.isCameraInitialized,
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
    );
  }
}
