// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_photo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseStorageServiceHash() =>
    r'441add092abe957a7657be3a4b4a3d9ce04e199e';

/// See also [firebaseStorageService].
@ProviderFor(firebaseStorageService)
final firebaseStorageServiceProvider =
    AutoDisposeProvider<FirebaseStorageService>.internal(
  firebaseStorageService,
  name: r'firebaseStorageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseStorageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseStorageServiceRef
    = AutoDisposeProviderRef<FirebaseStorageService>;
String _$uploadDokterProfilePhotoHash() =>
    r'758b53f03ad5fd56bd8b8796d78adb59a1668bbd';

/// See also [uploadDokterProfilePhoto].
@ProviderFor(uploadDokterProfilePhoto)
final uploadDokterProfilePhotoProvider =
    AutoDisposeProvider<UploadDokterProfilePhoto>.internal(
  uploadDokterProfilePhoto,
  name: r'uploadDokterProfilePhotoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uploadDokterProfilePhotoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UploadDokterProfilePhotoRef
    = AutoDisposeProviderRef<UploadDokterProfilePhoto>;
String _$uploadPhotoControllerHash() =>
    r'52b020d979fc50171435f0aadc74770a559b287c';

/// Controller untuk upload dokter profile photo
///
/// Copied from [UploadPhotoController].
@ProviderFor(UploadPhotoController)
final uploadPhotoControllerProvider = AutoDisposeNotifierProvider<
    UploadPhotoController, UploadPhotoState>.internal(
  UploadPhotoController.new,
  name: r'uploadPhotoControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uploadPhotoControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UploadPhotoController = AutoDisposeNotifier<UploadPhotoState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
