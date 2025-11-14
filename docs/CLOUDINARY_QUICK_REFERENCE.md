# 🚀 Cloudinary Integration - Quick Reference

> **Quick Start Guide** for Aconsia App Cloudinary Integration

---

## 📋 Checklist Before Using

### 1. Cloudinary Account Setup

- [ ] Create account at [cloudinary.com](https://cloudinary.com)
- [ ] Get your **Cloud Name** from dashboard
- [ ] Create **Upload Preset** (Settings → Upload → Add upload preset)
  - Name: `aconsia_app_preset`
  - Signing Mode: **Unsigned** ✅
  - Folder: Leave empty (we set dynamically)

### 2. Update Configuration

```dart
// lib/core/config/cloudinary_config.dart
static const String cloudName = 'YOUR_CLOUD_NAME';      // ← Change this
static const String uploadPreset = 'aconsia_app_preset'; // ← Your preset name
```

### 3. Platform Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>NSCameraUsageDescription</key>
<string>Kami memerlukan akses kamera untuk mengambil foto</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Kami memerlukan akses galeri untuk memilih foto</string>
```

---

## 💡 3 Ways to Upload Images

### Method 1: ImageUploadWidget (Easiest) ⭐

**Best for**: Profile photos, single image uploads

```dart
import 'package:aconsia_app/core/config/cloudinary_config.dart';
import 'package:aconsia_app/core/helpers/widgets/image_upload_widget.dart';

ImageUploadWidget(
  folder: CloudinaryConfig.dokterPhotosFolder,
  onImageUploaded: (url) {
    print('Image uploaded: $url');
    // Update profile with this URL
  },
  initialImageUrl: currentPhotoUrl, // Optional
  publicId: 'user_123',             // Optional
  label: 'Foto Profil',
  size: 150,
  shape: ImageUploadShape.circle,   // or ImageUploadShape.square
)
```

### Method 2: StateNotifier (More Control)

**Best for**: Custom UI, manual progress handling

```dart
import 'package:aconsia_app/core/providers/providers.dart';

// In your widget:
final uploadState = ref.watch(imageUploadNotifierProvider);

// Upload from gallery
ElevatedButton(
  onPressed: () {
    ref.read(imageUploadNotifierProvider.notifier).uploadFromGallery(
      folder: CloudinaryConfig.dokterPhotosFolder,
    );
  },
  child: Text('Upload'),
)

// Show progress
if (uploadState.isUploading) {
  LinearProgressIndicator(value: uploadState.progress / 100);
  Text('${uploadState.progress}%');
}

// Get result
if (uploadState.isSuccess) {
  print('Uploaded: ${uploadState.imageUrl}');
}
```

### Method 3: Repository Direct (Full Control)

**Best for**: Multiple uploads, custom workflows

```dart
import 'package:aconsia_app/core/providers/providers.dart';

final cloudinaryRepo = ref.read(cloudinaryRepositoryProvider);

// Single upload
final result = await cloudinaryRepo.pickAndUploadFromGallery(
  folder: CloudinaryConfig.dokterPhotosFolder,
  onProgress: (progress) => print('$progress%'),
);

result.fold(
  (failure) => print('Error: ${failure.message}'),
  (imageUrl) => print('Success: $imageUrl'),
);

// Multiple upload
final multiResult = await cloudinaryRepo.pickAndUploadMultiple(
  folder: CloudinaryConfig.sectionImagesFolder,
  maxImages: 5,
  onProgress: (current, total, progress) {
    print('Image $current/$total: $progress%');
  },
);
```

---

## 📁 Folder Structure

Use these constants from `CloudinaryConfig`:

| Use Case         | Folder Constant                          |
| ---------------- | ---------------------------------------- |
| Doctor photos    | `CloudinaryConfig.dokterPhotosFolder`    |
| Patient photos   | `CloudinaryConfig.pasienPhotosFolder`    |
| Content images   | `CloudinaryConfig.kontenImagesFolder`    |
| Section images   | `CloudinaryConfig.sectionImagesFolder`   |
| Chat attachments | `CloudinaryConfig.chatAttachmentsFolder` |

**Storage in Cloudinary**:

```
aconsia/
├── dokter/photos/
├── pasien/photos/
├── konten/images/
├── konten/sections/
└── chat/attachments/
```

---

## 🎨 Common Use Cases

### Profile Photo Update

```dart
class ProfileScreen extends ConsumerWidget {
  final String userId;
  final String userType; // 'dokter' or 'pasien'

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ImageUploadWidget(
      folder: CloudinaryConfig.getFolderForUserType(userType),
      onImageUploaded: (url) async {
        final repo = ref.read(profileRepositoryProvider);

        if (userType == 'dokter') {
          await repo.updateDokterPhotoUrl(uid: userId, photoUrl: url);
        } else {
          await repo.updatePasienPhotoUrl(uid: userId, photoUrl: url);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto profil diperbarui!')),
        );
      },
      publicId: 'user_$userId',
      shape: ImageUploadShape.circle,
    );
  }
}
```

### Konten Editor

```dart
class KontenEditor extends ConsumerWidget {
  final String kontenId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ImageUploadWidget(
      folder: CloudinaryConfig.kontenImagesFolder,
      onImageUploaded: (url) {
        // Save to konten model
        print('Konten image: $url');
      },
      publicId: 'konten_$kontenId',
      shape: ImageUploadShape.square,
      size: 300,
      showCamera: false, // Gallery only for konten
    );
  }
}
```

### Multiple Section Images

```dart
Future<void> uploadSectionImages(WidgetRef ref) async {
  final repo = ref.read(cloudinaryRepositoryProvider);

  final result = await repo.pickAndUploadMultiple(
    folder: CloudinaryConfig.sectionImagesFolder,
    maxImages: 5,
  );

  result.fold(
    (failure) => print('Error: ${failure.message}'),
    (urls) => print('Uploaded ${urls.length} images'),
  );
}
```

---

## 🔧 Configuration Options

### Image Quality Settings

```dart
// Profile photos (balance quality & size)
quality: CloudinaryConfig.profilePhotoQuality, // 85%

