import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aconsia_app/core/providers/providers.dart';

/// Reusable widget for image upload with preview and progress
///
/// **Features:**
/// - Image preview
/// - Upload progress indicator
/// - Camera/Gallery selection
/// - Error handling
/// - Success feedback
///
/// **Usage:**
/// ```dart
/// ImageUploadWidget(
///   folder: CloudinaryConfig.dokterPhotosFolder,
///   onImageUploaded: (url) {
///     // Handle uploaded URL
///     print('Image uploaded: $url');
///   },
///   initialImageUrl: currentPhotoUrl,
/// )
/// ```
class ImageUploadWidget extends ConsumerStatefulWidget {
  /// Cloudinary folder to upload to
  final String folder;

  /// Callback when image is successfully uploaded
  final Function(String url) onImageUploaded;

  /// Initial image URL to display
  final String? initialImageUrl;

  /// Custom public ID for the upload (optional)
  final String? publicId;

  /// Show camera option
  final bool showCamera;

  /// Show gallery option
  final bool showGallery;

  /// Widget size (diameter for circular, width for square)
  final double size;

  /// Shape of the widget
  final ImageUploadShape shape;

  /// Label text above the widget
  final String? label;

  const ImageUploadWidget({
    super.key,
    required this.folder,
    required this.onImageUploaded,
    this.initialImageUrl,
    this.publicId,
    this.showCamera = true,
    this.showGallery = true,
    this.size = 120,
    this.shape = ImageUploadShape.circle,
    this.label,
  });

  @override
  ConsumerState<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends ConsumerState<ImageUploadWidget> {
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    _currentImageUrl = widget.initialImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(imageUploadNotifierProvider);

    // Update current image when upload succeeds
    if (uploadState.isSuccess && uploadState.imageUrl != null) {
      if (_currentImageUrl != uploadState.imageUrl) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _currentImageUrl = uploadState.imageUrl;
          });
          widget.onImageUploaded(uploadState.imageUrl!);
          // Reset state after callback
          ref.read(imageUploadNotifierProvider.notifier).reset();
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
        ],

        // Image preview with upload button
        _buildImagePreview(context, uploadState),

        const SizedBox(height: 8),

        // Progress indicator
        if (uploadState.isUploading) ...[
          const SizedBox(height: 8),
          SizedBox(
            width: widget.size,
            child: LinearProgressIndicator(
              value: uploadState.progress / 100,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${uploadState.progress}%',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],

        // Error message
        if (uploadState.errorMessage != null &&
            uploadState.errorMessage!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            width: widget.size,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              uploadState.errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],

        // Upload button/options
        if (!uploadState.isUploading) ...[
          const SizedBox(height: 12),
          _buildUploadButton(context),
        ],
      ],
    );
  }

  Widget _buildImagePreview(
      BuildContext context, ImageUploadState uploadState) {
    Widget imageWidget;

    if (_currentImageUrl != null && _currentImageUrl!.isNotEmpty) {
      // Show uploaded image
      imageWidget = Image.network(
        _currentImageUrl!,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      // Show placeholder
      imageWidget = _buildPlaceholder();
    }

    // Apply shape
    if (widget.shape == ImageUploadShape.circle) {
      imageWidget = ClipOval(child: imageWidget);
    } else {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: imageWidget,
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          imageWidget,

          // Upload overlay when uploading
          if (uploadState.isUploading)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: widget.shape == ImageUploadShape.circle
                    ? BoxShape.circle
                    : BoxShape.rectangle,
                borderRadius: widget.shape == ImageUploadShape.square
                    ? BorderRadius.circular(12)
                    : null,
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: widget.shape == ImageUploadShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: widget.shape == ImageUploadShape.square
            ? BorderRadius.circular(12)
            : null,
      ),
      child: Icon(
        Icons.person,
        size: widget.size * 0.5,
        color: Colors.grey[400],
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context) {
    if (widget.showCamera && widget.showGallery) {
      // Show both options
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () => _uploadFromCamera(),
            icon: const Icon(Icons.camera_alt, size: 20),
            label: const Text('Kamera'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () => _uploadFromGallery(),
            icon: const Icon(Icons.photo_library, size: 20),
            label: const Text('Galeri'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    } else if (widget.showCamera) {
      return ElevatedButton.icon(
        onPressed: () => _uploadFromCamera(),
        icon: const Icon(Icons.camera_alt),
        label: const Text('Ambil Foto'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      );
    } else if (widget.showGallery) {
      return ElevatedButton.icon(
        onPressed: () => _uploadFromGallery(),
        icon: const Icon(Icons.photo_library),
        label: const Text('Pilih dari Galeri'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<void> _uploadFromCamera() async {
    await ref.read(imageUploadNotifierProvider.notifier).uploadFromCamera(
          folder: widget.folder,
          publicId: widget.publicId,
        );
  }

  Future<void> _uploadFromGallery() async {
    await ref.read(imageUploadNotifierProvider.notifier).uploadFromGallery(
          folder: widget.folder,
          publicId: widget.publicId,
        );
  }
}

/// Shape options for ImageUploadWidget
enum ImageUploadShape {
  circle,
  square,
}

/// Extension for ImageUploadShape
extension ImageUploadShapeExtension on ImageUploadShape {
  String get name {
    switch (this) {
      case ImageUploadShape.circle:
        return 'Circle';
      case ImageUploadShape.square:
        return 'Square';
    }
  }
}
