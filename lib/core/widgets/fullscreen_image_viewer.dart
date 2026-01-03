import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../constants/app_routes.dart';

class FullscreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;
  final String? title;
  final List<String>? imageUrls;
  final int? initialIndex;

  const FullscreenImageViewer({
    super.key,
    required this.imageUrl,
    this.heroTag,
    this.title,
    this.imageUrls,
    this.initialIndex,
  });

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {
  late PageController _pageController;
  
  int _currentIndex = 0;
  bool _showOverlay = true;
  bool _isDismissing = false;
  double _dismissOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;
    _pageController = PageController(initialPage: _currentIndex);
    
    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  @override
  void dispose() {
    _pageController.dispose();
    
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleOverlay() {
    setState(() {
      _showOverlay = !_showOverlay;
    });
  }

  void _onImageTap() {
    _toggleOverlay();
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _isDismissing = true;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!_isDismissing) return;
    
    setState(() {
      _dismissOffset += details.delta.dy;
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (!_isDismissing) return;
    
    _isDismissing = false;
    
    // If dragged far enough or with enough velocity, dismiss
    final shouldDismiss = _dismissOffset.abs() > 100 || 
                         details.velocity.pixelsPerSecond.dy.abs() > 300;
    
    if (shouldDismiss) {
      _closeViewer();
    } else {
      // Snap back to original position
      setState(() {
        _dismissOffset = 0.0;
      });
    }
  }

  void _closeViewer() {
    context.pop();
  }

  List<String> get _images {
    if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty) {
      return widget.imageUrls!;
    }
    return [widget.imageUrl];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(1.0 - (_dismissOffset.abs() / 400).clamp(0.0, 0.8)),
      body: GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Transform.translate(
          offset: Offset(0, _dismissOffset),
          child: Stack(
            children: [
              // Image viewer
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  final imageUrl = _images[index];
                  final isCurrentImage = index == (widget.initialIndex ?? 0) && 
                                       imageUrl == widget.imageUrl;
                  
                  return GestureDetector(
                    onTap: _onImageTap,
                    child: Center(
                      child: Hero(
                        tag: isCurrentImage && widget.heroTag != null 
                            ? widget.heroTag! 
                            : 'image_$index',
                        child: InteractiveViewer(
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: double.infinity,
                                height: double.infinity,
                                color: Colors.grey[900],
                                child: const Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        LucideIcons.imageOff,
                                        color: Colors.white54,
                                        size: 64,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Failed to load image',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              
              // Top overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedOpacity(
                  opacity: _showOverlay ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: _closeViewer,
                              icon: const Icon(
                                LucideIcons.x,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.title != null)
                                    Text(
                                      widget.title!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  if (_images.length > 1)
                                    Text(
                                      '${_currentIndex + 1} of ${_images.length}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Add share functionality
                              },
                              icon: const Icon(
                                LucideIcons.share,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Add download functionality
                              },
                              icon: const Icon(
                                LucideIcons.download,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Bottom overlay with page indicators
              if (_images.length > 1)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _showOverlay ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _images.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: index == _currentIndex
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to show fullscreen image viewer using go_router
void showFullscreenImage(
  BuildContext context, {
  required String imageUrl,
  String? heroTag,
  String? title,
  List<String>? imageUrls,
  int? initialIndex,
}) {
  final queryParams = <String, String>{
    'imageUrl': imageUrl,
    if (heroTag != null) 'heroTag': heroTag,
    if (title != null) 'title': title,
    if (imageUrls != null) 'imageUrls': imageUrls.join(','),
    if (initialIndex != null) 'initialIndex': initialIndex.toString(),
  };
  
  context.push(Uri(
    path: AppRoutes.fullscreenImage,
    queryParameters: queryParams,
  ).toString());
}