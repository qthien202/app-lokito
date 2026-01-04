import 'dart:io';

import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_capture_state.freezed.dart';

enum MediaCaptureStep { camera, preview, caption }

@freezed
abstract class MediaCaptureState with _$MediaCaptureState {
  const factory MediaCaptureState({
    @Default([]) List<CameraDescription> cameras,
    CameraController? cameraController,
    @Default(false) bool isCameraInitialized,
    @Default(false) bool isFlashOn,
    @Default(true) bool isRearCamera,
    File? capturedImage,
    @Default(MediaCaptureStep.camera) MediaCaptureStep currentStep,
    @Default(false) bool isLoading,
    String? error,
  }) = _MediaCaptureState;
}