// Konten images (high quality)
quality: CloudinaryConfig.kontenImageQuality, // 90%

// Thumbnails (smaller size)
quality: CloudinaryConfig.thumbnailQuality, // 70%
```

### File Constraints

```dart
// Maximum file size
CloudinaryConfig.maxFileSize // 5MB

// Maximum dimensions
CloudinaryConfig.maxImageWidth  // 1920px
CloudinaryConfig.maxImageHeight // 1920px

// Allowed types
CloudinaryConfig.allowedFileTypes // ['jpg', 'jpeg', 'png', 'webp']
```

---

## 🎯 Best Practices

### ✅ DO

```dart
// Use config constants
folder: CloudinaryConfig.dokterPhotosFolder,

// Use meaningful public IDs
publicId: 'user_${userId}',
publicId: 'konten_${kontenId}_${DateTime.now().millisecondsSinceEpoch}',

// Show progress to users
onProgress: (progress) {
  setState(() => _progress = progress);
}

// Handle all error cases
result.fold(
  (failure) => showError(failure.message),
  (url) => onSuccess(url),
);

// Use optimized URLs
final optimizedUrl = cloudinaryRepo.getOptimizedProfileUrl(publicId);
```

### ❌ DON'T

```dart
// Hardcode folder paths
folder: 'aconsia/dokter/photos', // ❌

// Use generic public IDs
publicId: 'image', // ❌

// Ignore progress
onProgress: null, // ❌

// Ignore errors
result.fold((failure) {}, (url) => update(url)); // ❌

// Use original URLs (not optimized)
image: NetworkImage(originalUrl), // ❌
```

---

## 🐛 Troubleshooting

### Upload fails with "Unauthorized"

**Fix**: Check upload preset is **unsigned** in Cloudinary dashboard

### Permission denied

**Fix**: Add camera/gallery permissions to AndroidManifest.xml / Info.plist

### Image too large

**Fix**:

- Increase `CloudinaryConfig.maxFileSize` if needed
- Reduce `imageQuality` parameter
- Enable compression (enabled by default)

### Progress not showing

**Fix**: Provide `onProgress` callback and update state

### Widget not updating after upload

**Fix**: Ensure `onImageUploaded` callback updates parent state

---

## 📚 Full Documentation

For complete details, see:

- 📖 **Main Docs**: `docs/STEP_5_CLOUDINARY_INTEGRATION_COMPLETE.md`
- 💡 **Examples**: `lib/examples/cloudinary_integration_examples.dart`
- 📋 **Summary**: `docs/STEP_5_SUMMARY.md`

---

## 🎁 Available Providers

Import all providers:

```dart
import 'package:aconsia_app/core/providers/providers.dart';
```

### Providers Available

```dart
// Services
final imagePickerService = ref.read(imagePickerServiceProvider);
final imageUploadService = ref.read(imageUploadServiceProvider);

// Repository
final cloudinaryRepo = ref.read(cloudinaryRepositoryProvider);

// State Management
final uploadState = ref.watch(imageUploadNotifierProvider);
final progress = ref.watch(uploadProgressProvider);
final isUploading = ref.watch(isUploadingProvider);
final imageUrl = ref.watch(uploadedImageUrlProvider);
final error = ref.watch(uploadErrorProvider);
```

---

## ⚡ Quick Examples

### Example 1: Simple Upload Button

```dart
ElevatedButton(
  onPressed: () {
    ref.read(imageUploadNotifierProvider.notifier).uploadFromGallery(
      folder: CloudinaryConfig.dokterPhotosFolder,
    );
  },
  child: Text('Upload Photo'),
)
```

### Example 2: With Progress

```dart
final progress = ref.watch(uploadProgressProvider);
final isUploading = ref.watch(isUploadingProvider);

if (isUploading) {
  LinearProgressIndicator(value: progress / 100);
  Text('$progress%');
}
```

### Example 3: Complete Profile Update

```dart
ImageUploadWidget(
  folder: CloudinaryConfig.getFolderForUserType(userType),
  onImageUploaded: (url) async {
    await updateProfile(url);
    showSuccess();
  },
  initialImageUrl: currentPhotoUrl,
  publicId: 'user_$userId',
  shape: ImageUploadShape.circle,
)
```

---

## 🎉 You're Ready!

With this integration, you can:

- ✅ Upload images from camera or gallery
- ✅ Track upload progress in real-time
- ✅ Handle all error cases gracefully
- ✅ Optimize images automatically
- ✅ Store images in organized folders
- ✅ Use reusable UI components

**Start using it now!** 🚀

---

**Need Help?** Check the full documentation in `docs/STEP_5_CLOUDINARY_INTEGRATION_COMPLETE.md`
