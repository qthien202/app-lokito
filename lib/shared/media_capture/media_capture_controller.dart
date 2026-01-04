import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'media_capture_state.dart';

class MediaCaptureController extends Notifier<MediaCaptureState> {
  final ImagePicker _picker = ImagePicker();
  CameraController? _currentController;

  @override
  MediaCaptureState build() {
    ref.onDispose(() {
      _currentController?.dispose();
    });
    return const MediaCaptureState();
  }

  Future<void> disposeCamera() async {
    final controller = _currentController;
    if (controller != null) {
      _currentController = null;
      state = state.copyWith(
        cameraController: null,
        isCameraInitialized: false,
      );
      await controller.dispose();
    }
  }

  Future<void> initializeCamera() async {
    if (state.isCameraInitialized && state.cameraController != null) return;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final camera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      await disposeCamera();

      // Delay nhỏ để tránh xung đột với hiệu ứng chuyển màn hình trên Android
      await Future.delayed(const Duration(milliseconds: 100));

      final controller = CameraController(
        camera,
        ResolutionPreset
            .medium, // Medium cực kỳ ổn định, không gây log rác BufferQueue
        enableAudio: false,
      );

      await controller.initialize();

      _currentController = controller;
      state = state.copyWith(
        cameras: cameras,
        cameraController: controller,
        isCameraInitialized: true,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCameraInitialized: false);
    }
  }

  Future<void> takePicture() async {
    if (state.cameraController == null || !state.isCameraInitialized) return;

    try {
      final XFile image = await state.cameraController!.takePicture();
      state = state.copyWith(
        capturedImage: File(image.path),
        currentStep: MediaCaptureStep.preview,
      );
    } catch (e) {
      state = state.copyWith(error: 'failedToTakePhoto');
    }
  }

  Future<void> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        state = state.copyWith(
          capturedImage: File(image.path),
          currentStep: MediaCaptureStep.preview,
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'failedToPickImage');
    }
  }

  void toggleFlash() async {
    if (state.cameraController == null) return;

    try {
      final newFlashMode = !state.isFlashOn;
      await state.cameraController!.setFlashMode(
        newFlashMode ? FlashMode.torch : FlashMode.off,
      );
      state = state.copyWith(isFlashOn: newFlashMode);
    } catch (e) {
      state = state.copyWith(error: 'failedToToggleFlash');
    }
  }

  void flipCamera() async {
    if (state.cameras.length < 2) return;

    try {
      final newIsRear = !state.isRearCamera;
      state = state.copyWith(isCameraInitialized: false);

      await disposeCamera();

      final camera = state.cameras.firstWhere(
        (camera) =>
            camera.lensDirection ==
            (newIsRear ? CameraLensDirection.back : CameraLensDirection.front),
        orElse: () => state.cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      _currentController = controller;
      state = state.copyWith(
        cameraController: controller,
        isCameraInitialized: true,
        isRearCamera: newIsRear,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'failedToFlipCamera',
        isCameraInitialized: false,
      );
    }
  }

  void retakePhoto() {
    state = state.copyWith(
      capturedImage: null,
      currentStep: MediaCaptureStep.camera,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final mediaCaptureControllerProvider =
    NotifierProvider.autoDispose<MediaCaptureController, MediaCaptureState>(
      MediaCaptureController.new,
    );
