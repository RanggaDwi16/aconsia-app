/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ic_call.svg
  SvgGenImage get icCall => const SvgGenImage('assets/icons/ic_call.svg');

  /// File path: assets/icons/ic_delete.svg
  SvgGenImage get icDelete => const SvgGenImage('assets/icons/ic_delete.svg');

  /// File path: assets/icons/ic_doctor.svg
  SvgGenImage get icDoctor => const SvgGenImage('assets/icons/ic_doctor.svg');

  /// File path: assets/icons/ic_done.svg
  SvgGenImage get icDone => const SvgGenImage('assets/icons/ic_done.svg');

  /// File path: assets/icons/ic_edit.svg
  SvgGenImage get icEdit => const SvgGenImage('assets/icons/ic_edit.svg');

  /// File path: assets/icons/ic_heart.svg
  SvgGenImage get icHeart => const SvgGenImage('assets/icons/ic_heart.svg');

  /// File path: assets/icons/ic_home.svg
  SvgGenImage get icHome => const SvgGenImage('assets/icons/ic_home.svg');

  /// File path: assets/icons/ic_konten.svg
  SvgGenImage get icKonten => const SvgGenImage('assets/icons/ic_konten.svg');

  /// File path: assets/icons/ic_peoples.svg
  SvgGenImage get icPeoples => const SvgGenImage('assets/icons/ic_peoples.svg');

  /// File path: assets/icons/ic_person.svg
  SvgGenImage get icPerson => const SvgGenImage('assets/icons/ic_person.svg');

  /// File path: assets/icons/ic_ring_donw.svg
  SvgGenImage get icRingDonw =>
      const SvgGenImage('assets/icons/ic_ring_donw.svg');

  /// File path: assets/icons/ic_save.svg
  SvgGenImage get icSave => const SvgGenImage('assets/icons/ic_save.svg');

  /// File path: assets/icons/ic_star.svg
  SvgGenImage get icStar => const SvgGenImage('assets/icons/ic_star.svg');

  /// File path: assets/icons/ic_upload.svg
  SvgGenImage get icUpload => const SvgGenImage('assets/icons/ic_upload.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        icCall,
        icDelete,
        icDoctor,
        icDone,
        icEdit,
        icHeart,
        icHome,
        icKonten,
        icPeoples,
        icPerson,
        icRingDonw,
        icSave,
        icStar,
        icUpload
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/img_konten.png
  AssetGenImage get imgKonten =>
      const AssetGenImage('assets/images/img_konten.png');

  /// File path: assets/images/placeholder_img.png
  AssetGenImage get placeholderImg =>
      const AssetGenImage('assets/images/placeholder_img.png');

  /// List of all assets
  List<AssetGenImage> get values => [imgKonten, placeholderImg];
}

class Assets {
  const Assets._();

  static const String aEnv = '.env';
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();

  /// List of all assets
  static List<String> get values => [aEnv];
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
