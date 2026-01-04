import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class MediaUtils {
  /// Compresses an image from [File] and returns the compressed [File].
  /// [quality] ranges from 0 to 100, default is 80.
  /// [minWidth] and [minHeight] are used to limit the image dimensions.
  static Future<File?> compressImage(
    File file, {
    int quality = 90,
    int minWidth = 1920,
    int minHeight = 1920,
  }) async {
    try {
      final filePath = file.absolute.path;

      // Create output path (append _compressed suffix)
      final lastIndex = filePath.lastIndexOf('.');
      if (lastIndex == -1) return null;

      final outPath = '${filePath.substring(0, lastIndex)}_compressed.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: quality,
        minWidth: minWidth,
        minHeight: minHeight,
        format: CompressFormat.jpeg,
      );

      if (result == null) return null;
      return File(result.path);
    } catch (e) {
      return null;
    }
  }

  /// Checks the file size (returns size in MB)
  static double getFileSizeInMB(File file) {
    int sizeInBytes = file.lengthSync();
    return sizeInBytes / (1024 * 1024);
  }
}
