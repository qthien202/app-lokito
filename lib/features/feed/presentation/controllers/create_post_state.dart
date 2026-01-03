import 'dart:io';
import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_post_state.freezed.dart';

enum CreatePostStep { camera, preview, caption }

@freezed
abstract class CreatePostState with _$CreatePostState {
  const factory CreatePostState({
    @Default([]) List<CameraDescription> cameras,
    CameraController? cameraController,
    @Default(false) bool isCameraInitialized,
    @Default(false) bool isFlashOn,
    @Default(true) bool isRearCamera,
    File? capturedImage,
    @Default(CreatePostStep.camera) CreatePostStep currentStep,
    @Default(false) bool isLoading,
    String? error,
  }) = _CreatePostState;
}
